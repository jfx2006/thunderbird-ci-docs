Testing macOS Addressbook permissions
=====================================

I am testing on a fresh macOS install of 10.15 Catalina

## Check initial state

* Open System Settings -> Security and Privacy
* Select the "Privacy" tab
* In the list of macOS services on the left, select "Contacts"
* The list of Applications that comes up should not  include Thunderbird
* Verify the same for "Camera", "Microphone", and "Location Services"
* Close the Security and Privacy application

## Install Thunderbird Daily

* Any build from 2019-10-14 or later, any language
* Upgrading from an older Daily should work as well
* ftp.mozilla.org/pub/thinderbird/nightly

## Run Thunderbird Daily

* Start Thunderbird. macOS will do some verificiation and then show a popup asking if you trust the application. It should state that no malicious software was found. Click  Open.
* A popup should appear asking for permission to acces contacts. Click Ok

## Verify Addressbook Permission

* Open the Security and Privacy settings as above and check that Thunderbird is listed in the applications that have Contacts access.
* Thunderbird will not be listed for Location, Camera, or Microphone as these permissions are requested but not used at this time.

## Check Addressbook functionality

* Create and update some contacts both in Thunderbird and in the macOS Contacts application and verify that Contacts sees changes made by Thunderbird and vice-versa.
	* **I'm not 100%  about what sort of sync should happen here, in my testig updating a contact on both sides resulted in newer changes overwriting older ones.**

# Results

```
macOS version tested:
Profile: [  ] new    [  ] upgraded
Did you see the popup asking for permission for Thunderbird to use Contacts? [   ] yes [   ] no
Other comments:
```