//
//  FilesListControllerTest.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesListTableViewControllerTests.h"
#import "FilesListTableViewController.h"
#import "myMusicStandAppDelegate.h"
#import "File.h"
#import <OCMock/OCMock.h>

@implementation FilesListTableViewControllerTests

- (void)setUp
{
    [super setUp];
    // Setup fake delegate and managedObjectContext to test FilesListTableViewController
    mockDelegate = [OCMockObject mockForClass:[myMusicStandAppDelegate class]];
    mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    
    // FilesListTableViewController is the SUT in this test suit
    controller = [[FilesListTableViewController alloc] init];
    // Set the fake delegate as the delegate for the controller
    [controller setDelegate:mockDelegate];
}

- (void)tearDown
{
    // Verify methods called
    [mockContext verify];
    [mockDelegate verify];
    [super tearDown];
}

- (void)testInitialNumberOfRowsZero
{
    STAssertEquals(0, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The initial number of rows should be 0 but it was %d", 
                   [controller tableView:nil numberOfRowsInSection:0]);
                   
}

- (void)testControllerReadsFromCoreData
{
    // Setup - data
    NSArray *array = [NSArray arrayWithObject:[[[File alloc] init] autorelease]];
                   
    // Setup - stubs
    [[[mockDelegate stub] andReturn:mockContext] managedObjectContext];
    [[[mockContext stub] andReturn:array] allEntity:[OCMArg any]];
    
    // Exercise
    [controller viewDidLoad];
    
    // The controller should now know that there is one File in it's list
    STAssertEquals(1, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The controller should know that there is 1 File");
}

- (void)testControllerCreatesCellsCorrectly
{
    // File to be displayed in the tableview
    File *file = [File fileWithContext:context];
    [file setFilename:@"File1.pdf"];
    // Create an array for the controller to pull the file from
    NSArray *files = [NSArray arrayWithObject:file];
    
    // Set the array to the controller
    [controller setFiles:files];
    
    // Test that the cell textLabel is properly set
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
    STAssertEqualObjects(@"File1.pdf", [[cell textLabel] text], 
                         @"The text of the cell should be the filename");
}
@end
