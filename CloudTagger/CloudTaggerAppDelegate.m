//
//  CloudTaggerAppDelegate.m
//  CloudTagger
//
//  Created by Benjamin Marten on 30.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerAppDelegate.h"

@implementation CloudTaggerAppDelegate

@synthesize windowController = _windowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{        
    self.windowController = [[CloudTaggerWindowController alloc] initWithWindowNibName:@"CloudTaggerWindow"];
    
    [self.windowController showWindow:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag
{
    if (flag)
    {
        return NO;
    } else
    {
        [self.windowController loadSelectedTracksButtonClicked:nil];
        [self.windowController showWindow:self];
        return YES;
    }	
}

- (IBAction)setTrackMetadataToSingle:(id)sender {
    [self.windowController setTrackMetadataToSingle];
}
@end
