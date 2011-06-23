//
//  SetlistTableControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTableControllerTests.h"
#import "SetlistTableController.h"
#import "Setlist.h"
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>

@implementation SetlistTableControllerTests

- (void)setUp
{
    [super setUp];
    mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    mockTableView = [OCMockObject mockForClass:[UITableView class]];
    
    // TableVie must expect it's setup
    [[mockTableView expect] setDelegate:[OCMArg any]];
    [[mockTableView expect] setDataSource:[OCMArg any]];

    // Expect files to be loaded to display on instanciation
    [[mockContext expect] allEntity:@"Setlist"];
    
    controller = [[SetlistTableController alloc] initWithManagedObjectContext:mockContext
                                                                 andTableView:mockTableView];
}

- (void)tearDown
{
    // Tear-down code here.
    [mockTableView verify];
    [mockContext verify];
    [super tearDown];
}

- (void)testSetup
{
      
    STAssertNotNil(controller, @"Controller should have been setup");
}

- (void)testIllegalSetup
{
    STAssertThrows([[SetlistTableController alloc] init], @"Should be illegal");
}

- (void)testControllerReturnsCorrectNumberOfRows
{
    // Two setlists and one add block
    [controller setModel:[NSArray arrayWithObjects:@"", @"", nil]];
    STAssertEquals(1, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Should have returned the number of rows");
    
    // One setlist and one add block
    [controller setModel:[NSArray arrayWithObjects:@"", nil]];
    STAssertEquals(1, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Should have returned the number of rows");
    
    // Three setlists and one add block
    [controller setModel:[NSArray arrayWithObjects:@"", @"", @"", nil]];
    STAssertEquals(2, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Should have returned the number of rows");
}

@end
