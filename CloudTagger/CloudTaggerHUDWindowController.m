//
//  CloudTaggerHUDWindowController.m
//  CloudTagger
//
//  Created by Benjamin Marten on 10.02.13.
//  Copyright (c) 2013 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerHUDWindowController.h"

@interface CloudTaggerHUDWindowController ()

@end

@implementation CloudTaggerHUDWindowController

@synthesize image = _image;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window setContentAspectRatio:NSMakeSize(1, 1)];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)showWindow:(id)sender
{
    NSPoint mouseLoc = [NSEvent mouseLocation];
    [self.window setFrameOrigin:NSMakePoint(mouseLoc.x - 150, mouseLoc.y - 150)];
    
    [self.imageView setImage:_image];
    
    [super showWindow:sender];
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    [self.window orderOut:nil];
}

@end
