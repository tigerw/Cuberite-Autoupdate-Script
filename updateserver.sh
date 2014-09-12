#!/bin/bash

#Configuration
## Download locations for different architectures.
X86LOC="http://builds.mc-server.org/job/MCServer%20Linux%20x86/lastSuccessfulBuild/artifact/MCServer.tar"
X64LOC="http://builds.mc-server.org/job/MCServer%20Linux%20x64/lastSuccessfulBuild/artifact/MCServer.tar"
ARMLOC="http://ci.berboe.co.uk/job/MCServer%20Linux-RasPi%20HardFloat/lastSuccessfulBuild/artifact/MCServer.tar"

X86LOCMD5="http://builds.mc-server.org/job/MCServer%20Linux%20x86/lastSuccessfulBuild/artifact/MCServer.tar.md5"
X64LOCMD5="http://builds.mc-server.org/job/MCServer%20Linux%20x64/lastSuccessfulBuild/artifact/MCServer.tar.md5"
ARMLOCMD5="http://ci.berboe.co.uk/job/MCServer%20Linux-RasPi%20HardFloat/lastSuccessfulBuild/artifact/MCServer.tar.md5"
## MCServer Directory
MCSDIR="mcserver/"
## Cache Directory
CACHEDIR=".mcsupcache/"

# Define the download and extract function.
download() {
  # Download the current archive.
  echo "Downloading MCServer..."
  wget --quiet $ARCHLOC -O $CACHEDIR"MCServer.tar"
  # Find out the current MCServer process and kill it.
  pid=`pgrep -o -x MCServer`
  kill -s 15 $pid 2>/dev/null
  # Extract the archive, clean up, and start the server.
  echo "Extracting downloaded archive..."
  tar -xf $CACHEDIR"MCServer.tar"
  echo "Copying new files..."
  cp -r "MCServer/Plugins" $MCSDIR
  cp -r "MCServer/webadmin" $MCSDIR
  cp "MCServer/monsters.ini" $MCSDIR
  cp "MCServer/items.ini" $MCSDIR
  cp "MCServer/crafting.txt" $MCSDIR
  cp "MCServer/furnace.txt" $MCSDIR
  cp "MCServer/MCServer" $MCSDIR
  rm -r "MCServer"
  cd $MCSDIR
  screen ./MCServer
  # Nothing more is needed from the script, exit.
  echo "Updated successfully!"
  exit
}

# Work out the current architecture and store it.
CURRENTARCH=`uname -m`
if [ $CURRENTARCH == "i686" ]
then
  ARCHLOC=$X86LOC
  ARCHLOCMD5=$X86LOCMD5
elif [ $CURRENTARCH == "x86_64" ]
then
  ARCHLOC=$X64LOC
  ARCHLOCMD5=$X64LOCMD5
elif [ $CURRENTARCH == "armv6l"  ]
then
  ARCHLOC=$ARMLOC
  ARCHLOCMD5=$ARMLOCMD5
else
  echo "Arch not recognised. Please file a bug report with the output from uname -m and your machine type."
  exit
fi

# Make sure the specified MCServer directory exists.
if [ ! -d $MCSDIR ]
then
  # Make the directory.
  mkdir $MCSDIR
fi

# Check if the cache directory exists.
if [ ! -d $CACHEDIR ]
then
  mkdir $CACHEDIR
  download
fi

# Donwload the MD5 sum from the buildserver and check it against the current tar.
wget --quiet $ARCHLOCMD5 -O $CACHEDIR"MCServer.tar.md5"
cd $CACHEDIR
md5sum -c --status "MCServer.tar.md5"
rc=$?
if [ $rc != 0 ]
then
  cd ..
  # We don't have the most updated MCServer version, update now.
  download
fi

echo "MCServer up to date, quitting!"
