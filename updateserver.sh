wget http://ci.berboe.co.uk/job/MCServer%20Linux-x86/lastSuccessfulBuild/artifact/trunk/MCServer.tar
pid=`pgrep -o -x MCServer`
kill -s 15 $pid
tar --extract --file=MCServer.tar MCServer/MCServer
/bin/cp MCServer/MCServer mcserver/
rm -r -f MCServer.tar MCServer
cd mcserver/
screen ./MCServer
