//
//  JKAppDelegate.m
//  cocoa-runloop
//
//  Created by jack on 3/11/14.
//  Copyright (c) 2014 jkorp. All rights reserved.
//

#import "JKAppDelegate.h"
#import "RunLoopSource.h"


@interface JKAppDelegate()
@property (nonatomic, strong) NSMutableArray* sourcesToPing;
@property (nonatomic, strong) NSThread* worker;

@end
@implementation JKAppDelegate

void myRunLoopObserver ( CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    CFRunLoopObserverContext context;
    CFRunLoopObserverGetContext(observer, &context);
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    _sourcesToPing = [NSMutableArray array];
    
    _worker = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(workerThread:)
                                       object:self];
    [_worker start];
}

//------------------------------------------------------------------------------
- (IBAction)pingSource:(id)sender {
    if (_sourcesToPing.count) {
        RunLoopContext* sourceCtx = _sourcesToPing[0];
        [sourceCtx.source fireAllCommandsOnRunLoop:sourceCtx.runLoop];
    }
}
- (IBAction)stopSource:(id)sender {
    if (_sourcesToPing.count) {
        RunLoopContext* sourceCtx = _sourcesToPing[0];
        [sourceCtx.source invalidate];
    }
}

//------------------------------------------------------------------------------
- (void)registerSource:(RunLoopContext*)sourceInfo;
{
    [_sourcesToPing addObject:sourceInfo];
}

//------------------------------------------------------------------------------
- (void)removeSource:(RunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
    
    for (RunLoopContext* context in _sourcesToPing)
    {
        if ([context isEqual:sourceInfo])
        {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove)
        [_sourcesToPing removeObject:objToRemove];
}



#pragma mark - Worker Thread
#define kWorkerMode @"WorkerMode"
- (void) workerThread: (id) data
{
    NSLog(@"Enter worker thread");
    // Set up an autorelease pool here if not using garbage collection.
    BOOL done = NO;
    
    // Add your sources or timers to the run loop and do any other setup.
     RunLoopSource* customRunLoopSource = [[RunLoopSource alloc] init];
    [customRunLoopSource addToCurrentRunLoop];
    
    do
    {
        // Start the run loop but return after each source is handled.
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, YES);
        
        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, or our runloopSource is invalid ->
        // go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished) || !customRunLoopSource.isValidate)
            done = YES;
    }
    while (!done);
    
    // Clean up code here. Be sure to release any allocated autorelease pools.
    NSLog(@"Exit worker thread");
}
@end
