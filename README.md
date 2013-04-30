SARUnArchiveANY
===============

	A very useful library for Unarchiving the .zip, .rar, .7z files for iOS.
	Simply An Integration of Unrar4iOS + SSZipArchive + LZMA SDK (7z).

<b>Advantages :</b>
	Integration of the most popular archiving libraries, no need for integrating each library separately.
	Completely Block-based syntax. No Delegation pattern, hence avoiding a lot of clunky codes.

<b>Dis-Advantages :</b>
	Have tested this only with smaller files. Might not suit well for files with larger sizes ( May be files > 500MB's ).
	No support for passcode protected archive files.


<b>Instructions :</b>

	(i) Copy/Include the "External" folder into your project.
	(ii) Copy/Include  "Unrar4iOS.framework" & "libz.dylib" into your project.
	(iii) Finally, Copy "SARUnArchiveANY.h" & "SARUnArchiveANY.m" into your project.
	That's it. your done.


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
        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
