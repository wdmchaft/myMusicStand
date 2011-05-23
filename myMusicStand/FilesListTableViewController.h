//
//  FilesListTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTableViewController.h"

@class myMusicStandAppDelegate;
@interface FilesListTableViewController : BlockTableViewController 
<UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *files;
    // mapping of blockview to a filename, this will allow us to
    // quickly load the file when tapped
    NSMutableDictionary *blocksToFilenames; 
    IBOutlet UITableViewCell *tvCell;
}

@property (nonatomic, retain) NSArray *files;

-(void)editAlias:(UIGestureRecognizer *)recognizer;
@end
