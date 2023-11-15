#!/bin/bash

set -e

command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }

AVDMANAGER="$HOME/commandline-tools/cmdline-tools/bin/avdmanager"
EMULATOR="$HOME/emulator/emulator"
SDKMANAGER="$HOME/commandline-tools/cmdline-tools/bin/sdkmanager"

AVD_NAME="my_avd"

#[[ -e $HOME/build-tools.zip ]] || wget -O $HOME/build-tools.zip 'https://dl.google.com/android/repository/build-tools_r25-linux.zip' && [[ -d $HOME/build-tools ]] || unzip $HOME/build-tools.zip -d $HOME/build-tools/
[[ -e $HOME/commandline-tools.zip ]] || wget -O $HOME/commandline-tools.zip 'https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip' && [[ -d $HOME/commandline-tools ]] || unzip $HOME/commandline-tools.zip -d $HOME/commandline-tools/
#[[ -e $HOME/platforms.zip ]] || wget -O $HOME/platforms.zip 'https://dl.google.com/android/repository/android-16_r05.zip' && [[ -d $HOME/platforms ]] || unzip $HOME/platforms.zip -d $HOME/platforms/
#[[ -e $HOME/platform-tools.zip ]] || wget -O $HOME/platform-tools.zip 'https://dl.google.com/android/repository/platform-tools-latest-linux.zip' && [[ -d $HOME/platform-tools ]] || unzip $HOME/platform-tools.zip -d $HOME/platform-tools/

yes | $SDKMANAGER --install "emulator" "platforms;android-30" --sdk_root=$HOME/
yes | $SDKMANAGER "system-images;android-30;google_apis_playstore;x86_64" --sdk_root=$HOME/

[[ -d $HOME/.android/avd/$AVD_NAME.avd ]] && $AVDMANAGER delete avd -n $AVD_NAME
echo 'no' | $AVDMANAGER create avd -n $AVD_NAME -k "system-images;android-30;google_apis_playstore;x86_64" --force

sed -i -e 's/PlayStore.enabled.*/PlayStore.enabled = yes/' $HOME/.android/avd/$AVD_NAME.avd/config.ini
sed -i -e 's/hw.keyboard.*/hw.keyboard = yes/' $HOME/.android/avd/$AVD_NAME.avd/config.ini

echo "All done! Running the device..."

$EMULATOR -avd $AVD_NAME

exit
