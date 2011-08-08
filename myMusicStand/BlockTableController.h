/**
 *  @file BlockTableController
 *  @author Steven Solomon <solomon.steven.m@gmail.com>
 *  @date 5/19/11
 *
 *  @discussion
 *  This class allows any subclasses to display models in a multiple 
 *  model per row format within a tableView. It is a controller class 
 *  in the MVC pattern but doesn't meet the Cocoa standards as maintaining 
 *  an entire screen full of content so it isn't a viewController. 
 *  
 *  NOTE: this class is to be treated as abstract and shouldn't be instantiated.
 *  
 *  Throughout this application blocks are sometimes refered to as thumbnails.
 *
 */

extern const CGFloat BLOCK_WIDTH;
extern const CGFloat BLOCK_HEIGHT;
extern const CGFloat CELL_HEIGHT;

@class NSManagedObjectContext, NSManagedObject, StageViewController;
@interface BlockTableController : NSObject <UITableViewDelegate, UITableViewDataSource> {
    UINavigationController *__weak navigationController;
    UITableView *__weak tableView;
    NSManagedObjectContext *context;
    NSArray *model;
    BOOL isSelectingBlocks; // when charts can be selected
    NSMutableArray *selectedModels; // models selected by ui    
    NSMutableDictionary *blocksToModel; // mapping of blocks to model
    StageViewController *__weak delegate;
}

/**
 *  pointer to a navigationController
 */
@property (nonatomic, weak) UINavigationController *navigationController;

/**
 *  Pointer to TableView managed by this class.
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 *  Data that will be displayed in the table
 */
@property (nonatomic, retain) NSArray *model;

/**
 *  Allows toggling of thumbnail selection (aka blocks)
 */
@property (nonatomic, assign) BOOL isSelectingBlocks;

/**
 *  Currently selected models. This is a book keeping state
 *  so other classes can perform custom actions.
 */
@property (nonatomic, readonly) NSArray *selectedModels;

/**
 *  Pointer to our ViewController (tightly coupled sadly)
 */
@property (nonatomic, weak) StageViewController *delegate;

/**
 *  Designated initializer for subclasses
 *
 *  @param moc 
 *  NSManagedObjectContext used to save model changes and recieve notifications.
 *
 *  @param tv
 *  we manage the display of data for this table
 *  
 */
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc andTableView:(UITableView *)tv;

/**
 *  @abstract
 *  Method for creating a blockCell to display in the table
 *
 *  @discussion
 *  To be treated as a private method. In the future this should go away.
 *
 *  @param tableView 
 *  tableView to create a cell for.
 *
 *  @return 
 *  Created Cell with correct block layout.
 */
- (UITableViewCell *)blockCellForTableView:(UITableView *)tableView;

- (int)numberOfBlocks; // index for block cell
// Helper method for adding model coresponding to ui block to selectedModels (DONOT CALL DIRECTLY)
- (void)toggleBlockSelection:(UITapGestureRecognizer *)recognizer;
// No-op method that is used by by subclasses to create custom block configurations
- (void)customConfigurationForBlock:(UIView *)block label:(UILabel *)label checkMark:(UIImageView *)check atIndex:(int)index;
// Delete all selectedModels and allow for subclass to customize process
- (void)deleteSelectedModels;
// Called before a managedObject will be deleted (by user selection), 
// to allow for a custom event to occur such as removing the file from disk
- (void)customStepForDeletionOfModel:(NSManagedObject *)model;
// Called when file was be added to selectedModels 
- (void)customStepforAddingSelectedModel:(NSManagedObject *)aModel;
// Called when file is removed from selectedModels
- (void)customStepforRemovingSelectedModel:(NSManagedObject *)aModel;
@end
