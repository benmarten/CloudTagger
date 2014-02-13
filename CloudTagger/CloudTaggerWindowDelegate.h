//
//  CloudTaggerWindowDelegate.h
//  CloudTagger
//
//  Created by Benjamin Marten on 30.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudTaggerWindowController.h"

@interface CloudTaggerWindowDelegate : NSObject<NSWindowDelegate>

@property (weak) IBOutlet CloudTaggerWindowController* windowController;

@end
