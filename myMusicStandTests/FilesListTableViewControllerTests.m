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
    // The initial number of rows in the table should be 0
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
    //the alias is used and not the filename
    STAssertEqualObjects([file alias], [[cell textLabel] text], 
                         @"The text of the cell should be the filename");
    // Test cell height
    STAssertEquals(270, (int)[controller tableView:nil heightForRowAtIndexPath:indexPath], 
                   @"The height for a cell should be 270");
    
    // The content view of the cell should have 3 subviews
    STAssertEquals(3, (int)[[[cell contentView] subviews] count], 
                   @"The cell should have 3 subviews");
    
}

- (void)testIndexInTermsOfBase
{
    // Set the files in the controller
    
    STAssertEquals(2, [controller index:5 inTermsOfBase:3], 
                   @"Calculate the offset in terms of the base value");
    
}
@end
