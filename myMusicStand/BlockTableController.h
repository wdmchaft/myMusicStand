//
//  BlockTableViewController.h
//  
//
//  Created by Steve Solomon on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class NSManagedObjectContext;
@interface BlockTableController : NSObject <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableViewCell *tvCell;
    UINavigationController *navigationController;
    UITableView *tableView;
    NSManagedObjectContext *context;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UITableView *tableView;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
- (int)index; // index for block cell
@end
