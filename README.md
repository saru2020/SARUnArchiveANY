SARUnArchiveANY
===============

	A very useful library for Unarchiving the .zip, .rar, .7z files for iOS.
	
Simply An Integration of the following libraries :
<p>
	* <a href="https://github.com/abbeycode/UnrarKit">UnrarKit</a><br/>
	* <a href="https://github.com/soffes/ssziparchive"> SSZipArchive </a><br/>
	* <a href="https://github.com/OlehKulykov/LzmaSDKObjC">LzmaSDKObjC (7z)</a><br/>
</p>

<b>Pros:</b>

		* Integration of the most popular archiving libraries, no need for integrating each library separately.
		* Completely Block-based syntax. No Delegation pattern, hence avoiding a lot of clunky codes.
		* UnArchive Password protected files.

<br/>

<p>
<b>		* Example project illustrates on how to display your app in "Open in" action sheet list, 
		  when tapped on any of the archive file of the supported format (zip, rar, 7z) in any apps installed on 
		  the device/simulator.
</b>
<br/>
<b>
		* Example illustrates on how to make the app support for iTunes File Sharing.
</b>
<p>

<br/>

<b>Cons:</b>

		* Have tested this only with smaller files. Might not suit well for files with larger 
		  sizes ( May be files > 500MB's ).


<b>Installation :</b><br/>
Add the following to your <a href="http://cocoapods.org/">CocoaPods</a> Podfile

	pod 'SARUnArchiveANY'

or clone as a git submodule,

or any way you'd prefer to play with ;)

<b>Usage :</b>

    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive file.
    unarchive.completionBlock = ^(NSArray *filePaths){
      NSLog(@"For Archive : %@",filePath);
		for (NSString *filename in filePaths) {
			NSLog(@"File: %@", filename);
		}
    };
    unarchive.failureBlock = ^(){
    };
    [unarchive decompress];
