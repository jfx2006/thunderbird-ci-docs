Win32 to Win64 Automigrate Testing
==================================

How to test the win32 to win64 automigration.

**The current plan is to enable automigration with the 68.2.1 release. This document refers to 68.2, which is configured for automigration on release-localtest only. After 68.2.1 is released, the release-localtest channel will be updaated to match the release channel.**

### Prerequisites

- A 64-bit Windows OS with > 2G RAM\*
- Win32 Thunderbird installed, preferably version < 60.9. **Thunderbird must be installed with EXE installer, not from a ZIP file.**
- channel-prefs.js is configured to use **release-localtest**
- Some combination of mail, calendar, and addressbooks are set up. Verifying extensions other than Calendar is outside the scope of this test.

\* *Users are eligible for a 64-bit default if they are running 64-bit Windows 7+ and have strictly more than 2 GB RAM (so 3 GB is effectively the minimum memory requirement). For users with less than 4 GB of physical memory, there is a trade-off between the larger virtual address space and the overhead of 64-bit code. 2 GB RAM is Microsoft's minimum memory requirement for Windows 7 and 10.*

## Testing

### Scenario A: No opt-out

1. Verify current Thunderbird version via Help->About. It should say 32-bit. Versions < 60.9 continue with step 1a, versions >= 60.9 and < 68.2 continue with step 2.

	1a. Auto-update will download and install Thunderbird 60.9 (32-bit). Restart Thunderbird.

	1b. Verify that version 60.9 (32-bit) is installed via Help-About.

1. Auto-update will download and install Thunderbird 68.2 (64-bit). Restart Thunderbird.

1. Verify that the existing profile is used. Accounts and such should not need to be set up again.

1. Verify that version 68.2 (64-bit) is installed via Help->About.


### Scenario B: Opt-out, v1

*This scenario assumes an installation of Thunderbird (32-bit) 60.9 on a 64-bit OS with sufficient RAM.*

1.  Make sure Thunderbird is not running. Set one of the registry keys below.

1.  Start Thunderbird. Open Help->About. Auto-update will download and install Thunderbird 68.2 (32-bit). Restart Thunderbird.

1. Verify that the existing profile is used.

1. Verify that version 68.2 (32-bit) in installed via Help->About.


### Scenario C: Opt-out, v2

*This scenario tests that a user who has installed win32 Thunderbird >= 68.2 will not get migrated. This is the "simple" opt-out method for non-registry editing users.*

1. Start with a 32-bit Thunderbird version <= 60.9 on eligible 64-bit host operating system.

1. Make sure Thunderbird is not running. Download the win32 installer for version 68.2 from the Thunderbird website.

1. Install Thunderbird 68.2 (32-bit) on top of the existing installation.

1. Start Thunderbird, and open Help->About. Verify no updates. If a version > 68.2 is downloaded, restart and verify that it is a 32-bit version.

1. Verify that the existing profile is used.


### Opt-Out Registry Keys

* To disable migration for all Thunderbird installations on a client system for all users, create the following registry entry:
	* Path: HKEY\_LOCAL\_MACHINE\Software\Wow6432Node\Mozilla\Thunderbird\32to64DidMigrate
	* Value Type: DWORD (32 bit) Value
	* Value Name: Never
	* Value: 1

* To disable migration for all Thunderbird installations on a client system only for the current user, create the following registry entry:
	* Path: HKEY\_CURRENT\_USER\SOFTWARE\Mozilla\Thunderbird\32to64DidMigrate
	* Value Type: DWORD (32 bit) Value
	* Value Name: Never
	* Value: 1

* To disable migration for a single Thunderbird installation on a client system for all users, create the following registry entry:
	* Path: HKEY\_LOCAL\_MACHINE\Software\Wow6432Node\Mozilla\Thunderbird\32to64DidMigrate
	* Value Type: DWORD (32 bit) Value
	* Value Name: \<Windows path to the installation directory without a trailing backslash> (Important: do NOT include a trailing backslash!)
		* example: C:\Program Files (x86)\Mozilla Thunderbird
	* Value: 1

* To disable migration for a single Thunderbird installation on a client system only for the current user, create the following registry entry:
	* Path: HKEY\_CURRENT\_USER\SOFTWARE\Mozilla\Thunderbird\32to64DidMigrate
	* Value Type: DWORD (32 bit) Value
	* Value Name: \<Windows path to the installation directory without a trailing backslash> (Important: do NOT include a trailing backslash!)
		* example: C:\Program Files (x86)\Mozilla Thunderbird
	* Value: 1