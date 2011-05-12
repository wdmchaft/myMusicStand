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

@implementation FilesListTableViewControllerTests

- (void)setUp
{
    [super setUp];
    controller = [[FilesListTableViewController alloc] init];
}

- (void)tearDown
{
    [controller release];
    [super tearDown];
}

- (void)testInitialNumberOfRowsZero
{
    STAssertEquals(0, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The initial number of rows should be 0 but it was %d", 
                   [controller tableView:nil numberOfRowsInSection:0]);
                   
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
