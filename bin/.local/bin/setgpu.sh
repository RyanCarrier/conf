#!/usr/bin/env bash
set -e
CARD_ID=card1
# HWMON_ID=hwmon0
HWMON_ID=hwmon6

# check user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
ARG_OPTIONS=("james" "default" "gaming")
# check arguments for one of the f
I=-1
for i in "${!ARG_OPTIONS[@]}"; do
    if [[ "${ARG_OPTIONS[$i]}" = "$1" ]]; then
        I=$i
        break
    fi
done
if [[ $I -eq -1 ]]; then
    echo "Invalid argument, must be one of [" "${ARG_OPTIONS[@]}" "] urs was '$1', loser"
    exit 1
fi

PL=(231 257 275)          # watts
SCLK_MAX=(2600 2895 2900) # mhz
# MCLK_MAX=(1050 1250 1200) # mhz
# VOLT_OFF=(-144 0 -50) # mvolts
# reduce them as random crashes while e2e with AVD????
MCLK_MAX=(1075 1250 1200) # mhz
VOLT_OFF=(-130 0 -50)     # mvolts
TEMP_TGT=(70 95 85)       # c but does this even do anything
# Pin the VRAM (memory) clock so it can't idle down to 96MHz, which starves
# dual high-refresh displays -> DCN underflow -> horizontal-band artifacts.
# "top" = highest DPM state (safest). A lower state (e.g. 2) saves idle power
# if it still avoids artifacts; "off" leaves memory fully dynamic (buggy).
MCLK_PIN=(top top top) # per profile: james default gaming

# fan curve (celcius, percentage)
FAN_CURVE1=(
    "40 25"
    "50 30"
    "65 40"
    "75 75"
    "85 100"
)
#this isn't actually default but wtf is the default and it sucks anyway
FAN_CURVE2=(
    "40 25"
    "50 25"
    "65 30"
    "75 40"
    "85 75"
)
FAN_CURVE3=(
    "40 25"
    "50 30"
    "65 75"
    "75 100"
    "85 100"
)
#if I is 0 then fancurve0
if [[ $I -eq 0 ]]; then
    FAN_CURVE=("${FAN_CURVE1[@]}")
elif [[ $I -eq 1 ]]; then
    FAN_CURVE=("${FAN_CURVE2[@]}")
elif [[ $I -eq 2 ]]; then
    FAN_CURVE=("${FAN_CURVE3[@]}")
else
    echo "idk how u got here " "${ARG_OPTIONS[@]}"
    exit 1
fi

GPU_SYSFS="/sys/class/drm/$CARD_ID/device"
HWMON_SYSFS="$GPU_SYSFS/hwmon/$HWMON_ID"
FAN_CTRL_SYSFS="$GPU_SYSFS/gpu_od/fan_ctrl"

# switch to manual so overdrive + per-clock DPM pins below take effect
echo "manual" >"$GPU_SYSFS/power_dpm_force_performance_level"

# set power limit
echo -e "Power limit;\t${PL[$I]}W"
echo "$((${PL[$I]} * 10 ** 6))" >"$HWMON_SYSFS/power1_cap"

# set pstate1 clocks (max)
echo -e "Clocks;\t\tcore ${SCLK_MAX[$I]}mhz, mem ${MCLK_MAX[$I]}mhz"
echo "s 1 ${SCLK_MAX[$I]}" >"$GPU_SYSFS/pp_od_clk_voltage"
echo "m 1 ${MCLK_MAX[$I]}" >"$GPU_SYSFS/pp_od_clk_voltage"
echo -e "V offset;\t${VOLT_OFF[$I]}mV"
echo "vo ${VOLT_OFF[$I]}" >"$GPU_SYSFS/pp_od_clk_voltage"

# set temperature target
echo -e "Tmp target;\t${TEMP_TGT[$I]}c"
echo "${TEMP_TGT[$I]}" >"$FAN_CTRL_SYSFS/fan_target_temperature"

# echo "c" > "$GPU_SYSFS/pp_od_clk_voltage"
# echo "c" | tee "$GPU_SYSFS/pp_od_clk_voltage" | tee "$FAN_CTRL_SYSFS/fan_target_temperature"
echo "Applying..."
echo "c" >"$GPU_SYSFS/pp_od_clk_voltage"
echo "c" >"$FAN_CTRL_SYSFS/fan_target_temperature"

# fan control
echo "Setting fan curve"
for i in "${!FAN_CURVE[@]}"; do
    echo "$i ${FAN_CURVE[$i]}" >"$FAN_CTRL_SYSFS/fan_curve"
done
echo "Applying..."
echo "c" >"$FAN_CTRL_SYSFS/fan_curve"

# --- stop multi-monitor VRAM underflow (horizontal-band artifacts) ---
# Keep the core clock (sclk) fully dynamic so it still idles low and boosts
# under load, but pin the memory clock (mclk) high so it never drops to the
# 96MHz idle state that can't feed dual high-refresh displays.
SCLK_MASK=$(seq 0 "$(($(grep -c ':' "$GPU_SYSFS/pp_dpm_sclk") - 1))" | tr '\n' ' ')
echo "$SCLK_MASK" >"$GPU_SYSFS/pp_dpm_sclk"
if [[ "${MCLK_PIN[$I]}" == "off" ]]; then
    echo -e "Mem pin;\toff (memory left fully dynamic)"
else
    if [[ "${MCLK_PIN[$I]}" == "top" ]]; then
        MCLK_STATE=$(($(grep -c ':' "$GPU_SYSFS/pp_dpm_mclk") - 1))
    else
        MCLK_STATE="${MCLK_PIN[$I]}"
    fi
    echo -e "Mem pin;\tsclk [$SCLK_MASK] dynamic, mclk pinned to state $MCLK_STATE"
    echo "$MCLK_STATE" >"$GPU_SYSFS/pp_dpm_mclk"
fi
