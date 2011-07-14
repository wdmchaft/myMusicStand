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

@interface PDFDocumentViewController ()
#pragma mark Private Methods
// Helper method used as a callback to display the pdf once loaded
- (void)documentStateHasBeenUpdated;
@end

@implementation PDFDocumentViewController
{
    // The document we will display
    PDFDocument *document;
    UIImageView *imageView;
    UIButton *backButton;
    UIScrollView *pagingScrollView; // same as view
}

@synthesize document;

- (id)initWithURL:(NSURL *)url
{
    if (!url)
    {
        @throw @"Param url must not be nil";
    }
    
    self = [super initWithNibName:nil bundle:nil];
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
- (void)loadView
{
    // Size of pagingScrollView
    CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
    // cause 10px gap on each side of subview
    pagingScrollViewFrame.origin.x -= PDF_PAGE_SPACE;
    pagingScrollViewFrame.size.width += DOUBLE_PAGE_SPACE;
    
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    
    [pagingScrollView setPagingEnabled:YES];
    [pagingScrollView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self setView:pagingScrollView]; 

    // Display the button
    [pagingScrollView addSubview:backButton];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark UIScrollViewDelegate Methods

@end
