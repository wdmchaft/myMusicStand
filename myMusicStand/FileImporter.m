//
//  FileImporter.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileImporter.h"
#import "myMusicStandAppDelegate.h"

@implementation FileImporter

#pragma mark - Import file Methods
- (BOOL)importFileAtURL:(NSURL *)url withFileManger:(NSFileManager *)fileManger error:(NSError *)error
{
    NSURL *toURL = [self createDocumentURLfromSrcURL:url];
    
    [fileManger copyItemAtURL:url toURL:toURL error:&error];
    
    if (error)
    {
        return NO;
    }
    
    return YES;
}

- (NSURL *)createDocumentURLfromSrcURL:(NSURL *)srcURL
{
    NSURL *destURL = [[myMusicStandAppDelegate sharedInstance] applicationDocumentsDirectory];
    return [destURL URLByAppendingPathComponent:[srcURL lastPathComponent] isDirectory:NO];
}

@end
