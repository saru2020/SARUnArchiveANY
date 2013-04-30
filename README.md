SARUnArchiveANY
===============

	<li>A very useful library for Unarchiving the .zip, .rar, .7z files for iOS. </li>
	<li>Simply An Integration of Unrar4iOS + SSZipArchive + LZMA SDK (7z).</li>

<b>Advantages :</b>
	<li>* Integration of the most popular archiving libraries, no need for integrating each library separately.</li>
	<li>* Completely Block-based syntax. No Delegation pattern, hence avoiding a lot of clunky codes.</li>

<b>Dis-Advantages :</b>
	<li>* Have tested this only with smaller files. Might not suit well for files with larger sizes ( May be files > 500MB's ).</li>
	<li>* No support for passcode protected archive files.</li>


<b>Instructions :</b>

	<li>(i) Copy/Include the "External" folder into your project.</li>
	<li>(ii) Copy/Include  "Unrar4iOS.framework" & "libz.dylib" into your project.</li>
	<li>(iii) Finally, Copy "SARUnArchiveANY.h" & "SARUnArchiveANY.m" into your project.</li>
	<li>That's it. your done.</li>


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
