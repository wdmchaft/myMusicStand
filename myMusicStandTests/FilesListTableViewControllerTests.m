//
//  FilesListControllerTest.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesListTableViewControllerTests.h"
#import "FilesListTableViewController.h"
#import "myMusicStandAppDelegate.h"
#import "File.h"

@implementation FilesListTableViewControllerTests

- (void)setUp
{
    [super setUp];
    controller = [[FilesListTableViewController alloc] init];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)tearDown
{
    [controller release];
    [super tearDown];
}

- (void)testInitialNumberOfRowsZero
{
    // The initial number of rows in the table should be 0
    STAssertEquals(0, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The initial number of rows should be 0 but it was %d", 
                   [controller tableView:nil numberOfRowsInSection:0]);
                   
}

- (void)testBackgroundIsCorrectImage
{
    UITableView *tableView = [controller tableView];
    UIImageView *backgroundView = (UIImageView *)[tableView backgroundView];
    UIImage *expectedImage = [UIImage imageNamed:@"floorAndStage.png"];
    STAssertEqualObjects(expectedImage, [backgroundView image], 
                         @"The image should be the floorAndStage image");
}

- (void)testCellHasRecognizerForModel
{
    // Create three files to display in the cell so we can validate the recognizers
    [File fileWithContext:context];
    [File fileWithContext:context];
    
    // Give the controller the files we have created so we can verify cell setup
    [controller setFiles:[context allEntity:@"File"]];
    
    // Get the cell for the indexPath
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
    // label for the first element in the cell
    UILabel *label;
    int tag = 1; // tag for each label in the cell
    int exepectedCount = 0;
    
    // Loop through each label and make sure it has configured correctly
    for (; tag < 4; tag++)
    {
        // test cell label is configured based on files
        label= (UILabel *)[[cell contentView] viewWithTag:tag];
        
        // if label's text is not empty it should have one recognizer else no recognizer
        exepectedCount = (![[label text] isEqualToString:@""]) ? 1 : 0;
        
        // Label should have one gesture recognizer
        STAssertEquals(exepectedCount, (int)[[label gestureRecognizers] count], 
                       @"The label should have exactly one gesture recognizer");
        
    }
    
    

}

- (void)testEditAliasMethod
{
    // Create one file to display in the controller
    [File fileWithContext:context];
    
    // Give the controller the files
    [controller setFiles:[context allEntity:@"File"]];
    
    // Get the cell for our index
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
    
    // Get the label for the file
    UILabel *label = (UILabel *)[[cell contentView] viewWithTag:1];
    
    // call method and pass recognizer from label
    [controller editAlias:[[label gestureRecognizers] objectAtIndex:0]];

    // hit test the cell and see what view we get
    UIView *textBox = [cell hitTest:[label center] withEvent:nil];
    
    STAssertTrue([textBox isKindOfClass:[UITextField class]], 
                 @"The textbox should be vaild");
}

- (void)testCellSetupWhenControllerHasNoFiles
{
        
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
    // Loop through all UILabels in the cell's contentView 
    // !!!THIS ASSUMES THAT THE CONTROLLER HAS NO!! FILES TO DISPLAY
    for (UILabel *subview in [[cell contentView] subviews])
    {
        // Check the label is blank
        STAssertEqualObjects(@"", [subview text], 
                             @"A subview's text should be empty after a call to prepareForReuse");
        
        // Check the width of the label
        STAssertEquals(162, (int)subview.bounds.size.width, 
                       @"The width of the label should be 162");
        
        // The font size shouldn't change to fit text
        STAssertFalse([subview adjustsFontSizeToFitWidth], @"The font size shouldn't vary");
        
        // Label should have user interaction enabled
        STAssertTrue([subview isUserInteractionEnabled], 
                     @"The user interaction should be enabled");
        
    }
    
    // The content view of the cell should have 3 subviews
    STAssertEquals(3, (int)[[[cell contentView] subviews] count], 
                   @"The cell should have 3 subviews");
}

- (void)testCellHeight
{
    // Test cell height
    STAssertEquals(270, (int)[controller tableView:nil heightForRowAtIndexPath:indexPath], 
                   @"The height for a cell should be 270");
}

- (void)testTableViewSelectionStyle
{
    UITableView *tableView = [controller tableView];
    STAssertFalse([tableView allowsSelection], @"The table shouldn't allow select");
}

- (void)testTableSeparatorStyleShouldBeNone
{
    UITableView *tableView = [controller tableView];
    STAssertEquals(UITableViewCellSeparatorStyleNone, [tableView separatorStyle],
                   @"The tableView's separator style should be none");
}

- (void)testControllerCreatesCellsCorrectly
{
    NSArray *filenames = [NSArray arrayWithObjects:@"File1.pdf", @"File2.pdf",
                          @"File3.pdf", @"File4.pdf", @"File5.pdf", nil];
    // Files to be displayed in the tableview
    for (NSString *filename in filenames)
    {
        [[File fileWithContext:context] setFilename:filename];
    }
    
    // Set the files in the controller
    [controller setFiles:[context allEntity:@"File"]];
    
    // Test that the cell textLabel is properly set
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
    
    // Loop through rows 
    int i = 0;
    int tagOffset = 0; // tag offset
    UILabel *subview;

    // loop through each table cell 
    for (int count = 0; count < [controller tableView:nil numberOfRowsInSection:0]; count++)
    {
        // loop through each subview in a table cell
        for (; i < [filenames count] && tagOffset < 3; i++)
        {
            // Test tags in cell
            subview = (UILabel *)[[cell contentView] viewWithTag:tagOffset + 1];
            STAssertNotNil(subview, @"The tag should return a label");
                        
            //the alias is used and not the filename
            STAssertEqualObjects([filenames objectAtIndex:i], [subview text],
                                 @"The label's text should be the alias");
            
            tagOffset++;
        }
        
        // Test second cell
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
        
        // reset the offset
        tagOffset = 0;
    }
    
    // Test prepare for reuse clears all labels
    [cell prepareForReuse];
    for (UILabel *subview in [[cell contentView] subviews])
    {
        
        // text in label should be empty
        STAssertEqualObjects(@"", [subview text], 
                             @"A subview's text should be empty after a call to prepareForReuse");
    }
    
    
}

- (void)testControllerReturnsCorrectNumberOfRows
{
    // Test 1 additional value increment the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil]];
    STAssertEquals(3, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
    
    // Test 2 additional values increment the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"",nil]];
    STAssertEquals(2, [controller tableView:nil numberOfRowsInSection:0], 
                   @"The number of rows should be 2");
    
    // Test 3 additional values incremente the row
    [controller setFiles:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", 
                          @"", @"", @"", @"", @"", nil]];
    STAssertEquals(4, [controller tableView:nil numberOfRowsInSection:0], 
                   @"Calculate the offset in terms of the base value");
}

@end
