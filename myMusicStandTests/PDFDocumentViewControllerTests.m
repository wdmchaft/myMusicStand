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

- (void)testInit
{
    PDFDocumentViewController *controller = [[PDFDocumentViewController alloc] initWithURL:nil];
    STAssertNotNil(controller, @"Controller shouldn't be nil");
}
@end
