//
//  BlockTableViewController.h
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface BlockTableViewController : UITableViewController {
    IBOutlet UITableViewCell *tvCell;
}

- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
@end
