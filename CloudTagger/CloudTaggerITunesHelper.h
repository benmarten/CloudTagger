//
//  CloudTaggerITunesHelper.h
//  CloudTagger
//
//  Created by Benjamin Marten on 04.09.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "CloudTaggerTrackContainer.h"

@interface CloudTaggerITunesHelper : NSOperation

-(id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc andOperationToPerform:(NSString*)otp;

-(NSMutableArray*)retrieveSelectedTracks;

-(void)updateTrack;

-(void)cleanTrack;

@end
