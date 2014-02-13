//
//  CloudTaggerAppDelegate.h
//  CloudTagger
//
//  Created by Benjamin Marten on 30.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudTaggerWindowController.h"

@interface CloudTaggerAppDelegate : NSObject

@property   CloudTaggerWindowController *windowController;
- (IBAction)setTrackMetadataToSingle:(id)sender;

@end
