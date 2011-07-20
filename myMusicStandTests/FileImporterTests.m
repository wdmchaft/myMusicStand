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
}

- (void)setUp
{
    [super setUp];
    fileImporter = [[FileImporter alloc] init];
}

- (void)testCopyFileIntoDocuments
{
    id mockManager = [OCMockObject mockForClass:[NSFileManager class]];
    
    [[mockManager expect] copyItemAtURL:[OCMArg any] toURL:[OCMArg any] error:nil];
    
    [fileImporter loadNewFileURL:nil withFileManger:mockManager];
    
    [mockManager verify];
}

- (void)testLastPathComponentsInDestIsDocumentsAndFile
{
    myMusicStandAppDelegate *appDelegate = [myMusicStandAppDelegate sharedInstance];
    
    NSURL *src = [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"example.pdf"
                                                                              isDirectory:NO];
    
    NSURL *dest = [fileImporter createDocumentURLfromSrcURL:src];
    
    NSString *fileName = [dest lastPathComponent];
    
    // last component should be the filename
    STAssertEqualObjects(@"example.pdf", fileName, @"last path component should be the filename");
}


@end
