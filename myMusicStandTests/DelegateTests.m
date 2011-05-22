//
//  SetupTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DelegateTests.h"
#import "myMusicStandAppDelegate.h"
#import "FilesListTableViewController.h"
#import "SetlistTableViewController.h"
#import "OCMock/OCMock.h"
#import "File.h"

@implementation DelegateTests

- (void)setUp
{
    [super setUp];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Make appDelegate use our testing context 
    // instead of setting up it's own
    [appDelegate setManagedObjectContext:context];
    
    // Create file in our context 
    file = [File fileWithContext:context];
    [file setFilename:@"File1.pdf"];
    
    // Set the root controller to the rootController of the appDelegate
    rootController = (FilesListTableViewController *)[appDelegate rootController];
}

- (void)tearDown
{
    [super tearDown];
}
- (void)testAppDelegate 
{
    STAssertNotNil(appDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testOutlets
{
    
    STAssertNotNil(rootController, @"The root controller outlet should be setup");
}

- (void)testFileSharingOn
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];

    STAssertEquals(YES, [[dict valueForKey:@"UIFileSharingEnabled"] boolValue], 
                   @"File sharing should be turned on");
}

- (void)testKnownFiles
{
    NSArray *expectedKnownFiles = [NSArray arrayWithObjects:@"File1.pdf", nil];
    STAssertEqualObjects(expectedKnownFiles, [appDelegate knownFileNames], 
                         @"The known files should return the files created");
}

- (void)testFilesDiffAdditions
{
    // setup data 
    id mockFileManager = [OCMockObject mockForClass:[NSFileManager class]];
    NSArray *expectedFileNames = [NSArray arrayWithObjects:@"File1.pdf", @"File3.pdf", nil];

    // setup expectations
    [[[mockFileManager stub] andReturn:expectedFileNames] contentsOfDirectoryAtPath:[OCMArg any] error:[OCMArg anyPointer]];
    
    // exercise checkForFileDiffs method
    [appDelegate checkForFileDiffs:mockFileManager];
    
    // We expect File3.pdf to be added 
    [mockFileManager verify];
    STAssertEqualObjects(expectedFileNames, [appDelegate knownFileNames], 
                         @"The files should have a new file");
    
}

- (void)testFileDiffStale
{
    // setup data
    id mockFileManager = [OCMockObject mockForClass:[NSFileManager class]];
    NSArray *expectedFileNames = [NSArray array];
    
    // setup expectations 
    [[[mockFileManager stub] andReturn:expectedFileNames] contentsOfDirectoryAtPath:[OCMArg any] error:[OCMArg anyPointer]];
    
    // exercise checkForFileDiffs method
    [appDelegate checkForFileDiffs:mockFileManager];
    
    // we expecte File1.pdf to have been removed
    [mockFileManager verify];
    STAssertEqualObjects(expectedFileNames, [appDelegate knownFileNames], 
                         @"The files should have removed the stale file");
}
@end
