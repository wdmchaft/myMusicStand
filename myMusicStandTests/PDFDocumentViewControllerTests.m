//
//  PDFDocumentViewControllerTests.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFDocumentViewControllerTests.h"
#import "PDFDocumentViewController.h"

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
    NSURL *url = [[NSURL alloc] initWithString:@""];
    PDFDocumentViewController *controller = [[PDFDocumentViewController alloc] initWithURL:url];
    STAssertNotNil(controller, @"Controller shouldn't be nil");
    
    STAssertThrows([[PDFDocumentViewController alloc] initWithNibName:nil bundle:nil], 
                   @"Should be illegal to use this initializer");
    
    STAssertThrows([[PDFDocumentViewController alloc] initWithURL:nil], 
                   @"Should be illegal to pass nil");
}
@end
