//
//  SetlistTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BlockTableController.h"

@class NSManagedObjectContext;
@interface SetlistTableController : BlockTableController 

// Accessors for setting the add block display
-(void)setAddBlockShowing:(BOOL)enabled;
-(BOOL)isAddBlockShowing;
@end
