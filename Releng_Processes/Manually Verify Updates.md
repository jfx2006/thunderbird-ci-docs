Manually Verify Updates
=======================

Occasionally the Update Verify jobs fail, and it might be useful to test the process yourself.

## Requirements

* A machine to run the update on. In CI this happens on Linux
* Python (2.7 is still in use)
* A copy of "compare-directories.py" from a M-C checkout.
	* *M-C:tools/update-verify/release/compare-directories.py*
* Starting version package on the test machine (Linux)
	* thunderbird-68.0b4.tar.bz2
* Starting version package for the target platform:
	* Thunderbird 68.0b4.dmg for macOS
	* Thunderbird Setup 68.0b4.exe for windows
	* thunderbird-68.0b4.tar.bz2 for linux
* Destination version package for the target platform:
	* Thunderbird 69.0b1.dmg for macOS
	* Thunderbird Setup 68.0b1.exe for windows
	* thunderbird-69.0b1.tar.bz2 for linux
* A mar file to test for the Destination version on the target platform
	*  thunderbird-69.0b1.complete.mar

Make sure that all of these packages are for the same locale.

## Unpack

* Unpack the test machine package. If you're on Linux it will unpack into a directory named "thunderbird"
	* `tar xvf thunderbird-68.0b4.tar.bz2`
* Create start and destination directories
	* `mkdir start destination`
* Unpack the Start version inro start, Destination version in destination
	* `( cd start; 7z x "../Thunderbird 68.0b4.dmg" )`
	* `( cd destination; 7z x "../Thunderbird 69.0b1.dmg" )`
* **macOSX only** Mangling
	* `( cd start
		mv "Thunderbird/Thunderbird.app" .
		rm -rf Thunderbird
		cp Thunderbird.app/Contents/Resources/{update-settings.ini,precomplete} Thunderbird.app/ )`

	* `( cd destination
		mv "Thunderbird/Thunderbird.app" .
		rm -rf Thunderbird )`


## Run updater

* Make sure you are in the top of your directory structure, you should see three directories: *thunderbird*, *start*, *destination*, and your downloaded files.
* Set some variables
	* `updater=$(realpath thunderbird/updater)`
	* `update=$(realpath thunderbird/update)`
* Copy mar file into update directory
	* `cp thunderbird-69.0b1.complete.mar "$update/update.mar"`
* Run update program
	* `pushd start/Thunderbird.app`
	* Yes,. run it just like this. It's sort of a silly program to run from the commandline.
	* `"$updater" "$update" $(pwd) $(pwd) 0``
	* `popd`
* View log file. Look for errors.
	* `less "${update}/update.log"`
* **macOSX only** Undo Mangling
	* `rm -f start/Thunderbird.app/{update-settings.ini,precomplete}`

## Compare Start to Destination

* Run compare-directories.py
	* `python compare-directories.py --verbose start/Thunderbird.app destination/Thunderbird.app beta-localtest`
* You will get output indicating anything that is different. 

```
Comparing start/Thunderbird.app with destination/Thunderbird.app...
Files only in start/Thunderbird.app:
  Contents/Library/Spotlight/thunderbird.mdimporter/Contents/_CodeSignature/._CodeResources
```

## Analysis

In the macOS UV example here, we find that there is an extraneous file left behind during the update process due to a code signing bug in a previous version. In this case the updater needs to be told to look for and remove that extra file if it exists which should fix this issue.