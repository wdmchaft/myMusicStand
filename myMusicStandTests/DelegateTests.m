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
    rootController = [appDelegate rootController];
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


// Verfies filediffes have been found and files have been given to rootController
- (void)testFilesAreGivenToControllerAfterLauch
{
    // Simulate application launch
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    
    // The files in the rootController should have been set
    STAssertEquals(2, (int)[[rootController files] count], 
                   @"The files should have been given to the root controller");
}

@end

// Overriding the method for filemanager will allow for testing of delegates use of diffing
@implementation NSFileManager (FakingDirectory)

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
{
    return [NSArray arrayWithObjects:@"File1.pdf", @"File3.pdf", nil];
}

@end