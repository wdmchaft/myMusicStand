//
//  TimestampEntity.h
//  myMusicStand
//
//  Created by Steven Solomon on 7/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimestampEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * size;

@end

@interface NSManagedObjectContext (EntityInCreationOrder)
// Get the all entitys with the name of entityName
- (NSArray *)allEntity:(NSString *)entityName;
@end