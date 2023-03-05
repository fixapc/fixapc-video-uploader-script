#!/bin/bash
set -x
black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
yellow="\033[0;33m"
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"
nocolor="\033[0m"

#The user to launch chrome under
user=usr

#Your Saved Video Location
videosavelocation="/mnt/fixapc.net/mnt/nextcloud/fixapc/files/EVERYTHING/AUDIO VIDEO/VIDEO_PRODUCTION/FIXAPC_TECH_CHANNEL"

#Testing
read -r -p "$(echo -e "$yellow Please Enter The Title Of The Video $nocolor")" title
text="https://www.fixapc.net/$title"

#Testing
read -r -p "$(echo -e "$yellow Please Enter The Type Of Tutorial:$nocolor $green 1=Micro Tutorial $nocolor, $blue Full Tutorial=2 $nocolor, $red Quick Fix=3 $nocolor")" selecttuttype
if [ "$selecttuttype" = 1 ]; then
    typeoftutorial="video_cover_micro.png"
elif [ "$selecttuttype" = 2 ]; then
    typeoftutorial="video_cover_full.png"
elif [ "$selecttuttype" = 3 ]; then
    typeoftutorial="video_cover_fix.png"
else
    echo "Invalid Selection"
    exit
fi

#Testing
#read -r -p "$(echo -e "$yellow Please Enter The Logo Keyword To Insert To The Video Cover $nocolor")" logokeyword
#sudo -u $user google-chrome "https://www.google.com/search?q=$logokeyword%20logo&tbm=isch&tbs=ift:png"

#
#read -r -p "$(echo -e "$yellow Please Paste The PNG URL That You Wish To Upload To Use $nocolor")" dlpngimg

#wget dlpngimg

#Create Title
titlefolder=$(echo -e "$title" | sed 's& &_&gI')
sudo -u mkdir "$videosavelocation"/"$titlefolder"

#Create Support Links
supportlinks='
Platform - Links
Homepage - https://www.fixapc.net
Forum    - https://forum.fixapc.net
Facebook - https://www.facebook.com/Fixapcdotnet
Twitter  - https://twitter.com/FIXAPCdotnet
Twitch   - https://www.twitch.tv/fixapcdotnet
Youtube  - https://www.youtube.com/channel/UCSvBW8e2zGNFiSUSD9qLNbQ
Odysee   - https://odysee.com/@Fixapc:5
Tiktok   - https://www.tiktok.com/@fixapc
Dtube    - https://d.tube/#!/c/fixapc777
Vimeo    - https://vimeo.com/user151963004

Communication Links
Discord  - https://discord.gg/fwaJ9V8c

Support US If you would like to me more content and tutorials.
Supporters have tutorial request priority
Patreon  - https://www.patreon.com/
Paypal   - https://paypal.me/FIXAPC/
Cashapp  - https://cash.app/$fixapc/

For a full range of support options including crypto.
https://fixapc.net/support-us/

Request a tutorial
https://fixapc.net/tutorial-request/

Website based version
https://fixapc.net/'$title'/'

#Create News Banner
convert news_banner_ai.png -fill white -stroke black \
-pointsize 32 -font URWGothic-Demi -draw 'text 190,65 "'"$title"'"' \
-pointsize 20 -font URWGothic-Demi -draw 'text 220,100 "'"$text"'"' \
news_banner.png
sudo -u $user cp -a -r -f -v news_banner.png "$videosavelocation"/
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder"
rm news_banner.png

#Create Video Cover
convert $typeoftutorial -fill white -stroke black \
-pointsize 60 -font URWGothic-Demi -gravity center -annotate +0+395 "$title" \
video_cover.png
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"
sudo -u $user cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder"
rm video_cover.png

#Create Video Cover
#convert $typeoftutorial -fill white -stroke black \
#-pointsize 60 -font URWGothic-Demi -gravity center -annotate +0+395 "$title" \
#video_cover.png

#add image overlay to gentoo
#video_cover_pre.png
#composite -gravity center "$pngimg" video_cover_pre.png video_cover.png
#cp -a -r -f -v video_cover.png "$videosavelocation"/"$titlefolder"
#rm video_cover.png


#Copy Outro And Intro Clip To The Newly Created Folder
sudo -u $user cp -a -r -f -v "$videosavelocation"/inclip.mp4    "$videosavelocation"/"$titlefolder"
sudo -u $user cp -a -r -f -v "$videosavelocation"/outclip.mp4   "$videosavelocation"/"$titlefolder"

#start obs and wait for close
sudo -u usr obs
chrt -f -p 1 $(pidof obs)

#
echo "obs has closed"

