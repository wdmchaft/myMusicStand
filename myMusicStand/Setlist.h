//
//  Setlist.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TimestampEntity.h"

@class File;
@interface Setlist : TimestampEntity {
@private
}
@property (nonatomic, retain) NSSet* orderedFiles;
@property (nonatomic, retain) NSString *title;

- (void)addOrderedFilesObject:(NSManagedObject *)value;
- (void)removeOrderedFilesObject:(NSManagedObject *)value;
- (void)addOrderedFiles:(NSSet *)value;
- (void)removeOrderedFiles:(NSSet *)value;

+ (Setlist *)setlistWithContext:(NSManagedObjectContext *)moc;
- (void)removeFileAtIndex:(NSInteger)index inContext:(NSManagedObjectContext *)moc;
- (void)insertFile:(File *)afile forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)moc;
// Return orderedFiles sorted by index
- (NSArray *)orderedFilesInOrder;
- (NSArray *)filesInOrder;
@end
