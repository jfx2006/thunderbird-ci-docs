Thunderbird Win64 Migration for Users
=====================================

Users of 32-bit Thunderbird on 64-bit Windows systems with at least 3GB of RAM will be migrated to 64-bit Thunderbird when Thunderbird 68.2.1 is released.

If you prefer to continue using 32-bit Thunderbird, see "Opt-out of auto migration" below.

Auto-migration is facilitated through the automatic updates service, and will only affect Thunderbird versions up to 68.2.0.

## Opt-out of auto migration

There are two ways to opt-out of automigration. **Option 1 is recommended for most users.**

1. Install the 32-bit version of Thunderbird 68.2.1. You can safely run the installer on top of your existing installation. 
1. Set one or more registry keys listed below.

### Registry Keys

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