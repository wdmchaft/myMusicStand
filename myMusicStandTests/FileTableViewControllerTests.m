//
//  FilesListControllerTest.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileTableViewControllerTests.h"
#import "FileTableController.h"
#import "myMusicStandAppDelegate.h"
#import "OCMock/OCMock.h"
#import "File.h"

@implementation FileTableViewControllerTests

- (void)setUp
{
    [super setUp];
    mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    mockTableView = [OCMockObject mockForClass:[UITableView class]];
    
    // TableView must expect it's setup
    [[mockTableView expect] setDelegate:[OCMArg any]];
    [[mockTableView expect] setDataSource:[OCMArg any]];
    
    // Expect files to be loaded to display on instantiation
    [[mockContext expect] allEntity:@"File"];
    [[[mockContext stub] andReturn:nil] allEntity:@"File"];
    
    controller = [[FileTableController alloc] initWithManagedObjectContext:mockContext 
                                                              andTableView:mockTableView];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)tearDown
{
    mockContext = nil;
    mockTableView = nil;
    [super tearDown];
}

- (void)testCellHeight
{
    // Test cell height
    STAssertEquals(270, (int)[controller tableView:nil heightForRowAtIndexPath:indexPath], 
                   @"The height for a cell should be 270");
}

- (void)testIllegalSetup
{
    STAssertThrows((void)[[FileTableController alloc] init], @"Should be illegal");
       
}

- (void)testControllerReturnsCorrectNumberOfRows
{
    // Test 1 additional value increment the row
    [controller setModel:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil]];
    STAssertEquals(3, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
    
    // Test 2 additional values increment the row
    [controller setModel:[NSArray arrayWithObjects:@"", @"", @"", @"", @"",nil]];
    STAssertEquals(2, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The number of rows should be 2");
    
    // Test 3 additional values incremente the row
    [controller setModel:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", 
                          @"", @"", @"", @"", @"", nil]];
    STAssertEquals(4, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
}

@end
