//
//  SARUnArchiveANY.m
//  SARUnArchiveANY
//
//  Created by Saravanan V on 26/04/13.
//  Copyright (c) 2013 SARAVANAN. All rights reserved.
//

#import "SARUnArchiveANY.h"

//#import <SSZipArchive/SSZipArchive.h>
//@import SSZipArchive;
@import UnrarKit;
@import LzmaSDK_ObjC;

@implementation SARUnArchiveANY
@synthesize completionBlock;
@synthesize failureBlock;


#pragma mark - Init Methods
- (id)initWithPath:(NSString *)path {
	if ((self = [super init])) {
		_filePath = [path copy];
        _fileType = [[NSString alloc]init];
	}

    if (_filePath != nil) {
        _destinationPath = [self getDestinationPath];
    }
	return self;
}

- (id)initWithPath:(NSString *)path andPassword:(NSString*)password{
    if ((self = [super init])) {
        _filePath = [path copy];
        _password = [password copy];
        _fileType = [[NSString alloc]init];
    }
    
    if (_filePath != nil) {
        _destinationPath = [self getDestinationPath];
    }
    return self;
}

#pragma mark - Helper Methods
- (NSString *)getDestinationPath{
    NSArray *derivedPathArr = [_filePath componentsSeparatedByString:@"/"];
    NSString *lastObject = [derivedPathArr lastObject];
    _fileType = [[lastObject componentsSeparatedByString:@"."] lastObject];
    return [_filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",lastObject] withString:@""];
}


#pragma mark - Decompressing Methods
- (void)decompress{
    //    NSLog(@"_fileType : %@",_fileType);
    if ( [_fileType compare:rar options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        [self rarDecompress];
    }
    else if ( [_fileType compare:zip options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        [self zipDecompress];
    }
    else if ( [_fileType compare:@"7z" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        [self decompress7z];
    }
}

- (void)rarDecompress {
    NSString *tmpDirname = @"Extract rar";
    _destinationPath = [_destinationPath stringByAppendingPathComponent:tmpDirname];
//    _filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"rar"];
    NSLog(@"filePath : %@",_filePath);
    NSLog(@"destinationPath : %@",_destinationPath);

    NSError *archiveError = nil;
    URKArchive *archive = [[URKArchive alloc] initWithPath:_filePath error:&archiveError];
    
    if (!archive) {
        NSLog(@"Failed!");
        return;
    }
    
    NSError *error = nil;
    NSArray *filenames = [archive listFilenames:&error];
    
    if (archive.isPasswordProtected) {
        archive.password = self.password;
    }
    
    if (error) {
        NSLog(@"Error reading archive: %@", error);
        return;
    }
    
//    for (NSString *filename in filenames) {
//        NSLog(@"File: %@", filename);
//    }
    
    // Extract a file into memory just to validate if it works/extracts
    [archive extractDataFromFile:filenames[0] progress:nil error:&error];
    
    if (error) {
        if (error.code == ERAR_MISSING_PASSWORD) {
            NSLog(@"Password protected archive! Please provide a password for the archived file.");
        }
        if (failureBlock != nil) {
            failureBlock();
        }
    }
    else {
        NSMutableArray *filePathsArray = [NSMutableArray array];
        for (NSString *filePath in filenames){
            [filePathsArray addObject:[_destinationPath stringByAppendingPathComponent:filePath]];
        }
        [self moveFilesToDestinationPathFromCompletePaths:filePathsArray withFilePaths:filenames withArchive:archive];
        if (completionBlock != nil) {
            completionBlock(filePathsArray);
        }
    }
    
}

- (void)zipDecompress{
    NSString *tmpDirname = @"Extract zip";
    _destinationPath = [_destinationPath stringByAppendingPathComponent:tmpDirname];
    BOOL unzipped = [SSZipArchive unzipFileAtPath:_filePath toDestination:_destinationPath delegate:self];
//    NSLog(@"unzipped : %d",unzipped);
    NSError *error;
    if (self.password != nil && self.password.length > 0) {
        unzipped = [SSZipArchive unzipFileAtPath:_filePath toDestination:_destinationPath overwrite:NO password:self.password error:&error delegate:self];
        NSLog(@"error: %@", error);
    }
    
    if ( !unzipped ) {
        failureBlock();
    }
}

- (void)decompress7z{
    NSString *tmpDirname = @"Extract 7z";    
    _destinationPath = [_destinationPath stringByAppendingPathComponent:tmpDirname];
    NSLog(@"_filePath: %@", _filePath);
    NSLog(@"_destinationPath: %@", _destinationPath);
    
//    LzmaSDKObjCReader *reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:_filePath]];
    // 1.2 Or create with predefined archive type if path doesn't containes suitable extension
    LzmaSDKObjCReader *reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:_filePath] andType:LzmaSDKObjCFileType7z];
    
//    // Optionaly: assign weak delegate for tracking extract progress.
//    reader.delegate = self;
    
    // If achive encrypted - define password getter handler.
    // NOTES:
    // - Encrypted file needs password for extract process.
    // - Encrypted file with encrypted header needs password for list(iterate) and extract archive items.
    reader.passwordGetter = ^NSString*(void){
//        return @"password to my achive";
        NSLog(@"self.password: %@", self.password);
        return self.password;
    };
    
    // Open archive, with or without error. Error can be nil.
    NSError * error = nil;
    if (![reader open:&error]) {
        NSLog(@"Open error: %@", error);
    }
    NSLog(@"Open error: %@", reader.lastError);
    
    NSMutableArray *filePathsArray = [NSMutableArray array];

    NSMutableArray * items = [NSMutableArray array]; // Array with selected items.
    // Iterate all archive items, track what items do you need & hold them in array.
    [reader iterateWithHandler:^BOOL(LzmaSDKObjCItem * item, NSError * error){
//        NSLog(@"\nitem:%@", item);
        if (item) {
            [items addObject:item]; // if needs this item - store to array.
            if (!item.isDirectory) {
                NSString *filePath = [_destinationPath stringByAppendingPathComponent:item.directoryPath];
                filePath = [filePath stringByAppendingPathComponent:item.fileName];
                [filePathsArray addObject:filePath];
            }
        }
        return YES; // YES - continue iterate, NO - stop iteration
    }];
    NSLog(@"Iteration error: %@", reader.lastError);
    
    // Extract selected items from prev. step.
    // YES - create subfolders structure for the items.
    // NO - place item file to the root of path(in this case items with the same names will be overwrited automaticaly).
    [reader extract:items
              toPath:_destinationPath
       withFullPaths:YES];
    NSLog(@"Extract error: %@", reader.lastError);
    
    // Test selected items from prev. step.
    [reader test:items];
    NSLog(@"test error: %@", reader.lastError);
    if (reader.lastError || ![filePathsArray count]) {
        failureBlock();
    }
    else {
        completionBlock(filePathsArray);
    }
    
}

#pragma mark - SSZipArchive Delegates
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath WithFilePaths:(NSMutableArray *)filePaths{
    //    NSLog(@"path : %@",path);
    //    NSLog(@"unzippedPath : %@",unzippedPath);
    completionBlock(filePaths);
}


#pragma mark - Utility Methods
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}





#pragma mark - Not using these methods now
//Writing this for Unrar4iOS, since it just unrar's(decompresses) the files into the compressed(rar) file's folder path
- (void)moveFilesToDestinationPathFromCompletePaths:(NSArray *)completeFilePathsArray withFilePaths:(NSArray *)filePathsArray withArchive:(URKArchive*)archive{
    
    NSError *error;
    [archive extractFilesTo:_destinationPath overwrite:NO progress:^(URKFileInfo *currentFile, CGFloat percentArchiveDecompressed) {
//        NSLog(@"Extracting %@: %f%% complete", currentFile.filename, percentArchiveDecompressed);
    } error:&error];
    NSLog(@"Error: %@", error);
}

@end
