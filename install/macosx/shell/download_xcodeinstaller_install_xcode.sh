#!/bin/bash

# This snippet should hypothetically allow a totally unattended
# installation of Apple's XCode. After prompting for credentials,
# the script simulates a login, begins a download and subsequently
# mounts the disk image and installs XCode to the default location.

echo -n "ADC login: "
read login
echo -n "ADC password: "
read -s password

touch ~/.cookiejar

userAgent='Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9b5) Gecko/2008032619 Firefox/3.0b5'

# Curl to grab destination URL...
postDestination=$( \
curl -b ~/.cookiejar -c ~/.cookiejar -s https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=D635F5C417E087A3B9864DAC5D25920C4E9442C9339FA9277951628F0291F620 | \
egrep '<form' | \
sed 's/.*action="\(.*\)".*/\1/' )

# Sed to extract wosid...
wosid=$( echo $postDestination | sed 's/.*wo\/\([a-zA-Z0-9]*\).*/\1/' )

# Post to destination...
curl -L -s -o /dev/null -A "$userAgent" -b ~/.cookiejar -c ~/.cookiejar -X 'POST' -d "theAccountName=$login&theAccountPW=$password&1.Continue.x=0&1.Continue.y=0&theAuxValue&wosid=$wosid" "https://daw.apple.com$postDestination"

# Curl the dmg...
curl -L -A "$userAgent" -b ~/.cookiejar -c ~/.cookiejar -O 'https://developer.apple.com/devcenter/download.action?path=/ios/ios_sdk_4.2__final/xcode_3.2.5_and_ios_sdk_4.2_final.dmg'

rm ~/.cookiejar

hdiutil attach ./xcode_3.2.5_and_ios_sdk_4.2_final.dmg
cd /Volumes/xc*
installer -pkg ./XcodeTools.mpkg -target /
hdiutil detach /Volumes/xc*