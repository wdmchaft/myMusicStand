//
//  PDFDocumentViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFDocumentViewController.h"
#import "PDFDocument.h"
#import "PDFHelpers.h"
#import "PDFScrollView.h"
#import "StageViewController.h"
#import <MessageUI/MessageUI.h>

#define PDF_PAGE_SPACE 10
#define DOUBLE_PAGE_SPACE (2 * PDF_PAGE_SPACE)
#define RECOGNIZER_SHOULD_RECIEVE_TOUCH YES
#define RECOGNIZER_SHOULD_NOT_RECIEVE_TOUCH NO
#define UNTOUCHABLE_AREA_HEIGHT 60
#define BACK_BUTTON_X_OFFSET 20
#define PAGE_NOT_FOUND NO
#define PAGE_FOUND YES

@interface PDFDocumentViewController ()
#pragma mark Private Methods
// Helper method used as a callback to display the pdf once loaded
- (void)documentStateHasBeenUpdated;
- (void)handleTap:(UIGestureRecognizer *)recognizer;
// returns a PDFScrollView from the recycledPages set
- (PDFScrollView *)dequeRecycledPage; 
// Tiles PDFScrollViews within pagingScrollView
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
@end

@implementation PDFDocumentViewController
{
#pragma mark Instance Variables
    // The document we will display
    PDFDocument *document;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIScrollView *pagingScrollView; // same as view
    StageViewController *__weak delegate;
    
    // Sets for tiling PDFScrollViews
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}

@synthesize document;
@synthesize delegate;

#pragma mark Initializers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)url
{
    if (!url)
    {
        @throw @"Param url must not be nil";
    }
    
    self = [super initWithNibName:@"PDFDocumentViewController" bundle:nibBundleOrNil];
    if (self) {
        document = [[PDFDocument alloc] initWithFileURL:url];
        
        // open the file, in the callback we will setup the view structure
        [document openWithCompletionHandler:^(BOOL fileIsOpen){
            [self documentStateHasBeenUpdated];
        }];
        
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw @"Illegal instance instead use initWithURL:";
}

#pragma mark Memory Warning
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Helper methods
- (void)documentStateHasBeenUpdated
{
    CGRect frame = [pagingScrollView bounds];
    
    [pagingScrollView setContentSize:CGSizeMake(frame.size.width * [document numberOfPages], 
                                                frame.size.height)];
    
    // Bring the button to the front
    [pagingScrollView bringSubviewToFront:backButton];
    
    // Setup our tiling helper objects
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages = [[NSMutableSet alloc] init];
    
    // Get tiling started
    [self tilePages]; 
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    // Check if we are displaying a page
    for (PDFScrollView *page in visiblePages) 
    {
        if ( ([page pageNumber]-1) == index) 
        {
            return PAGE_FOUND;
        }
    }
    
    return PAGE_NOT_FOUND;
}

- (PDFScrollView *)dequeRecycledPage
{
    // Get any available recycled page and return it
    PDFScrollView *page = [recycledPages anyObject];
    
    if (page)
    {
        // if not nil it is no longer available for recycling
        [recycledPages removeObject:page];
    }
    
    return page;
}

- (void)tilePages
{
    // Calculate what pages should be visible 
    CGRect visibleBounds = [pagingScrollView bounds];
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0); // Don't let page index go below zero
    // Don't let the page index go past needed pages
    lastNeededPageIndex = MIN(lastNeededPageIndex, [document numberOfPages] - 1);
    
    // Recycle no longer needed pages
    for (PDFScrollView *page in visiblePages)
    {
        int pageIndex = [page pageNumber] - 1;
        // is the page within needed page range
        if (pageIndex < firstNeededPageIndex || pageIndex > lastNeededPageIndex)
        {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    
    // Remove all recycled pages from the visible pages
    [visiblePages minusSet:recycledPages]; 
             
    // Add missing pages
    for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; i++)
    {
        CGRect frame = [pagingScrollView bounds];
        // if we aren't displaying the page for this index
        if (![self isDisplayingPageForIndex:i])
        {
            // Create and render the page
            frame.origin.x = frame.size.width * i;
            
            PDFScrollView *aView = [self dequeRecycledPage];
            if (aView == nil)
            {
                aView = [[PDFScrollView alloc] initWithFrame:frame andPDFDocument:[document data]];
            }
            
            // Guarentee the page frame is correct
            [aView setFrame:frame];
            
            // Configure page to display a certain pageNumber from PDF
            [aView setPageNumber:(i + 1)];
            
            // Display the page
            [pagingScrollView addSubview:aView];
            [pagingScrollView sendSubviewToBack:aView]; // Set the page to the back
            
            
            // Keep track of this visible page
            [visiblePages addObject:aView];
        }
        
    }
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide our back button
    [backButton setHidden:YES];    
    
    // Add a tap recognizer that will show the button again
    UITapGestureRecognizer *tapRecognizer = 
        [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                action:@selector(handleTap:)];
    [tapRecognizer setDelegate:self];
         
    [[self view] addGestureRecognizer:tapRecognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark Action Methods
- (IBAction)backToLibrary:(UIButton *)sender
{
    // Pop us off the nav stack
    UINavigationController *navController = [self navigationController];
    [navController popViewControllerAnimated:NO];
}

- (IBAction)emailPDF:(UIButton *)sender
{
    // Show the email with this file as an attachment
    NSURL *fileURL = [document fileURL];
    [delegate displayEmailWith:[NSArray arrayWithObject:fileURL]];
}

#pragma mark Gesture Handling Methods
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        
        case UIGestureRecognizerStateEnded:
            
            if ([backButton isHidden] && [emailButton isHidden])
            {
                // Show the button
                [backButton setHidden:NO];
                [emailButton setHidden:NO];
                
                // Keep it not visible 
                [backButton setAlpha:0.0];
                [emailButton setAlpha:0.0];
                
                //Animate it in
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [backButton setAlpha:1.0]; 
                                     [emailButton setAlpha:1.0];
                                 }];
            }
            else // it's visible
            {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [backButton setAlpha:0.0];
                                     [emailButton setAlpha:0.0];
                                 }
                                 completion:^(BOOL finished){
                                     [backButton setHidden:YES];   
                                     [emailButton setHidden:YES];
                                 }];
            }
            
            break;
        default:
            break;
    }
}

#pragma mark UIGestureRecognizer Delegate Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Check if the touch is in bounds of allowable toggleButtonArea
    CGPoint touchPoint = [touch locationInView:pagingScrollView];

    CGRect toggleButtonArea= [pagingScrollView bounds];
    toggleButtonArea.origin.y += UNTOUCHABLE_AREA_HEIGHT;    
    
    if (CGRectContainsPoint(toggleButtonArea, touchPoint))
    {
        return RECOGNIZER_SHOULD_RECIEVE_TOUCH;
    }
    
    return RECOGNIZER_SHOULD_NOT_RECIEVE_TOUCH;
}

#pragma mark UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    // Figure out what is being displayed
    CGRect bounds = [scrollView bounds];
    CGFloat minimumVisibleX = CGRectGetMinX(bounds);
    
    // Move the backButton over enough to appear to not have moved
    CGRect buttonFrame = [backButton frame];
    buttonFrame.origin.x = minimumVisibleX + BACK_BUTTON_X_OFFSET;
    [backButton setFrame:buttonFrame];
    
    // Retile the pages of the PDF
    [self tilePages];    
}

@end
