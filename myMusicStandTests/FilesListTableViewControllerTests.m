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

- (void)testControllerReadsFromCoreData
{
    id mockDelegate = [OCMockObject mockForClass:[myMusicStandAppDelegate class]];
    id mockContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
    FilesListTableViewController *controller = [[FilesListTableViewController alloc] init];
    [controller setDelegate:mockDelegate];
    NSArray *array = [NSArray arrayWithObject:[[[File alloc] init] autorelease]];
                      
    [[[mockDelegate stub] andReturn:mockContext] managedObjectContext];
    [[[mockContext stub] andReturn:array] allEntity:[OCMArg any]];
    
    [controller viewDidLoad];
    
    [mockContext verify];
    [mockDelegate verify];
    STAssertEquals(1, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The controller should know that there is 1 File");
}

@end
