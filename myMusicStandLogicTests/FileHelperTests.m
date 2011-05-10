//
//  PDFPrototypingTests.m
//  PDFPrototypingTests
//
//  Created by Steve Solomon on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileHelperTests.h"
#import "FileHelpers.h"

@implementation FileHelperTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAddedFiles
{
    NSArray *fileList = filesInDirectory(@"Fake Directory");    
    NSArray *addedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray array], FileDiffTypeNew);
    NSArray *expectedFiles  = [NSArray arrayWithObject:@"New File.pdf"];
    STAssertEqualObjects(expectedFiles, addedFiles, @"Should contain the correct files but %@", addedFiles);
    
}

- (void)testReverseAddedFiles
{
    NSArray *fileList = filesInDirectory(@"Another Fake Directory");
    NSArray *addedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray array], FileDiffTypeNew);
    NSArray *expectedFiles  = [NSArray arrayWithObjects:@"Second File.pdf", @"New File.pdf", nil];
    STAssertEqualObjects(expectedFiles, addedFiles, @"Should contain the correct files but %@", addedFiles);
}

- (void)testRemovedFiles
{
    NSArray *fileList = filesInDirectory(@"Fake Directory");
    NSArray *removedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray arrayWithObject:@"Stale File.pdf"], 
                                                                FileDiffTypeStale);
    NSArray *expectedFiles = [NSArray arrayWithObject:@"Stale File.pdf"];
    STAssertEqualObjects(expectedFiles, removedFiles, @"Should contain the correct files but %@", removedFiles);
}

@end
