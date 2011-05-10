//
//  OrderedFile.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Setlist;

@interface OrderedFile : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSManagedObject * file;
@property (nonatomic, retain) Setlist * setlist;

+ (OrderedFile *)orderedFileWithContext:(NSManagedObjectContext *)moc;
@end
