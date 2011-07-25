//
//  FileImporterTests.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileImporterTests.h"
#import "myMusicStandAppDelegate.h"
#import <OCMock/OCMock.h>
#import "FileImporter.h"

@implementation FileImporterTests
{
    FileImporter *fileImporter;
    NSURL *src;
}

- (void)setUp
{
    [super setUp];
    fileImporter = [[FileImporter alloc] init];
    
    myMusicStandAppDelegate *appDelegate = [myMusicStandAppDelegate sharedInstance];
    
    src = [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"example.pdf"
                                                                       isDirectory:NO];
}

- (void)testFileCopiedIntoDocumentsDir
{
    id mockManager = [OCMockObject mockForClass:[NSFileManager class]];
    
    NSError *error = nil;
    
    [[mockManager expect] copyItemAtURL:[OCMArg any] toURL:[OCMArg any] 
                                  error:&error];
    
    BOOL success = [fileImporter importFileAtURL:src withFileManger:mockManager error:error];
    
    STAssertEquals(YES, success, @"The file should return that it has been successfully imported");
    
    [mockManager verify];
}

- (void)testDestURLcontainsTheNameOfTheFile
{
    
    NSURL *dest = [fileImporter createDocumentURLfromSrcURL:src];
    
    NSString *fileName = [dest lastPathComponent];
    
    // last component should be the filename
    STAssertEqualObjects(@"example.pdf", fileName, @"last path component should be the filename");
}


@end
