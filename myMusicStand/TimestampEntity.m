//
//  TimestampEntity.m
//  myMusicStand
//
//  Created by Steven Solomon on 7/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimestampEntity.h"


@implementation TimestampEntity
@dynamic timestamp;
@dynamic size;

@end

@implementation NSManagedObjectContext (EntityInCreationOrder)

// Get the all entitys with the name of entityName
- (NSArray *)allEntity:(NSString *)entityName 
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Set target entity
    [request setEntity:[NSEntityDescription entityForName:entityName
                                   inManagedObjectContext:self]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    // Make sure fetch request is cleaned up
    
    return [self executeFetchRequest:request error:nil];
    
}

@end