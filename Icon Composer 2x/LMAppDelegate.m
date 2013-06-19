//
//  LMAppDelegate.m
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMAppDelegate.h"

@implementation LMAppDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    if (_reOpen) {
        _reOpen = NO;
        return YES;
    }
    
    return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    _reOpen = YES;
    
    return YES;
}

@end
