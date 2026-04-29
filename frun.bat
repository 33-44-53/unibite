@ECHO off
SET FLUTTER_ROOT=C:\Users\Oumer\Desktop\flutter
SET dart=%FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dart.exe
SET snapshot=%FLUTTER_ROOT%\bin\cache\flutter_tools.snapshot
SET pkg=%FLUTTER_ROOT%\packages\flutter_tools\.dart_tool\package_config.json

"%dart%" --packages="%pkg%" "%snapshot%" %*
