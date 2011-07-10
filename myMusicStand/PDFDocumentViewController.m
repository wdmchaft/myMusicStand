//
//  PDFDocumentViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFDocumentViewController.h"
#import "PDFScrollView.h"
#import "PDFDocument.h"
#import "PDFHelpers.h"

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

- (void)dealloc
{
    [document release];
    [super dealloc];
}

#pragma mark - Helper methods
- (void)documentStateHasBeenUpdated
{
    // Get bounds in which to draw the image
    CGRect bounds = [[self view] bounds];
    
    // Get the first page in the document    
    UIImage *image = imageForPDFDocumentInSize([document data], bounds.size.width, bounds.size.height);
    imageView = [[UIImageView alloc] initWithImage:image];
    [[self view] addSubview:imageView];
    
    // center the imageView
    [imageView setCenter:[[self view] center]];

}

#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    
    // open the file
    [document openWithCompletionHandler:^(BOOL fileIsOpen){
        [self documentStateHasBeenUpdated];
    }];
    
    // Create the pdfView to display
    CGRect pdfViewFrame = [[self view] bounds];
    pdfView = [[UIView alloc] initWithFrame:pdfViewFrame];
    
    // Adjust visual attributes on pdfView
    [pdfView setBackgroundColor:[UIColor greenColor]];
    
    // Add the pdfView as a subview of our main view
    [[self view] addSubview:pdfView];
    [pdfView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Render larger image
    CGRect bounds = [[self view] bounds];
    bounds.size.width *= 2;
    UIImage *largeImage = imageForPDFDocumentInSize((CGPDFDocumentRef)[document data], bounds.size.height, bounds.size.width);
    
    // Toss old image
    [imageView removeFromSuperview];
    [imageView release];
    
    // Display new image
    imageView = [[UIImageView alloc] initWithImage:largeImage];
    CGPoint center = [imageView center];
    center.x = (bounds.size.height + 22) / 2;
    [imageView setCenter:center];
    [[self view] addSubview:imageView];
    [[self view] setNeedsDisplay];
    
}
@end
