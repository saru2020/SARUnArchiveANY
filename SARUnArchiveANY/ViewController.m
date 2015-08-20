//
//  ViewController.m
//  SARUnArchiveANY
//
//  Created by Saravanan V on 26/04/13.
//  Copyright (c) 2013 SARAVANAN. All rights reserved.
//

#import "ViewController.h"
#import "SARUnArchiveANY.h"
#import "LZMAExtractor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NOTE: UnComment the below lines of code to see the execution of other file types decompression
//    [self unZip];
//    [self unRar];
    [self Unzip7z];
}

- (void)unArchive: (NSString *)filePath destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
      NSLog(@"For Archive : %@",filePath);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
            NSLog(@"US Presidents app is installed.");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
        }

		for (NSString *filename in filePaths) {
			NSLog(@"File: %@", filename);
		}
    };
    unarchive.failureBlock = ^(){
//        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
}

- (void)unZip{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Zip_Example" ofType:@"zip"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath destinationPath:destPath];
}

- (void)unRar{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"rar"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath destinationPath:destPath];
}

- (void)Unzip7z{
	NSString *archiveFilename = @"example.7z";
	NSString *archiveResPath = [[NSBundle mainBundle] pathForResource:archiveFilename ofType:nil];
    NSAssert(archiveResPath, @"can't find .7z file");
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:archiveResPath destinationPath:destPath];
}

- (void)handleFileFromURL:(NSString *)filePath{
    NSLog(@"*********       FILES FROM THE OTHER APPS       *********");
    [self unArchive:filePath destinationPath:nil];
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
