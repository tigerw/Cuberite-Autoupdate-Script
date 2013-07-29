MCServer Automatic Updating Shell Script
==========================

**WARNING:** I am not responsible if this script manages to lose you your world (though highly unlikely). Please test first!
**INFORMATION:** This script assumes your MCServer is in a directory named 'mcserver' and that you are currently *outside* that directory.

This script works in tandem with [MCServer](http://mc-server.org/) to update the binary executable to the newest version.
It requires Linux, and utilises the Jenkins build server hosted by [bearbin](https://github.com/bearbin/) located at http://ci.berboe.co.uk/

Requirements
------------

 * BASH
 * Screen
 * Working internet connection.

Setup
-----

You can either just download it:

    wget https://github.com/tigerw/MCServer-Autoupdate-Script/raw/master/updateserver.sh; bash updateserver.sh
 
Or you can clone the repo, then run the script.
