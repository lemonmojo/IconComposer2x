//
//  LMDocument.h
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMImageView.h"

@interface LMDocument : NSDocument

@property (assign) IBOutlet NSView *contentView;
@property (assign) IBOutlet LMImageView *imageView1024;
@property (assign) IBOutlet LMImageView *imageView512;
@property (assign) IBOutlet LMImageView *imageView256;
@property (assign) IBOutlet LMImageView *imageView128;
@property (assign) IBOutlet LMImageView *imageView64;
@property (assign) IBOutlet LMImageView *imageView32;
@property (assign) IBOutlet LMImageView *imageView16;

@property (retain) NSImage *imageLoad16;
@property (retain) NSImage *imageLoad32;
@property (retain) NSImage *imageLoad64;
@property (retain) NSImage *imageLoad128;
@property (retain) NSImage *imageLoad256;
@property (retain) NSImage *imageLoad512;
@property (retain) NSImage *imageLoad1024;

- (BOOL)loadWithData:(NSData*)data;
- (NSImage*)imageWithSize:(NSSize)size fromImage:(NSImage*)image;
- (NSImageRep*)imageRepWithSize:(NSSize)size fromImage:(NSImage*)image;
- (BOOL)saveToPath:(NSString*)filePath image16:(NSImage*)image16 image32:(NSImage*)image32 image64:(NSImage*)image64 image128:(NSImage*)image128 image256:(NSImage*)image256 image512:(NSImage*)image512 image1024:(NSImage*)image1024 error:(NSError **)outError;
- (void)saveImage:(NSImage*)image toPath:(NSString*)filePath;
- (NSString*)pathForTemporaryFileWithPostfix:(NSString*)postfix;

@end
