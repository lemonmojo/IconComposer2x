//
//  LMDocument.m
//  Icon Composer 2x
//
//  Created by Felix Deimel on 19.06.13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocument.h"

NSErrorDomain const LMLemonMojoErrorDomain = @"LMLemonMojoErrorDomain";

@implementation LMDocument

@synthesize
contentView,
imageView16,
imageView32,
imageView64,
imageView128,
imageView256,
imageView512,
imageView1024,
imageLoad16,
imageLoad32,
imageLoad64,
imageLoad128,
imageLoad256,
imageLoad512,
imageLoad1024
;

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
    
    imageView16.image = self.imageLoad16;
    imageView32.image = self.imageLoad32;
    imageView64.image = self.imageLoad64;
    imageView128.image = self.imageLoad128;
    imageView256.image = self.imageLoad256;
    imageView512.image = self.imageLoad512;
    imageView1024.image = self.imageLoad1024;
    
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
    return [self saveToPath:[absoluteURL path]
                    image16:[imageView16 image]
                    image32:[imageView32 image]
                    image64:[imageView64 image]
                   image128:[imageView128 image]
                   image256:[imageView256 image]
                   image512:[imageView512 image]
                  image1024:[imageView1024 image]
                      error:outError];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    return [self loadWithData:data];
}

