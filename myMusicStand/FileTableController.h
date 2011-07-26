//
//  FilesListTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTableController.h"

@class myMusicStandAppDelegate, NSManagedObjectContext, StageViewController, File;
@interface FileTableController : BlockTableController <UITextFieldDelegate>


@property (nonatomic, assign) BOOL canDragBlocks;
// can be used by a delegate to specify the selector to use to respond to block gestures
@property (nonatomic, assign) SEL longPressSelector; 
@property (nonatomic, weak) id longPressTarget;

- (void)reloadFiles:(NSNotification *)notification;
-(void)editAlias:(UIGestureRecognizer *)recognizer;
- (File *)fileForBlock:(UIView *)block; // returns the file for the coresponding block
@end
