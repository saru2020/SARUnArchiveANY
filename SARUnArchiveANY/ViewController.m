//
//  ViewController.m
//  SARUnArchiveANY
//
//  Created by Saravanan V on 26/04/13.
//  Copyright (c) 2013 SARAVANAN. All rights reserved.
//

#import "ViewController.h"
#import "SARUnArchiveANY.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NOTE: UnComment the below lines of code to see the execution of other file types decompression
//    [self unZip];
//    [self unRar];
//    [self Un7z];
    
//    Demonstrating the password protected files unarchiving
//    [self unZip_pwd];
//    [self unRar_pwd];
      [self un7z_pwd];
}

- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
      NSLog(@"For Archive : %@",filePath);
		for (NSString *filename in filePaths) {
			NSLog(@"Extracted Filepath: %@", filename);
		}
//        NSLog(@"filePaths.count: %d", filePaths.count);
    };
    unarchive.failureBlock = ^(){
//        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
}

- (void)unZip{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Zip_Example" ofType:@"zip"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:nil destinationPath:destPath];
}

- (void)unRar{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"rar"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:nil destinationPath:destPath];
}

- (void)Un7z{
    NSString *archiveFilename = @"example.7z";
    NSString *archiveResPath = [[NSBundle mainBundle] pathForResource:archiveFilename ofType:nil];
    NSAssert(archiveResPath, @"can't find .7z file");
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:archiveResPath andPassword:nil destinationPath:destPath];
}

- (void)unZip_pwd{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Zip_Example_pwd" ofType:@"zip"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:@"SARUnArchiveANY_ZIP" destinationPath:destPath];
}

- (void)unRar_pwd{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example_pwd" ofType:@"rar"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:@"SARUnArchiveANY_RAR" destinationPath:destPath];
}

- (void)un7z_pwd{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example_pwd" ofType:@"7z"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:@"SARUnArchiveANY_7z" destinationPath:destPath];
}


- (void)handleFileFromURL:(NSString *)filePath{
    NSLog(@"*********       FILES FROM THE OTHER APPS       *********");
    [self unArchive:filePath andPassword:nil destinationPath:nil];
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
