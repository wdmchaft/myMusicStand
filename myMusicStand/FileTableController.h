//
//  FilesListTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTableController.h"

@class myMusicStandAppDelegate, NSManagedObjectContext;
@interface FileTableController : BlockTableController <UITextFieldDelegate>
{
    NSArray *model;
    // mapping of blockview to a filename, this will allow us to
    // quickly load the file when tapped
    NSMutableDictionary *blocksToFilenames; 
}

@property (nonatomic, retain) NSArray *model;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;
-(void)editAlias:(UIGestureRecognizer *)recognizer;
@end
