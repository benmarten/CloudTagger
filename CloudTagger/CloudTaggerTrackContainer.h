//
//  CloudTaggerTrack.h
//  CloudTagger
//
//  Created by Benjamin Marten on 13.10.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "CloudTaggerMatchedTrack.h"

@interface CloudTaggerTrackContainer : NSObject

@property NSString *status;
@property BOOL alreadyShown;
@property BOOL selectedForUpdate;
@property int matchedTrackIndex;
@property long rowIndex;

- (id)initWithTrack:(iTunesTrack*)t;
- (void)filterMatchedTracks;
- (void)rateMatchedTracks;
- (CloudTaggerMatchedTrack*)retrieveSelectedMatchedTrack;
- (void)addMatchedTrack:(CloudTaggerMatchedTrack*)mt;
- (NSImage*)getTrackArtworkNow;
//- (NSImage*)getTrackArtworkThen;
- (int)getMatchedTracksCount;
- (iTunesTrack*)track;
//- (void)loadArtworkImageFor:(NSArray*)index;
- (void)resetMatchedTracks;
- (void)sortMatchedTracks;

@end
