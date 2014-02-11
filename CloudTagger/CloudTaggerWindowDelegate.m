//
//  CloudTaggerWindowDelegate.m
//  CloudTagger
//
//  Created by Benjamin Marten on 30.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerWindowDelegate.h"

@implementation CloudTaggerWindowDelegate

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [self.windowController loadSelectedTracksIfNoneLoaded];
}

@end
