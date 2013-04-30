SARUnArchiveANY
===============

A very useful library for Unarchiving the .zip, .rar, .7z files for iOS. 
Simply An Integration of Unrar4iOS + SSZipArchive + LZMA SDK (7z).

Advantages :
* Integration of the most popular archiving libraries, no need for integrating each library separately.
* Completely Block-based syntax. No Delegation pattern, hence avoiding a lot of clunky codes.

Dis-Advantages :
* Have tested this only with smaller files. Might not suit well for files with larger sizes ( May be files > 500MB's ).
* No support for passcode protected archive files.


Instructions :

(i) Copy/Include the "External" folder into your project.
(ii) Copy/Include  "Unrar4iOS.framework" & "libz.dylib" into your project.

