//
//  LMImageView.m
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMImageView.h"

@implementation LMImageView

@synthesize undoManager;

- (void)dealloc {
    if (undoManager) {
        [undoManager release];
        undoManager = nil;
    }
    
    [super dealloc];
}

- (void)setImage:(NSImage *)newImage {
    [super setImage:newImage];
    
    if (_image != self.image) {
        [[undoManager prepareWithInvocationTarget:self] setImage:_image];
        
        [_image release];
        _image = [self.image retain];
    }
}

@end
