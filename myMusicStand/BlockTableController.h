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
    NSMutableArray *selectedModels; // models selected by ui    
    NSMutableDictionary *blocksToModel; // mapping of blocks to model
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSArray *model;
@property (nonatomic, assign) BOOL isSelectingBlocks;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv;
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;
- (int)numberOfBlocks; // index for block cell
// Helper method for adding model coresponding to ui block to selectedModels (DONOT CALL DIRECTLY)
- (void)toggleBlockSelection:(UITapGestureRecognizer *)recognizer;
// No-op method that is used by by subclasses to create custom block configurations
- (void)customConfigurationForBlock:(UIView *)block label:(UILabel *)label checkMark:(UIImageView *)check atIndex:(int)index;
@end
