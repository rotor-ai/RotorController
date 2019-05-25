# Copyright 2017 Google, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#    * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#    * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# travis.yml source available here:
# https://github.com/google/flutter.plugins


#!/bin/bash
wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
mkdir android-sdk
unzip -qq sdk-tools-linux-3859397.zip -d android-sdk
export ANDROID_HOME=`pwd`/android-sdk
export PATH=`pwd`/android-sdk/tools/bin:$PATH
mkdir -p /home/travis/.android # silence sdkmanager warning
echo 'count=0' > /home/travis/.android/repositories.cfg # silence sdkmanager warning
        # suppressing output of sdkmanager to keep log under 4MB (travis limit)
echo y | sdkmanager "tools" >/dev/null
echo y | sdkmanager "platform-tools" >/dev/null
echo y | sdkmanager "build-tools;26.0.3" >/dev/null
echo y | sdkmanager "platforms;android-26" >/dev/null
echo y | sdkmanager "extras;android;m2repository" >/dev/null
echo y | sdkmanager "extras;google;m2repository" >/dev/null
echo y | sdkmanager "patcher;v4" >/dev/null
sdkmanager --list
wget http://services.gradle.org/distributions/gradle-4.1-bin.zip
unzip -qq gradle-4.1-bin.zip
export GRADLE_HOME=$PWD/gradle-4.1
export PATH=$GRADLE_HOME/bin:$PATH
gradle -v
git clone https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:`pwd`/flutter/bin/cache/dart-sdk/bin:$PATH
flutter doctor