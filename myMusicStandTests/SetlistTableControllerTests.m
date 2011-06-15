//
//  SetlistTableControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetlistTableControllerTests.h"
#import "SetlistTableController.h"
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
    STAssertEquals(5, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
}

@end
