#!/bin/bash

#Configuration
## Download locations for different architectures.
X86LOC="http://builds.cuberite.org/job/Cuberite%20Linux%20x86%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz"
X64LOC="http://builds.cuberite.org/job/Cuberite%20Linux%20x64%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz"
ARMLOC="http://builds.cuberite.org/job/Cuberite%20Linux%20raspi-armhf%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz"

X86LOCSHA="http://builds.cuberite.org/job/Cuberite%20Linux%20x86%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz.sha1"
X64LOCSHA="http://builds.cuberite.org/job/Cuberite%20Linux%20x64%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz.sha1"
ARMLOCSHA="http://builds.cuberite.org/job/Cuberite%20Linux%20raspi-armhf%20Master/lastSuccessfulBuild/artifact/Cuberite.tar.gz.sha1"
## Cuberite Directory
CUBERITEDIR="cuberite/"
## Cache Directory
CACHEDIR=".cuberiteupdate/"

# Define the download and extract function.
download() {
  # Download the current archive.
  echo "Downloading Cuberite..."
  wget --quiet $ARCHLOC -O $CACHEDIR"Cuberite.tar.gz"
  # Find out the current Cuberite process and kill it.
  pid=`pgrep -o -x Cuberite`
  kill -s 15 $pid 2>/dev/null
  # Extract the archive, clean up, and start the server.
  echo "Extracting downloaded archive..."
  tar -xf $CACHEDIR"Cuberite.tar.gz"
  echo "Copying new files..."
  cp -r "Cuberite/Plugins" $CUBERITEDIR
  cp -r "Cuberite/webadmin" $CUBERITEDIR
  cp "Cuberite/monsters.ini" $CUBERITEDIR
  cp "Cuberite/items.ini" $CUBERITEDIR
  cp "Cuberite/crafting.txt" $CUBERITEDIR
  cp "Cuberite/furnace.txt" $CUBERITEDIR
  cp "Cuberite/Cuberite" $CUBERITEDIR
  rm -r "Cuberite"
  cd $CUBERITEDIR
  screen ./Cuberite
  # Nothing more is needed from the script, exit.
  echo "Updated successfully!"
  exit
}

# Work out the current architecture and store it.
CURRENTARCH=`uname -m`
if [ $CURRENTARCH == "i686" ]
then
  ARCHLOC=$X86LOC
  ARCHLOCSHA=$X86LOCSHA
elif [ $CURRENTARCH == "x86_64" ]
then
  ARCHLOC=$X64LOC
  ARCHLOCSHA=$X64LOCSHA
elif [ $CURRENTARCH == "armv6l"  ]
then
  ARCHLOC=$ARMLOC
  ARCHLOCSHA=$ARMLOCSHA
else
  echo "Arch not recognised. Please file a bug report with the output from uname -m and your machine type."
  exit
fi

# Make sure the specified Cuberite directory exists.
if [ ! -d $CUBERITEDIR ]
then
  # Make the directory.
  mkdir $CUBERITEDIR
fi

# Check if the cache directory exists.
if [ ! -d $CACHEDIR ]
then
  mkdir $CACHEDIR
  download
fi

# Donwload thesha1 sum from the buildserver and check it against the current tar.
wget --quiet $ARCHLOCSHA -O $CACHEDIR"Cuberite.tar.gz.sha1"
cd $CACHEDIR
sha1sum -c --status "Cuberite.tar.gz.sha1"
rc=$?
if [ $rc != 0 ]
then
  cd ..
  # We don't have the most updated Cuberite version, update now.
  download
fi

echo "Cuberite up to date, quitting!"
