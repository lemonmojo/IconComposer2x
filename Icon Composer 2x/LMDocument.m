//
//  LMDocument.m
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocument.h"

@implementation LMDocument

@synthesize
contentView,
imageView16,
imageView32,
imageView64,
imageView128,
imageView256,
imageView512,
imageView1024;

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (NSString *)windowNibName {
    return @"LMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];

    NSScrollView *scrollView = [[[NSScrollView alloc] initWithFrame:[self.contentView frame]] autorelease];
    
    [scrollView setBorderType:NSNoBorder];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutohidesScrollers:YES];
    [scrollView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable |
     NSViewMinYMargin | NSViewMaxYMargin | NSViewHeightSizable];
    
    NSView *clipView = [[[NSView alloc] initWithFrame:scrollView.frame] autorelease];
    
    NSArray *views = [[self.contentView.subviews copy] autorelease];
    
    for (NSView *view in views) {
        [view removeFromSuperview];
        [clipView addSubview:view];
    }
    
    [scrollView setDocumentView:clipView];
    
    [self.contentView addSubview:scrollView];
    
    imageView16.image = imageLoad16;
    imageView32.image = imageLoad32;
    imageView64.image = imageLoad64;
    imageView128.image = imageLoad128;
    imageView256.image = imageLoad256;
    imageView512.image = imageLoad512;
    imageView1024.image = imageLoad1024;
    
    imageView16.undoManager = self.undoManager;
    imageView32.undoManager = self.undoManager;
    imageView64.undoManager = self.undoManager;
    imageView128.undoManager = self.undoManager;
    imageView256.undoManager = self.undoManager;
    imageView512.undoManager = self.undoManager;
    imageView1024.undoManager = self.undoManager;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

- (BOOL)hasUndoManager {
    return YES;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
    [self saveToPath:[absoluteURL path] image16:[imageView16 image] image32:[imageView32 image] image64:[imageView64 image] image128:[imageView128 image] image256:[imageView256 image] image512:[imageView512 image] image1024:[imageView1024 image]];
    
    return YES;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    return [self loadWithData:data];
}

- (BOOL)loadWithData:(NSData*)data {
    NSImage *img = [[[NSImage alloc] initWithData:data] autorelease];
    
    if (!img)
        return NO;
    
    imageLoad16 = [self imageWithSize:NSMakeSize(16, 16) fromImage:img];
    imageLoad32 = [self imageWithSize:NSMakeSize(32, 32) fromImage:img];
    imageLoad64 = [self imageWithSize:NSMakeSize(64, 64) fromImage:img];
    imageLoad128 = [self imageWithSize:NSMakeSize(128, 128) fromImage:img];
    imageLoad256 = [self imageWithSize:NSMakeSize(256, 256) fromImage:img];
    imageLoad512 = [self imageWithSize:NSMakeSize(512, 512) fromImage:img];
    imageLoad1024 = [self imageWithSize:NSMakeSize(1024, 1024) fromImage:img];
    
    return YES;
}

- (NSImage*)imageWithSize:(NSSize)size fromImage:(NSImage*)image {
    NSImage *img;
    
    NSImageRep *rep = [self imageRepWithSize:size fromImage:image];
    
    img = [[[NSImage alloc] initWithSize:size] autorelease];
    [img addRepresentation:rep];
    
    return img;
}

- (NSImageRep*)imageRepWithSize:(NSSize)size fromImage:(NSImage*)image {
    for (NSImageRep *rep in [image representations]) {
        if (rep.pixelsWide == size.width &&
            rep.pixelsHigh == size.height) {
            return rep;
        }
    }
    
    return nil;
}


- (void)saveToPath:(NSString*)filePath image16:(NSImage*)image16 image32:(NSImage*)image32 image64:(NSImage*)image64 image128:(NSImage*)image128 image256:(NSImage*)image256 image512:(NSImage*)image512 image1024:(NSImage*)image1024 {
    NSString* tempPath = [self pathForTemporaryFileWithPostfix:@"IconComposer2x.iconset"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    [self saveImage:image1024 toPath:[NSString stringWithFormat:@"%@/icon_512x512@2x.png", tempPath]];
    
    [self saveImage:image512 toPath:[NSString stringWithFormat:@"%@/icon_512x512.png", tempPath]];
    [self saveImage:image512 toPath:[NSString stringWithFormat:@"%@/icon_256x256@2x.png", tempPath]];
    
    [self saveImage:image256 toPath:[NSString stringWithFormat:@"%@/icon_256x256.png", tempPath]];
    [self saveImage:image256 toPath:[NSString stringWithFormat:@"%@/icon_128x128@2x.png", tempPath]];
    
    [self saveImage:image128 toPath:[NSString stringWithFormat:@"%@/icon_128x128.png", tempPath]];
    
    [self saveImage:image64 toPath:[NSString stringWithFormat:@"%@/icon_32x32@2x.png", tempPath]];
    
    [self saveImage:image32 toPath:[NSString stringWithFormat:@"%@/icon_32x32.png", tempPath]];
    [self saveImage:image32 toPath:[NSString stringWithFormat:@"%@/icon_16x16@2x.png", tempPath]];
    
    [self saveImage:image32 toPath:[NSString stringWithFormat:@"%@/icon_16x16.png", tempPath]];
    
    NSTask* task = [[NSTask alloc] init];
    
    [task setLaunchPath:@"/usr/bin/iconutil"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", @"icns", @"-o", filePath, tempPath, nil]];
    
    [task launch];
    [task waitUntilExit];
    [task release];
    
    [fileManager removeItemAtPath:tempPath error:nil];
}

- (void)saveImage:(NSImage*)image toPath:(NSString*)filePath {
    NSBitmapImageRep *imgRep = [[image representations] objectAtIndex:0];
    NSData *data = [imgRep representationUsingType: NSPNGFileType properties:nil];
    [data writeToFile:filePath atomically:NO];
}

- (NSString*)pathForTemporaryFileWithPostfix:(NSString*)postfix {
    NSString* result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", uuidStr, postfix]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end
