Manually Verify Updates
=======================

Occasionally the Update Verify jobs fail, and it might be useful to test the process yourself.

## Requirements

* A machine to run the update on. In CI this happens on Linux
* Starting version package on the test machine (Linux)
	* thunderbird-68.0b4.tar.bz2
* Starting version package on the target platform:
	* Thunderbird 68.0b4.dmg for macOS
	* Thunderbird Setup 68.0b4.exe for windows
	* thunderbird-68.0b4.tar.bz2 for linux
* A mar file to test for the Destination version on the target platform
	*  thunderbird-69.0b1.complete.mar

Make sure that all of these packages are for the same locale.

## Unpack

* Unpack the test machine package. If you're on Linux it will unpack into a directory named "thunderbird"
	* tar xvf thunderbird-68.0b4.tar.bz2
* Create start and destination directories
	* mkdir start destination
* Unpack the Start version inro start, Destination version in destination
	* ( cd start; 7z x "../Thunderbird 68.0b4.dmg" )
	* ( cd destination; 7z x )