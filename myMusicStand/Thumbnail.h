//
//  Thumbnail.h
//  myMusicStand
//
//  Created by Steven Solomon on 7/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File;

@interface Thumbnail : NSManagedObject {
@private
}
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) File *file;

@end
