//
//  FileDifferTests.m
//  FileDifferTests
//
//  Created by Steve Solomon on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileDifferTests.h"
#import "FileDiffer.h"

@implementation FileDifferTests

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

- (void)testReverseAddedFiles
{
    NSArray *fileList = [NSArray arrayWithObjects:@"New File.pdf", @"Second File.pdf", nil];
    
    NSArray *addedFiles = [FileDiffer diffForType:FileDiffTypeNew forFilesInDir:fileList andKnownFiles:[NSArray array]];
    
    NSArray *expectedFiles  = [NSArray arrayWithObjects:@"Second File.pdf", @"New File.pdf", nil];
    
    // Verify diff shows added files in sorted order
    STAssertEqualObjects(expectedFiles, addedFiles, @"Should contain the correct files but %@", addedFiles);
}

- (void)testRemovedFiles
{
    NSArray *fileList = [NSArray arrayWithObject:@"New File.pdf"];
    NSArray *removedFiles = [FileDiffer diffForType:FileDiffTypeStale 
                                      forFilesInDir:fileList 
                                      andKnownFiles:[NSArray arrayWithObject:@"Stale File.pdf"]];
    
    NSArray *expectedFiles = [NSArray arrayWithObject:@"Stale File.pdf"];
    
    // Verify diff shows removed files 
    STAssertEqualObjects(expectedFiles, removedFiles, @"Should contain the correct files but %@", removedFiles);
}

- (void)testAddedFiles
{
    NSArray *fileList = [NSArray arrayWithObjects:@"NewFile.pdf", @"inbox", nil];
    NSArray *addedFiles = [FileDiffer diffForType:FileDiffTypeNew 
                                    forFilesInDir:fileList 
                                    andKnownFiles:[NSArray array]];

    NSArray *expectedFiles = [NSArray arrayWithObject:@"NewFile.pdf"];
    STAssertEqualObjects(expectedFiles, addedFiles, @"Added files shouldn't contain anything unsupported");
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

