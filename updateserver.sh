#!/bin/bash

#Configuration
## Download locations for different architectures.
X86LOC="http://ci.berboe.co.uk/job/MCServer%20Linux-x86/lastSuccessfulBuild/artifact/trunk/"
X64LOC="http://ci.berboe.co.uk/job/MCServer%20Linux-x86-64/lastSuccessfulBuild/artifact/trunk/"
ARMLOC="http://ci.berboe.co.uk/job/MCServer%20Linux-ARM/lastSuccessfulBuild/artifact/trunk/"
## MCServer Directory
MCSDIR="mcserver/"
## Cache Directory
CACHEDIR=".mcsupcache/"

# Define the download and extract function.
download() {
  echo "Doesn't do anything yet!"
  #wget http://ci.berboe.co.uk/job/MCServer%20Linux-x86/lastSuccessfulBuild/artifact/trunk/MCServer.tar
  #pid=`pgrep -o -x MCServer`
  #kill -s 15 $pid
  #tar --extract --file=MCServer.tar MCServer/MCServer
  #/bin/cp MCServer/MCServer mcserver/
  #rm -r -f MCServer.tar MCServer
  #cd mcserver/
  #screen ./MCServer
}

# Work out the current architecture and store it.
CURRENTARCH=`uname -m`
if [ $CURRENTARCH == "i686" ]
then
  ARCHLOC=$X86LOC
elif [ $CURRENTARCH == "x86_64" ]
then
  ARCHLOC=$X64LOC
elif [ $CURRENTARCH == "armv6l"  ]
then
  ARCHLOC=$ARMLOC
else
  echo "Arch not recognised. Please file a bug report with the output from uname -m and your machine type."
  exit
fi

# Check if the cache directory exists.
if [ ! -d $CACHEDIR ]
then
  mkdir $CACHEDIR
  download
fi

# Donwload the MD5 sum from the buildserver and check it against the current tar.
wget $ARCHLOC"MCServer.tar.md5" -O $CACHEDIR"MCServer.tar.md5"
if [ ! md5sum $CACHEDIR"MCServer.tar.md5" ]
then
  # We don't have the most updated MCServer version, update now.
  download
fi

echo "MCServer up to date, quitting!"
