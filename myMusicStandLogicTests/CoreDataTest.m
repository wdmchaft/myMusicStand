//
//  CoreDataTests.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTest.h"
#import <CoreData/CoreData.h>

@implementation CoreDataTest

- (void)setUp
{
    [super setUp];
    // Get the bundle for this class 
    //(the datamodel must be in the copy bundle resources for the target containing the tests)
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // Add an in memory persistent store, so we can test saving operations
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                              configuration:nil 
                                        URL:nil
                                    options:nil
                                      error:nil];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testManagedObjectContextSetup
{
    STAssertNotNil(coordinator, @"The coordinator shouldn't be nil");
    STAssertNotNil(context, @"The context shouldn't be nil");
    
}

@end
