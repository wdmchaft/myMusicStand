//
//  FilesListTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myMusicStandAppDelegate;
@interface FilesListTableViewController : UITableViewController 
<UITableViewDelegate>
{
    NSArray *files;
}

@property (nonatomic, retain) NSArray *files;
@end
