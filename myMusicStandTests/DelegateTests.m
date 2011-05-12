//
//  SetupTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DelegateTests.h"
#import "myMusicStandAppDelegate.h"
#import "FilesListTableViewController.h"
#import "File.h"

@implementation DelegateTests

- (void)setUp
{
    [super setUp];
    appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)tearDown
{
    [super tearDown];
}
- (void)testAppDelegate 
{
    STAssertNotNil(appDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testWindowSubview
{
    UIWindow *window = [appDelegate window];
    STAssertEquals(1, (NSInteger)[[window subviews] count], 
                   @"The window shoud have 1 subview but it had %lu", [[window subviews] count]);
    
    UIView *subview;
    STAssertNoThrow(subview = [[window subviews] objectAtIndex:0], 
                    @"Accessing the subview should be valid");
    STAssertTrue([subview isKindOfClass:[UITableView class]], 
                 @"The subview should be a tableview");
}

- (void)testOutlets
{
    UIViewController *rootController = [appDelegate rootController];
    STAssertNotNil(rootController, @"The root controller outlet should be setup");
}

- (void)testFileSharingOn
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];

    STAssertEquals(YES, [[dict valueForKey:@"UIFileSharingEnabled"] boolValue], 
                   @"File sharing should be turned on");
}

- (void)testKnownFiles
{
    // Make appDelegate use our testing context to check files
    [appDelegate setManagedObjectContext:context];
    
    // Create file in our context
    [[File fileWithContext:context] setFilename:@"File1.pdf"];
    
    NSArray *expectedKnownFiles = [NSArray arrayWithObjects:@"File1.pdf", nil];
    STAssertEqualObjects(expectedKnownFiles, [appDelegate knownFileNames], 
                         @"The known files should return the files created");
}
@end

