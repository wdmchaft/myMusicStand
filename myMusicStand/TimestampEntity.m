//
//  TimestampEntity.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimestampEntity.h"


@implementation TimestampEntity
@dynamic timestamp;

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
    [request autorelease];
    
    return [self executeFetchRequest:request error:nil];
    
}

@end
