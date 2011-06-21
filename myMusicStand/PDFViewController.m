//
//  PDFViewController.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFViewController.h"

@implementation PDFViewController

- (id)initWithURL:(NSURL *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        document = CGPDFDocumentCreateWithURL((CFURLRef)url);
        documentURL = [url retain];
        pages = [[NSMutableArray alloc] init];
             
        [self addImageForPageNumber:1];
        [self addImageForPageNumber:2];
        [self addImageForPageNumber:3];
        
    }
    return self;
}

- (void)dealloc
{
    CGPDFDocumentRelease(document);
    [documentURL release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw @"Illegal instance use initWithURL:";
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release and recreate document so cache is cleared
    CGPDFDocumentRelease(document);
    document = CGPDFDocumentCreateWithURL((CFURLRef)documentURL);
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a scrollView for pages
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [scrollView setPagingEnabled:YES];
    
    // Make the contentSize room enough for each page
    CGSize size = [[self view] bounds].size;
    size.width *= CGPDFDocumentGetNumberOfPages(document);
    [scrollView setContentSize:size];
    
    // Add scrollView to view
    [[self view] addSubview:scrollView];
    
    // Add pdf page to view
    UIImage *imageForPage = [pages objectAtIndex:0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageForPage];
    
    // Add page to view
    [scrollView addSubview:imageView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)addImageForPageNumber:(NSUInteger)number
{   
    
    // render page 
    CGPDFPageRef page = CGPDFDocumentGetPage(document, number);
    
    // determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGFloat pdfScale = 768 /pageRect.size.width;
    pageRect.size = CGSizeMake(768 * pdfScale, 1002 * pdfScale);
    
    UIGraphicsBeginImageContext(CGSizeMake(768, 1002));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // First fill the background with white.
	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, CGRectMake(0, 0, 768, 1002));
	
	CGContextSaveGState(context);
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(context, 0.0, 1002);
	
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
	CGContextScaleCTM(context, pdfScale, pdfScale);	
	CGContextDrawPDFPage(context, page);
	CGContextRestoreGState(context);

    CGContextDrawPDFPage(context, page);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // add image rendered to pages
    [pages addObject:image];
    
}

- (UIImage *)imageForPageNumber:(NSUInteger)number
{
    return [[UIImage alloc] init];
}
@end
