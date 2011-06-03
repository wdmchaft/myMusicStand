//
//  FilesListControllerTest.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesListTableViewControllerTests.h"
#import "FileTableController.h"
#import "myMusicStandAppDelegate.h"
#import "OCMock/OCMock.h"
#import "File.h"

@implementation FilesListTableViewControllerTests

- (void)setUp
{
    [super setUp];
    mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    [[[mockContext stub] andReturn:nil] allEntity:[OCMArg any]];
    controller = [[FileTableController alloc] initWithManagedObjectContext:mockContext];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)tearDown
{
    [controller release];
    [super tearDown];
}

- (void)testCellHeight
{
    // Test cell height
    STAssertEquals(270, (int)[controller tableView:nil heightForRowAtIndexPath:indexPath], 
                   @"The height for a cell should be 270");
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

/*
- (void)testFilesReloadedWhenNotifiedToReload
{
    // setup data
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [controller setTableView:mockTableView];
    
    // setup expectations
    [[mockTableView expect] reloadData];
    [[mockContext expect] allEntity:[OCMArg any]];
    
    // exercise
    NSNotification *notification = [NSNotification notificationWithName:@"ReloadTableNotification"
                                                                 object:self];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotification:notification];
    
    [mockTableView verify];
    [mockContext verify];
}*/
@end
