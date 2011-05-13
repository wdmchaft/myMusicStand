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
    [[File fileWithContext:context] setFilename:@"File1.pdf"];
    [[File fileWithContext:context] setFilename:@"File2.pdf"];
    [[File fileWithContext:context] setFilename:@"File3.pdf"];
    
    // Create an array for the controller to pull the file from
    NSArray *files = [context allEntity:@"File"];
    
    // Set the array to the controller
    [controller setFiles:files];
    
    // Test that the cell textLabel is properly set
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];

    // Test cell height
    STAssertEquals(270, (int)[controller tableView:nil heightForRowAtIndexPath:indexPath], 
                   @"The height for a cell should be 270");
    
    // The content view of the cell should have 3 subviews
    STAssertEquals(3, (int)[[[cell contentView] subviews] count], 
                   @"The cell should have 3 subviews");
    
    // Test tags in cell
    UILabel *subview = (UILabel *)[[cell contentView] viewWithTag:1];
    STAssertNotNil(subview, @"The tag should return a label");
    //the alias is used and not the filename
    STAssertEqualObjects(@"File1.pdf", [subview text],
                         @"The label's text should be the alias");
    
    subview = (UILabel *)[[cell contentView] viewWithTag:2];
    STAssertNotNil(subview, @"The tag should return a label");
    //the alias is used and not the filename
    STAssertEqualObjects(@"File2.pdf", [subview text],
                         @"The label's text should be the alias");
    
    subview = (UILabel *)[[cell contentView] viewWithTag:3];
    STAssertNotNil(subview, @"The tag should return a label");
    //the alias is used and not the filename
    STAssertEqualObjects(@"File3.pdf", [subview text],
                         @"The label's text should be the alias");
}

- (void)testControllerReturnsCorrectNumberOfRows
{
    // Test 1 additional value increment the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil]];
    STAssertEquals(3, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
    
    // Test 2 additional values increment the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"",nil]];
    STAssertEquals(2, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The number of rows should be 2");
    
    // Test 3 additional values incremente the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", 
                          @"", @"", @"", @"", @"", nil]];
    STAssertEquals(4, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
}

@end
