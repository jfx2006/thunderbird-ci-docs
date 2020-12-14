# Thunderbird MSI Installers


This article is for IT Admins who want to configure Thunderbird on their organization's computers.

Thunderbird offers MSI installers per locale, per cpu architecture (32 and 64 bit) on beta and release channels for Thunderbird 68.0 and newer.

The MSI installer (supported on Windows 7 and later versions) is a wrapper of the exe full installer that allows customizations through the use of a MST file prior to deploying through standard Windows deployment tools such as Active Directory or Microsoft System Center Configuration Manager.

The MSI installer and this documentation are based on the same for Firefox.

## Beta versions
The MSI installer is currently a beta feature. If something isn't working, or you have an idea for a new feature, you can [open a bug](https://bugzilla.mozilla.org/enter_bug.cgi?product=Thunderbird&component=Installer) in Bugzilla.

## MSI Installer Downloads
To download the installer in different locale, replace "en-US" in the URLs below with the language code you need. A list is available at  **FIXME:**

### Thunderbird Beta

* Windows 32 bit - [https://download.mozilla.org/?product=thunderbird-beta-msi-latest-ssl&os=win&lang=en-US](https://download.mozilla.org/?product=thunderbird-beta-msi-latest-ssl&os=win&lang=en-US)
* Windows 64 bit - [https://download.mozilla.org/?product=thunderbird-beta-msi-latest-ssl&os=win64&lang=en-US](https://download.mozilla.org/?product=thunderbird-beta-msi-latest-ssl&os=win64&lang=en-US)

### Thunderbird Release

*The release channel will be available once Thunderbird 68 is released.*

## Configuration options
MSI transforms (MSTs) for the Thunderbird MSI installers can be created or edited using the tool of your choice ([MS Orca](https://docs.microsoft.com/en-us/windows/desktop/msi/orca-exe) or other) to customize the installation. This section details the options available. 

### Thunderbird custom MSI options

* **INSTALL\_DIRECTORY\_PATH=[path]** 

	Set a directory path

	Absolute path specifying the complete install location. This directory does not need to exist already (but it can). If INSTALL\_DIRECTORY\_NAME is set, then this setting will be ignored.

* **INSTALL\_DIRECTORY\_NAME=[name]**

	Set a directory name

	Name of the installation directory to create within Program Files.

	For example, if INSTALL\_DIRECTORY\_NAME is set to "Thunderbird Release", then the installation path will be "C:\Program Files\Thunderbird Release". The Program Files path used will be the correct one for the machine where Thunderbird is installed.

	If this is set, then INSTALL\_DIRECTORY\_PATH will be ignored.

* **TASKBAR\_SHORTCUT={true,false}**

	Install a taskbar shortcut

	Set to false to disable pinning a shortcut to the taskbar. true by default. This feature only works on Windows 7 and 8.

* **DESKTOP\_SHORTCUT={true,false}**

	Install a desktop shortcut

	Set to false to disable creating a shortcut on the desktop. true by default.

* **START\_MENU\_SHORTCUT={true,false}**

	Install a start menu shortcut

	Set to false to disable creating a Start menu shortcut. true by default.

* **INSTALL\_MAINTENANCE\_SERVICE={true,false}**

	Disable the maintenance service

	Set to false to disable installing the Mozilla Maintenance Service. This will effectively prevent users from installing Thunderbird updates if they do not have write permissions to the installation directory. true by default.

* **REMOVE\_DISTRIBUTION\_DIR={true,false}**

	Disable removing distribution directory

	Set to false to disable removing the distribution directory from an existing installation that’s being paved over. By default this is true and the directory is removed.

* **PREVENT\_REBOOT\_REQUIRED={true,false}**

	Prevent rebooting

	Set to true to keep the installer from taking actions that would require rebooting the machine to complete, normally because files are in use.

	This should not be needed under normal circumstances because no such actions should be required unless you’re paving over a copy of Thunderbird that was running while the installer was trying to run, and setting this option in that case may result in an incomplete installation. false by default.

* **OPTIONAL\_EXTENSIONS={true,false}**

	Bundle extensions

	Set to false to disable installing any bundled extensions that are present. true by default.

* **EXTRACT\_DIR=[directory]**

	Application files extraction directory

	Extract the application files to the given directory and exit, without actually running the installer. All other options will be ignored. 


## MSIEXEC options

The command line parameters for msiexec.exe are documented [here](https://docs.microsoft.com/en-us/windows/desktop/Msi/command-line-options).

Thunderbird MSI packages, because they wrap a .exe installer and don't really use the MSI framework, do not support many of the command line parameters available to msiexec. Here we list the supported and unsupported parameters.

### Supported MSIEXEC Options

*	/i or /package

	Installs the product.
* /L or /log

	Generates an MSI log file. All of this option's configuration parameters are supported. 
* /m

	Generates an SMS status .mif file.
* /q, /quiet, and /passive

	Sets the UI mode. The full UI option (/qf) is accepted but ignored, because there is no full UI. 
* /norestart, /forcerestart, and /promptrestart

	The default behavior is always /norestart, but the other options behave as expected.
* PROPERTY=VALUE

	Command line property configuration is supported for all public properties we provide (meaning the ones with UPPERCASE_NAMES). 
* Options that do not operate on a package file (/?, /h, /help, /y, /z)

### Unsupported MSIEXEC Options

* /f

	Repairs the product. 
* /a

	Administrative installation. 
* /x or /uninstall

	Uninstalls the product. 
* /j along with /t, /g, and /c

	Advertises the product. 
* /n

	Specifies a particular instance of the product. 
* /p or /update

	Applies a patch (.msp) file. 

##  Examples

The [Firefox MSI customization examples](https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers#w_example-configuration) can be applied to the Thunderbird packages as well.