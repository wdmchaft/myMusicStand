//
//  OrderedFileTests.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderedfileTests.h"
#import "OrderedFile.h"

@implementation OrderedfileTests

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

- (void)testLearningOrderedFile
{
    OrderedFile *orderedFile = [OrderedFile orderedFileWithContext:context];
    STAssertNotNil(orderedFile, @"The ordered file should have been created");
}
@end
