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
    // Get the first page in the document
    CGPDFPageRef firstPage = CGPDFDocumentGetPage([document data], 1);
    
    // Display the page in the pdfView
    [pdfView setPDFPage:firstPage];
    [pdfView setNeedsDisplay];
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
    pdfView = [[PDFScrollView alloc] initWithFrame:pdfViewFrame];
    
    // Add the pdfView as a subview of our main view
    [[self view] addSubview:pdfView];
    [pdfView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
