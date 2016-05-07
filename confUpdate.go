package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	pwd, _ := os.Getwd()
	pwd += "/"
	home := GetLnFolder() + "/"
	for _, file := range GetHiddenFiles() {
		if CheckFileExists(home + file.Name()) {
			oldFile, _ := os.Stat(home + file.Name())
			if !os.SameFile(oldFile, file) {
				BackupFileExists(home + file.Name())
				lns(file.Name(), pwd, home)
			}
		} else {
			lns(file.Name(), pwd, home)
		}

	}

}

func lns(file string, fromFolder string, toFolder string) {
	err := os.Symlink(fromFolder+file, toFolder+file)
	if err != nil {
		fmt.Println(err.Error())
	}
}

//BackupFileExists makes a backup if the file exists
func BackupFileExists(file string) {
	err := os.Rename(file, file+".backup")
	if err != nil {
		fmt.Println(err.Error())
	}
}

//CheckFileExists returns a bool whether or not the file exists
func CheckFileExists(file string) bool {
	_, err := os.Stat(file)
	return err == nil
}

//GetHiddenFiles gets the hidden files
func GetHiddenFiles() []os.FileInfo {
	pwd, _ := os.Getwd()
	pwd += "/"
	dirs, _ := ioutil.ReadDir(pwd)
	finalDirs := make([]os.FileInfo, len(dirs))
	i := 0
	for _, f := range dirs {
		if f.IsDir() || len(f.Name()) < 1 || []byte(f.Name())[0] != []byte(".")[0] {
			continue
		}
		finalDirs[i] = f
		i++
	}
	return finalDirs[:i]
}

//GetLnFolder getst he ln folder? idk
func GetLnFolder() string {
	home := os.Getenv("HOME")
	return home
}
