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
    NSArray *model;
    BOOL isSelectingBlocks; // when charts can be selected
    NSMutableArray *selectedModels;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSArray *model;
@property (nonatomic, assign) BOOL isSelectingBlocks;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv;
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
- (int)numberOfBlocks; // index for block cell
@end
