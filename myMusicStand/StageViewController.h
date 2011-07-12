//
//  StageViewController.h
//  myMusicStand
//
//  Created by Steve Solomon on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockTableController;
@interface StageViewController : UIViewController 

- (IBAction)tabIndexChanged:(UISegmentedControl *)sender;
- (IBAction)showActionItems:(UIBarButtonItem *)sender;
@end
