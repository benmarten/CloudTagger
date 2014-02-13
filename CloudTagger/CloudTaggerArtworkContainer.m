//
//  CloudTaggerArtworkContainer.m
//  CloudTagger
//
//  Created by Benjamin Marten on 09.02.13.
//  Copyright (c) 2013 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerArtworkContainer.h"
#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerWindowController.h"

@implementation CloudTaggerArtworkContainer
{
    CloudTaggerWindowController *windowController;
}

@synthesize thumbnailUrl = _thumbnailUrl;
@synthesize artworkUrl = _artworkUrl;
@synthesize artwork = _artwork;
@synthesize artworkLoading = _artworkLoading;
@synthesize rowIndex = _rowIndex;

- (id)init
{
    return nil;
}

- (id)initWithThumbnailUrl:(NSURL*)thumbnailUrl andArtworkUrl:(NSURL*)artworkUrl andRowIndex:(long)rowIndex
{
    if (![super init]) return nil;
    
    _thumbnailUrl = thumbnailUrl;
    _artworkUrl = artworkUrl;
    _artwork = nil;
    _artworkLoading = NO;
    _rowIndex = rowIndex;
    
    CloudTaggerAppDelegate *appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    
    windowController = [appDelegate windowController];
    
    return self;
}

- (void)setArtwork:(NSImage*)artwork
{
    _artwork = artwork;
}

- (NSImage*)artwork
{
    if (_artwork == nil)
    {
        _artworkLoading = YES;
        
        [NSThread detachNewThreadSelector:@selector(loadArtworkFromUrl) toTarget:self withObject:nil];
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:@"music" ofType:@"png"];
        
        _artwork = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return _artwork;
}

- (void)loadArtworkFromUrl
{
    NSLog(@"loading image: %@", _artworkUrl);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:_artworkUrl];
    
    if (data != nil)
    {
        _artwork = [[NSImage alloc] initWithData:data];
    }
    else
    {
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:@"na" ofType:@"jpg"];
        
        _artwork = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    _artworkLoading = NO;
    
    [windowController performSelectorOnMainThread:@selector(updateRow:) withObject:[[NSNumber alloc] initWithLong:_rowIndex] waitUntilDone:YES];
}

@end
