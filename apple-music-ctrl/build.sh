#!/usr/bin/env bash


xcodebuild -scheme AppleMusicCtrlLib -configuration Release CONFIGURATION_BUILD_DIR=./build
# FIXME: This seems wrong :(
sudo cp -v build/libAppleMusicCtrlLib.dylib /usr/local/lib/libAppleMusicCtrlLib.dylib
cp -v build/libAppleMusicCtrlLib.dylib ../libs/libAppleMusicCtrlLib.dylib
cp -v ./AppleMusicCtrlLib-Bridging-Header.h ../include/AppleMusicCtrlLib-Bridging-Header.h
