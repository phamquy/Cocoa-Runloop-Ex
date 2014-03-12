//
//  RunLoopSource.h
//  cocoa-runloop
//
//  Created by jack on 3/12/14.
//  Copyright (c) 2014 jkorp. All rights reserved.
//

#import <Foundation/Foundation.h>

// These are the CFRunLoopSourceRef callback functions.
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);

//------------------------------------------------------------------------------
@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray* commands;
}

- (id) init;
- (void) addToCurrentRunLoop;
- (void) invalidate;
- (BOOL) isValidate;

// Handler method
- (void) sourceFired;


// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
@end


//------------------------------------------------------------------------------
// RunLoopContext is a container object used during registration of the input source.
@interface RunLoopContext : NSObject

@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RunLoopSource* source;

- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop;
@end