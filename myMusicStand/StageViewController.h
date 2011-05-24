//
//  StageViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockTableController;
@interface StageViewController : UIViewController {
    BlockTableController *blockController;
    NSManagedObjectContext *context;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *bottomOfStand;
}

@end
