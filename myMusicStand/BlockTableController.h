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
    UITableView *tableView;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UITableView *tableView;
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
@end
