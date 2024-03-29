################################# Home ####################################

if [[ "`uname -a`" =~ .*Darwin.* ]]
then 
    #
    # Mac 
    #

    # Gradle 
    export GRADLE_HOME=/Volumes/Macintosh/Applications/gradle
    export PATH=$PATH:$GRADLE_HOME/bin

    # Android NDK
    export ANDROID_NDK_ROOT=/Volumes/Macintosh/Applications/android-ndk

    # Android SDK
    #export ANDROID_HOME=/Volumes/Macintosh/Applications/android-sdk-macosx
    export ANDROID_HOME="~/Library/Android/sdk"
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/build-tools/23.0.1
    export PATH=$PATH:$ANDROID_HOME/build-tools/22.0.1
    #Repo tool for Android
    #export PATH=/toro-vm/bin/google/android/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

    # NPM
    export PATH=${HOME}/.npm/bin:$PATH

    # Android Studio Options
    # http://tools.android.com/tech-docs/configuration
    export STUDIO_VM_OPTIONS="$HOME/.android-studio.vmoptions"

    # MacTex on El Capitan or better
    export PATH=$PATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin
else
    # Nothing
    :
fi

alias davida-hw2-startvms="ssh -t davida-hw2 'bash virtualbox-setup/ssh-vms-manager.sh -s'"
alias davida-hw2-softstopvms="ssh -t davida-hw2 'bash virtualbox-setup/ssh-vms-manager.sh -p'"

