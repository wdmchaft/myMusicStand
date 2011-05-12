//
//  FilesListControllerTest.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesListTableViewControllerTests.h"
#import "FilesListTableViewController.h"
#import <OCMock/OCMock.h>
@implementation FilesListTableViewControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInitialNumberOfRowsZero
{
    FilesListTableViewController *controller = [[FilesListTableViewController alloc] init];
    STAssertEquals(0, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The initial number of rows should be 0 but it was %d", 
                   [controller tableView:nil numberOfRowsInSection:0]);
                   
}

@end
