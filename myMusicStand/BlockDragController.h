//
//  BlockDragController.h
//  myMusicStand
//
//  Manages the dragging of a block by creating a dragView to 
//  allow the user to move blocks onto the music stand
//
//  Created by Steven Solomon on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StageViewController;
@interface BlockDragController : NSObject

// Designated initializer
- (id)initWithStageViewController:(StageViewController *)aDelegate;

// returns method that should be used to handle drag events
- (SEL)dragEvenHandler;

@end
