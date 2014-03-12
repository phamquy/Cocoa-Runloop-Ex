//
//  RunLoopSource.m
//  cocoa-runloop
//
//  Created by jack on 3/12/14.
//  Copyright (c) 2014 jkorp. All rights reserved.
//

#import "RunLoopSource.h"
#import "JKAppDelegate.h"
//------------------------------------------------------------------------------
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"Register source!");
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    JKAppDelegate*   del = [[NSApplication sharedApplication] delegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}


//------------------------------------------------------------------------------
void RunLoopSourcePerformRoutine (void *info)
{
    NSLog(@"Perform source routine");
    RunLoopSource*  obj = (__bridge RunLoopSource*)info;
    [obj sourceFired];
}


//------------------------------------------------------------------------------
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"Cancel Source");
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    JKAppDelegate* del = [[NSApplication sharedApplication] delegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface RunLoopSource ()
@property (nonatomic) BOOL validate;
@end

@implementation RunLoopSource
- (id)init
{
    self = [super init];
    if (self) {
        CFRunLoopSourceContext    context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &RunLoopSourceScheduleRoutine,
            RunLoopSourceCancelRoutine,
            RunLoopSourcePerformRoutine};
        
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        commands = [[NSMutableArray alloc] init];
    }
    return self;
}

//------------------------------------------------------------------------------
- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
    _validate = YES;
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

- (void) sourceFired
{
    NSLog(@"Source fired handler called");
}

- (void)addCommand:(NSInteger)command withData:(id)data
{

}

- (void) invalidate
{
    @synchronized(self)
    {
        _validate = NO;
    }
}

- (BOOL) isValidate
{
    @synchronized(self)
    {
        return _validate;
    }
}
@end


@implementation RunLoopContext
- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop
{
    self = [super init];
    if (self) {
        _runLoop =  loop;
        _source = src;
        
    }
    return self;
}

@end