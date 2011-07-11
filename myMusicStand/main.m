//
//  main.m
//  myMusicStand
//
//  Created by Steve Solomon on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef FRANK
#include "FrankServer.h"
static FrankServer *sFrankServer;
#endif

int main(int argc, char *argv[])
{
    int retVal;
    @autoreleasepool {
#ifdef FRANK
        sFrankServer = [[FrankServer alloc] initWithDefaultBundle];
        [sFrankServer startServer];
#endif
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    return retVal;
}
