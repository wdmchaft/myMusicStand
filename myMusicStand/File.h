//
//  File.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TimestampEntity.h"

typedef enum {
    FilenameAvailable = 1,
    FilenameNotAvailable
} FilenameAvailability;

@class OrderedFile, Thumbnail;
@interface File : TimestampEntity {
@private
}
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSSet* orderedFiles;
@property (nonatomic, retain) NSString *alias;
@property (nonatomic, retain) Thumbnail *thumbnail; 

+ (File *)fileWithContext:(NSManagedObjectContext *)moc;
- (void)addOrderedFilesObject:(OrderedFile *)value;
- (void)removeOrderedFilesObject:(OrderedFile *)value;
- (void)addOrderedFiles:(NSSet *)value;
- (void)removeOrderedFiles:(NSSet *)value;

@end

@interface NSManagedObjectContext (FilenameAvailabilityCheck)

- (FilenameAvailability)checkAvailabilityOfFilename:(NSString *)filename;

@end
