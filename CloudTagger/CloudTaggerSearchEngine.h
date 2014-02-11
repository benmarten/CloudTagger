//
//  CloudTaggerSearchEngine.h
//  CloudTagger
//
//  Created by Benjamin Marten on 04.09.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "CloudTaggerTrackContainer.h"
#import "SBJson.h"

@interface CloudTaggerSearchEngine : NSOperation

-(id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc;

@end
