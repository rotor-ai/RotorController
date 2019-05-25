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

set -ev

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ "${BRANCH_NAME}" = "master" ]; then
  echo "Running for all packages"
  pub global run flutter_plugin_tools "$@" $PLUGIN_SHARDING
else
  # Make sure there is up-to-date master.
  git fetch origin master

  FLUTTER_CHANGED_GLOBAL=0
  FLUTTER_CHANGED_PACKAGES=""

  # Try get a merge base for the branch and calculate affected packages.
  # We need this check because some CIs can do a single branch clones with a limited history of commits.
  if BRANCH_BASE_SHA=$(git merge-base --fork-point FETCH_HEAD HEAD); then
    echo "Checking changes from $BRANCH_BASE_SHA..."
    FLUTTER_CHANGED_GLOBAL=`git diff --name-only $BRANCH_BASE_SHA HEAD | grep -v packages | wc -l`
    FLUTTER_CHANGED_PACKAGES=`git diff --name-only $BRANCH_BASE_SHA HEAD | grep -o "packages/[^/]*" | sed -e "s/packages\///g" | sort | uniq | paste -s -d, -`
  else
    echo "Cannot find a merge base for the current branch to run an incremental build..."
    echo "Please rebase your branch onto the latest master!"
  fi

  if [ "${FLUTTER_CHANGED_PACKAGES}" = "" ] || [ $FLUTTER_CHANGED_GLOBAL -gt 0 ]; then
    echo "Running for all packages"
    pub global run flutter_plugin_tools "$@" $PLUGIN_SHARDING
  else
    echo "Running only for $FLUTTER_CHANGED_PACKAGES"
    pub global run flutter_plugin_tools "$@" --plugins=$FLUTTER_CHANGED_PACKAGES
  fi
fi