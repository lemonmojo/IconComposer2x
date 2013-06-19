//
//  LMImageView.h
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMImageView : NSImageView<NSDraggingDestination> {
    NSUndoManager *undoManager;
    NSImage *_image;
}

@property (nonatomic, retain) NSUndoManager *undoManager;

@end
