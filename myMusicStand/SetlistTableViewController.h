//
//  SetlistTableViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetlistTableViewController : UITableViewController {
    NSMutableArray *setlists;
}

@property (nonatomic, retain) NSMutableArray *setlists;
@end