- (BOOL)loadWithData:(NSData*)data {
    NSImage *img = [[[NSImage alloc] initWithData:data] autorelease];
    
    if (!img)
        return NO;
    
    self.imageLoad16 = [self imageWithSize:NSMakeSize(16, 16) fromImage:img];
    self.imageLoad32 = [self imageWithSize:NSMakeSize(32, 32) fromImage:img];
    self.imageLoad64 = [self imageWithSize:NSMakeSize(64, 64) fromImage:img];
    self.imageLoad128 = [self imageWithSize:NSMakeSize(128, 128) fromImage:img];
    self.imageLoad256 = [self imageWithSize:NSMakeSize(256, 256) fromImage:img];
    self.imageLoad512 = [self imageWithSize:NSMakeSize(512, 512) fromImage:img];
    self.imageLoad1024 = [self imageWithSize:NSMakeSize(1024, 1024) fromImage:img];
    
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


- (BOOL)saveToPath:(NSString*)filePath image16:(NSImage*)image16 image32:(NSImage*)image32 image64:(NSImage*)image64 image128:(NSImage*)image128 image256:(NSImage*)image256 image512:(NSImage*)image512 image1024:(NSImage*)image1024 error:(NSError **)outError {
    *outError = nil;
    
    NSString* tempPath = [self pathForTemporaryFileWithPostfix:@"IconComposer2x.iconset"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    BOOL image1024Saved = NO;
    BOOL image512Saved = NO;
    BOOL image256Saved = NO;
    BOOL image128Saved = NO;
    BOOL image64Saved = NO;
    BOOL image32Saved = NO;
    BOOL image16Saved = NO;
    
    if (image1024 &&
        image1024.isValid) {
        [self saveImage:image1024 toPath:[NSString stringWithFormat:@"%@/icon_512x512@2x.png", tempPath]];
        image1024Saved = YES;
    }
    
    if (image512 &&
        image512.isValid) {
        [self saveImage:image512 toPath:[NSString stringWithFormat:@"%@/icon_512x512.png", tempPath]];
        [self saveImage:image512 toPath:[NSString stringWithFormat:@"%@/icon_256x256@2x.png", tempPath]];
        image512Saved = YES;
    }
    
    if (image256 &&
        image256.isValid) {
        [self saveImage:image256 toPath:[NSString stringWithFormat:@"%@/icon_256x256.png", tempPath]];
        [self saveImage:image256 toPath:[NSString stringWithFormat:@"%@/icon_128x128@2x.png", tempPath]];
        image256Saved = YES;
    }
    
    if (image128 &&
        image128.isValid) {
        [self saveImage:image128 toPath:[NSString stringWithFormat:@"%@/icon_128x128.png", tempPath]];
        image128Saved = YES;
    }
    
    if (image64 &&
        image64.isValid) {
        [self saveImage:image64 toPath:[NSString stringWithFormat:@"%@/icon_32x32@2x.png", tempPath]];
        image64Saved = YES;
    }
    
    if (image32 &&
        image32.isValid) {
        [self saveImage:image32 toPath:[NSString stringWithFormat:@"%@/icon_32x32.png", tempPath]];
        [self saveImage:image32 toPath:[NSString stringWithFormat:@"%@/icon_16x16@2x.png", tempPath]];
        image32Saved = YES;
    }
    
    if (image16 &&
        image16.isValid) {
        [self saveImage:image16 toPath:[NSString stringWithFormat:@"%@/icon_16x16.png", tempPath]];
        image16Saved = YES;
    }
    
    NSArray<NSString*>* filesInTempPath = [fileManager contentsOfDirectoryAtPath:tempPath error:nil];
    
    if (!filesInTempPath ||
        filesInTempPath.count <= 0) {
        NSMutableString* unsavedImages = [NSMutableString string];
        
        if (!image1024Saved) {
            [unsavedImages appendString:@"1024x1024, "];
        }
        
        if (!image512Saved) {
            [unsavedImages appendString:@"512x512, "];
        }
        
        if (!image256Saved) {
            [unsavedImages appendString:@"256x256, "];
        }
        
        if (!image128Saved) {
            [unsavedImages appendString:@"128x128, "];
        }
        
        if (!image64Saved) {
            [unsavedImages appendString:@"64x64, "];
        }
        
        if (!image32Saved) {
            [unsavedImages appendString:@"32x32, "];
        }
        
        if (!image16Saved) {
            [unsavedImages appendString:@"16x16, "];
        }
        
        if ([unsavedImages hasSuffix:@", "]) {
            [unsavedImages deleteCharactersInRange:NSMakeRange(unsavedImages.length - 2, 2)];
        }
        
        NSString* msg = [NSString stringWithFormat:@"The following icon sizes failed to be saved or are invalid: %@", unsavedImages];
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: msg,
                                    NSLocalizedFailureReasonErrorKey: msg
                                    };
        *outError = [NSError errorWithDomain:LMLemonMojoErrorDomain
                                        code:1
                                    userInfo:userInfo];
        
        if (filesInTempPath) {
            // Clean up if the root directory exists but has no contents
            [fileManager removeItemAtPath:tempPath error:nil];
        }
        
        return NO;
    }
    
    NSTask* task = [[NSTask alloc] init];
    
    [task setLaunchPath:@"/usr/bin/iconutil"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", @"icns", @"-o", filePath, tempPath, nil]];
    
    NSPipe* pipeStdErr = [NSPipe pipe];
    [task setStandardError:pipeStdErr];
    
    [task launch];
    [task waitUntilExit];
    
    [task autorelease];
    
    [fileManager removeItemAtPath:tempPath error:nil];
    
    if (task.terminationStatus != 0) {
        NSData* dataStdErr = [pipeStdErr.fileHandleForReading readDataToEndOfFile];
        NSString* strStdErr = [[[NSString alloc] initWithData:dataStdErr encoding:NSUTF8StringEncoding] autorelease];
        
        NSString* msg = [NSString stringWithFormat:@"iconutil returned the following error: %@", strStdErr];
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: msg,
                                    NSLocalizedFailureReasonErrorKey: msg
                                    };
        *outError = [NSError errorWithDomain:LMLemonMojoErrorDomain
                                        code:1
                                    userInfo:userInfo];
        
        return NO;
    }
    
    return YES;
}

- (void)saveImage:(NSImage*)image toPath:(NSString*)filePath {
    NSImageRep *imgRep = [[image representations] objectAtIndex:0];
    
    if ([imgRep isKindOfClass:[NSBitmapImageRep class]]) {
        NSBitmapImageRep *bmpRep = (NSBitmapImageRep*)imgRep;
        NSData *data = [bmpRep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
        [data writeToFile:filePath atomically:NO];
    }
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
