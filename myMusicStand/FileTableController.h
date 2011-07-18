//
//  FilesListTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTableController.h"

@class myMusicStandAppDelegate, NSManagedObjectContext, StageViewController;
@interface FileTableController : BlockTableController <UITextFieldDelegate>



- (void)reloadFiles:(NSNotification *)notification;
-(void)editAlias:(UIGestureRecognizer *)recognizer;
@end
