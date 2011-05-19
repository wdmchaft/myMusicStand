//
//  TimestampEntity.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimestampEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * timestamp;

@end

@interface NSManagedObjectContext (EntityInCreationOrder)

- (NSArray *)allEntity:(NSString *)entityName;
@end