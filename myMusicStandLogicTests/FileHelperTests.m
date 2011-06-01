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
    NSArray *fileList = [NSArray arrayWithObject:@"New File.pdf"];    
    NSArray *addedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray array], FileDiffTypeNew);
    NSArray *expectedFiles  = [NSArray arrayWithObject:@"New File.pdf"];
    
    // Verify diff shows files were added to the directory
    STAssertEqualObjects(expectedFiles, addedFiles, @"Should contain the correct files but %@", addedFiles);
    
}

- (void)testReverseAddedFiles
{
    NSArray *fileList = [NSArray arrayWithObjects:@"New File.pdf", @"Second File.pdf", nil];
    NSArray *addedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray array], FileDiffTypeNew);
    NSArray *expectedFiles  = [NSArray arrayWithObjects:@"Second File.pdf", @"New File.pdf", nil];
    
    // Verify diff shows added files in sorted order
    STAssertEqualObjects(expectedFiles, addedFiles, @"Should contain the correct files but %@", addedFiles);
}

- (void)testRemovedFiles
{
    NSArray *fileList = [NSArray arrayWithObject:@"New File.pdf"];
    NSArray *removedFiles = filesDiffWithFileslistAndKnownFiles(fileList, [NSArray arrayWithObject:@"Stale File.pdf"], 
                                                                FileDiffTypeStale);
    NSArray *expectedFiles = [NSArray arrayWithObject:@"Stale File.pdf"];
    
    // Verify diff shows removed files 
    STAssertEqualObjects(expectedFiles, removedFiles, @"Should contain the correct files but %@", removedFiles);
}

@end

NSArray *filesInDirectory(NSString *path)
{
    if ([@"Another Fake Directory" isEqual:path])
    {
        return [NSArray arrayWithObjects:@"New File.pdf", @"Second File.pdf", nil];
    }
    return [NSArray arrayWithObject:@"New File.pdf"];
    
}

