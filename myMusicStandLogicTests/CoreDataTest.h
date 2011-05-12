//
//  CoreDataTests.h
//  PDFPrototyping
//  
//  This SenTestCase subclass is to be used to make testing of 
//  CoreData functionality easier by wrapping the setUp/tearDown
//  needed into a convient class. 
//
//  PLEASE REMEMBER TO INCLUDE THE COREDATA MODEL FILE YOU WANT TO
//  TEST IN THE COPY BUNDLE RESOURCE FOR THAT TARGET CONTAINING THIS
//  ALL TESTS THAT SUBCLASS THIS ONE. enjoy and sorry for yelling =)
//
//  Created by Steve Solomon on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTest : SenTestCase {
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSManagedObjectContext *context;
}

@end
