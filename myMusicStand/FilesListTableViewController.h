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
    myMusicStandAppDelegate *delegate;
    NSArray *files;
}

@property (nonatomic, retain) myMusicStandAppDelegate *delegate;
@property (nonatomic, retain) NSArray *files;
@end
