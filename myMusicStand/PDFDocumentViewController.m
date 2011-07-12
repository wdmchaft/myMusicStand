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
#import "PDFView.h"

@implementation PDFDocumentViewController

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
    // Get bounds in which to draw the image
    CGRect bounds = [[self view] bounds];
    
    pdfView = [[PDFView alloc] initWithFrame:bounds andPDFDocument:[document data]];
    [scrollView addSubview:pdfView];
    
    // Get bounds in which to draw the image
    bounds.origin.x += bounds.size.width;  

    pdfView2 = [[PDFView alloc] initWithFrame:bounds andPDFDocument:[document data]];
    [[self view] addSubview:pdfView2];
        
    // center the imageView
    [imageView setCenter:[[self view] center]];
    
    // Make sure the scrollView can display all the pages of the pdf
    CGSize size = [scrollView frame].size;
    size.width *= [document numberOfPages];
    [scrollView setContentSize:size];
    
    // We only want to scroll in one axis at a time
    [scrollView setDirectionalLockEnabled:YES];

}

#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    
    // Create our view
    CGRect frame = [[self view] frame];
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [scrollView setPagingEnabled:YES];
    [scrollView setBackgroundColor:[UIColor lightGrayColor]];
    [self setView:scrollView];
    
    // Allow us to handle scrollevents
    [scrollView setDelegate:self];
    
    // open the file
    [document openWithCompletionHandler:^(BOOL fileIsOpen){
        [self documentStateHasBeenUpdated];
    }];
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect bounds = [[self view] bounds];
    
    // if we now in a landscape orientation
    if (UIInterfaceOrientationIsLandscape([self interfaceOrientation]))
    {
        bounds.size.height *= 2;     
    }
    
    UIImage *image = imageForPDFDocumentInSize([document data], bounds.size.width, bounds.size.height);        
    
    // Allow scrolling only when image needs it
    CGSize contentSize = image.size;
    contentSize.width *= [document numberOfPages];
    [scrollView setContentSize:contentSize];
    
    // Toss old image
    [imageView removeFromSuperview];
    
    // Display new image
    imageView = [[UIImageView alloc] initWithImage:image];
    
    // Center the imageView
    CGPoint center = [imageView center];
    center.x = bounds.size.width / 2;
    [imageView setCenter:center];
    
    [[self view] addSubview:imageView];
    [[self view] setNeedsDisplay];

}

#pragma mark UIScrollViewDelegate Methods

@end
