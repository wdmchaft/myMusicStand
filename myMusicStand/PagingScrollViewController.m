//
//  PagingScrollViewController.m
//  PDFPrototyping
//
//  Created by Steve Solomon on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PagingScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PagingScrollViewController

@synthesize dataSource, pagingScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    return [self init];
}

- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
    if (self) 
	{
		reusablePages = [[NSMutableSet alloc] init];
		visiblePages = [[NSMutableSet alloc] init];
    }
    return self;

}

- (void)enqueueReusablePage:(UIView *)page
{
	[reusablePages addObject:page];
}

- (UIView *)dequeueReusablePage
{
	// Get any reusable page object
	UIView *page = [reusablePages anyObject];
	// If we have one hold onto it for now and remove it from the set
    if (page) {
        [[page retain] autorelease];
        [reusablePages removeObject:page];
    }
	return page;
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	// For now we have a scrollview the size of the screen
	pagingScrollView = 
		[[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
	
	// We assume we have a datasource to work. If we don't have one we will crash
	numberOfPages = [dataSource numberOfPagesInPagingScrollView];
	
	// Set content size so we know how to page 
	pagingScrollView.contentSize = CGSizeMake(pagingScrollView.frame.size.width * numberOfPages,
											  pagingScrollView.frame.size.height);
	
	// Enable paging 
	[pagingScrollView setPagingEnabled:YES];
	
	// Show our paging view 
	[self setView:pagingScrollView];
	
	// Make background gray
	[pagingScrollView setBackgroundColor:[UIColor clearColor]];
	
	// We need to be the scrollview delegate so we know when it is scrolled
	[pagingScrollView setDelegate:self];
	
	// We are all setup so lets load the pages
	[self tilePages];

}

// Only redraw subviews when we are done will the scroll animation
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	//[self performSelectorInBackground:@selector(tilePages) withObject:nil];
	[self tilePages];
}


#define PADDING 0
- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    return pageFrame;
}

- (CGRect)frameForPagingScrollView {
    CGRect frame = CGRectMake(0, 0, 768, 1004);
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

// Returns the reusable page at the specified frame
- (UIView *)getPageForFrame:(CGRect)frame 
{
	// Predicate to grab page with the same rect
	NSPredicate *predicate = 
		[NSPredicate predicateWithFormat:@"self.frame == %@" 
						   argumentArray:[NSArray arrayWithObject:
										  [NSValue valueWithCGRect:frame]]];
	
	// Get filtered set using predicate 
	NSSet *filteredSet = [visiblePages filteredSetUsingPredicate:predicate];
	
	if ([filteredSet count] > 1)
	{
		return nil; // for some reason we have overlap
	}
	
	// return any object we have recieved 
	return [filteredSet anyObject];
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIView *page in visiblePages) {
        
        if ([page respondsToSelector:@selector(index)])
        {
            if ([(NSNumber *)[page valueForKey:@"index"] intValue] == index) {
                foundPage = YES;
                break;
            }
        }
        else 
        {
            [NSException raise:@"UIView subclass doesn't respond to 'index'" 
                        format:@"UIView instance: %@", page];
        }
    }
    return foundPage;
}

- (void)tilePages 
{
	// Because we are doing work in this background thread we are 
	// responsible for creating our own autorelease pool
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@try {
		
		// Calculate which pages are visible
		CGRect visibleBounds = [pagingScrollView bounds];
		int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
		int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));

		// Get one more page then needed in each direction
		firstNeededPageIndex--;
		lastNeededPageIndex++;
		
		// Make sure we don't walk off either end 
		firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
		lastNeededPageIndex  = MIN(lastNeededPageIndex, numberOfPages - 1);
		
		// Recycle no-longer-visible pages 
		for (UIView *page in visiblePages) {
            if ([page respondsToSelector:@selector(index)])
            {
                int index = [(NSNumber *)[page valueForKey:@"index"] intValue];
                if (index < firstNeededPageIndex || index > lastNeededPageIndex) {
                    @try {
                    [reusablePages addObject:page];
                    [page removeFromSuperview];
                    }
                    @catch (NSException *ex) {
                        //NSLog(@"");
                    }
                
                }
            }
            else 
            {
                [NSException raise:@"UIView subclass doesn't respond to 'index'" 
                            format:@"UIView instance: %@", page];
            }
		}
		
		[visiblePages minusSet:reusablePages];
		
		// add missing pages
		for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
			if (![self isDisplayingPageForIndex:index]) {
				
				[self setupPageForIndex:index];
				
			}
		}   
		
	}
	@catch (NSException *ex) {
		NSLog(@"Error in TilePages: %@", [ex reason]);
		
	}
	
	//[pool drain];
}

- (void)setupPageForIndex:(NSUInteger)index
{
	// Ask datasource for a page to display for this index
	UIView *page = [dataSource pagingScrollView:pagingScrollView
                                   pageForIndex:index];
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES]
					 forKey:kCATransactionDisableActions];
	// Modify the views frame so it is place correctly
	[page setFrame:[self frameForPageAtIndex:index]];
	[CATransaction commit];
	// Set the page's index
    if ([page respondsToSelector:@selector(setIndex:)])
    {
        [page setValue:[NSNumber numberWithInt:index] forKeyPath:@"index"];
    }
    else 
    {
        [NSException raise:@"UIView subclass doesn't respond to 'setIndex:'" 
                    format:@"UIView instance: %@", page];
    }

	// redraw this view to reflect any changes
	[page setNeedsDisplay];
	[pagingScrollView addSubview:page];
	[visiblePages addObject:page];
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[reusablePages release];
	[visiblePages release];
	//[pagingScrollView release];
    [super dealloc];
}


@end
