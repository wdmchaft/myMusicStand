//
//  BlockTableViewController.h
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface BlockTableController : NSObject <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableViewCell *tvCell;
    UINavigationController *navigationController;
}

@property (nonatomic, assign) UINavigationController *navigationController;
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
@end
