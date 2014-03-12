//
//  JKAppDelegate.h
//  cocoa-runloop
//
//  Created by jack on 3/11/14.
//  Copyright (c) 2014 jkorp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (void) registerSource: (id) context;
- (void) removeSource:(id) context;
@end
