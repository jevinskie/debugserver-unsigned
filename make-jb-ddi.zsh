#!/usr/bin/env zsh

if [[ -e orig ]]; then
	echo "orig exists"
	exit -1
fi

if [[ -e jb ]]; then
	echo "jb exists"
	exit -2
fi

if [[ -e DeveloperDiskImage-jb.dmg ]]; then
	echo "DeveloperDiskImage-jb.dmg exists"
	exit -3
fi

hdiutil attach DeveloperDiskImage.dmg -readonly -mount required -nobrowse -mountpoint orig
cp -R orig jb
umount orig

codesign --display --entitlements ent-orig-wrapped.xml jb/usr/bin/debugserver
dd if=ent-orig-wrapped.xml of=ent-orig.xml bs=8 skip=1
rm ent-orig-wrapped.xml
cp ent-orig.xml ent-jb.xml
plutil -insert get-task-allow -bool YES ent-jb.xml
plutil -insert task_for_pid-allow -bool YES ent-jb.xml
rm ent-orig.xml

codesign -f -i com.apple.debugserver -s - --entitlements ent-jb.xml jb/usr/bin/debugserver
rm ent-jb.xml

hdiutil create -srcfolder jb -format UDZO -volname DeveloperDiskImage -layout NONE -fs HFS+ DeveloperDiskImage-jb.dmg
rm -rf jb
