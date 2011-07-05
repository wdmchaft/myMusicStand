//
//  PDFDocumentViewControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFDocumentViewControllerTests.h"
#import "PDFDocumentViewController.h"
#import "myMusicStandAppDelegate.h"
@implementation PDFDocumentViewControllerTests

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

- (void)testInitilization
{
    // Invalid ways to init
    STAssertThrows([[PDFDocumentViewController alloc] initWithNibName:nil bundle:nil], 
                   @"Should be illegal to use this initializer");
    
    STAssertThrows([[PDFDocumentViewController alloc] initWithURL:nil], 
                   @"Should be illegal to pass nil");
    
    // Copy a file from our tests bundle to app on simulator docs folder
    NSURL *docsURL = [[myMusicStandAppDelegate sharedInstance] applicationDocumentsDirectory];
    docsURL = [docsURL URLByAppendingPathComponent:@"firsttime.pdf" isDirectory:NO];
    NSURL *fileToAdd = 
        [[NSURL alloc] initFileURLWithPath:
                @"/Users/stevensolomon/Documents/myMusicStand/myMusicStandTests/firsttime.pdf" 
                               isDirectory:NO];
    [[NSFileManager defaultManager] copyItemAtURL:fileToAdd toURL:docsURL error:nil];
    
    PDFDocumentViewController *controller = [[PDFDocumentViewController alloc] initWithURL:docsURL];
    STAssertNotNil(controller, @"Controller shouldn't be nil");
}
@end
