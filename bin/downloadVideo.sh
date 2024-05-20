#!/bin/sh
# */15  * * * * ~/bin/downloadVideo.sh > /dev/null 2>&1

lockFile=~/Videos/video.lock;

if [ -f $lockFile ]
then
	exit;
else
	echo " Download new Songs...";
fi
logfile=~/Videos/video_download.log;
downloadFile=~/Videos/songs.txt;
downloadFileTmp=~/Videos/songs.txt.tmp;
echo "================================================================================================" >> $logfile;
echo File processing started at `date +"%Y-%m-%d %T"` >> $logfile;
if [ -f $downloadFile ]
then
	touch $lockFile;
	~/bin/yt-dlp -f 'bestvideo[height<=2160]+bestaudio[ext=m4a]/mp4' --merge-output-format mp4 --no-progress -c -a $downloadFile --restrict-filenames -o '~/Videos/HD/%(title)s.%(ext)s' >> $logfile;

	echo ------------------------------------- >> ~/Videos/back.songs.txt;
	echo `date +"%Y-%m-%d %T"` >> ~/Videos/back.songs.txt;
	echo ------------------------------------- >> ~/Videos/back.songs.txt;
	cat $downloadFile >> ~/Videos/back.songs.txt;
	echo '' >> ~/Videos/back.songs.txt;
	echo ------------------------------------- >> ~/Videos/back.songs.txt;
	echo `date +"%Y-%m-%d %T"` >> ~/Videos/back.songs.txt;
	echo ------------------------------------- >> ~/Videos/back.songs.txt;
	rm $downloadFile;
	rm $lockFile;
	mv $downloadFileTmp $downloadFile;
else
        echo "No file $downloadFile for Processing" >> $logfile
fi
echo File processing completed at `date +"%Y-%m-%d %T"` >> $logfile;
echo "================================================================================================" >> $logfile;
