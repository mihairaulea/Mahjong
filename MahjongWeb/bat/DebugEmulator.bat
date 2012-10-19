@echo off

set PATH=%PATH%;C:\Program Files (x86)\Android\android-sdk\platform-tools

call adb install -r E:\Proiecte\MultiScreenFeathers\dist\MultiScreenFeathers-debug.apk

:end
pause