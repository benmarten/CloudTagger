//
//  CloudTaggerTrackCellView.m
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerTrackCellView.h"
#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerWindowController.h"

@implementation CloudTaggerTrackCellView
{
    CloudTaggerAppDelegate *appDelegate;
    
    CloudTaggerWindowController *windowController;
}

@synthesize rowIndex = _rowIndex;
@synthesize status = _status;


- (id)initWithCoder:(NSCoder*) coder
{
    if (![super initWithCoder:coder]) return nil;
    
    appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    
    windowController = [appDelegate windowController];
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)animationDidStop:(NSAnimation*)animation
{
    [self.thenView setHidden:YES];
}

- (IBAction)metadataCheckBoxClicked:(NSButton*)sender
{
    if (sender.state == 0)
    {
        [windowController deselectTrack:self.rowIndex];
    }
    else
    {
        [windowController selectTrack:self.rowIndex];
    }
}

- (IBAction)metadataStepperClicked:(NSStepper*)sender
{
    NSLog(@"selected machted track index: %i",sender.intValue);

    NSArray *store = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithLong:self.rowIndex], [[NSNumber alloc] initWithInt:sender.intValue ], nil];
    
    [windowController performSelectorOnMainThread:@selector(setSelectedMatchedTrack:) withObject:store waitUntilDone:YES];
}

- (IBAction)artworkCheckBoxClicked:(NSButton*)sender
{
    if (sender.state == 0)
    {
        [windowController deselectArtwork:self.rowIndex];
    }
    else
    {
        [windowController selectArtwork:self.rowIndex];
    }
}

- (IBAction)artworkStepperClicked:(NSStepper*)sender
{   
    NSArray *store = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithLong:self.rowIndex], [[NSNumber alloc] initWithInt:sender.intValue ], nil];
        
    [windowController performSelectorOnMainThread:@selector(setSelectedArtworkFor:) withObject:store waitUntilDone:YES];
    
    NSLog(@"selected artwork track index: %i",sender.intValue);
}

- (IBAction)enlargeArtworkButtonClicked:(NSButton*)sender
{
    [windowController showArtworkPreviewHUD:self.albumartThen.image];
}

@end
