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

#define PDF_PAGE_SPACE 10
#define DOUBLE_PAGE_SPACE (2 * PDF_PAGE_SPACE)
#define RECOGNIZER_SHOULD_RECIEVE_TOUCH YES
#define RECOGNIZER_SHOULD_NOT_RECIEVE_TOUCH NO
#define UNTOUCHABLE_AREA_HEIGHT 60
#define BACK_BUTTON_X_OFFSET 20

@interface PDFDocumentViewController ()
#pragma mark Private Methods
// Helper method used as a callback to display the pdf once loaded
- (void)documentStateHasBeenUpdated;
- (IBAction)backToLibrary:(UIButton *)sender;
- (void)handleTap:(UIGestureRecognizer *)recognizer;
@end

@implementation PDFDocumentViewController
{
#pragma mark Instance Variables
    // The document we will display
    PDFDocument *document;
    IBOutlet UIButton *backButton;
    IBOutlet UIScrollView *pagingScrollView; // same as view
}

@synthesize document;

#pragma mark Initializers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)url
{
    if (!url)
    {
        @throw @"Param url must not be nil";
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    // Once the document has opened display it's pages
    for (int i = 0; i < [document numberOfPages]; i++)
    {
        frame.origin.x = frame.size.width * i;
        PDFScrollView *aView = [[PDFScrollView alloc] initWithFrame:frame andPDFDocument:[document data]];
        [aView setPageNumber:(i + 1)];
        [pagingScrollView addSubview:aView];
    }
    
    // Bring the button to the front
    [pagingScrollView bringSubviewToFront:backButton];

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

#pragma mark Gesture Handling Methods
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    switch ([recognizer state]) {
        
        case UIGestureRecognizerStateEnded:
            
            if ([backButton isHidden])
            {
                // Show the button
                [backButton setHidden:NO];
                
                // Keep it not visible 
                [backButton setAlpha:0.0];
                
                //Animate it in
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [backButton setAlpha:1.0]; 
                                 }];
            }
            else // it's visible
            {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [backButton setAlpha:0.0];
                                 }
                                 completion:^(BOOL finished){
                                     [backButton setHidden:YES];                                     
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
    
}
@end
