//
//  CloudTaggerMatchedTrack.h
//  CloudTagger
//
//  Created by Benjamin Marten on 13.10.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

@interface CloudTaggerMatchedTrack : NSObject

@property NSString *artist;
@property NSString *album;
@property NSString *title;
@property NSString *trackCount;
@property NSString *trackNumber;
@property NSString *discCount;
@property NSString *discNumber;
@property NSString *genre;
@property NSString *year;
@property NSString *comment;
@property NSString *artworkUrl600;
@property double matchRating;
@property NSMutableArray *artworkContainer;
@property BOOL artworkSelectedForUpdate;
@property int selectedArtworkIndex;

-(id) initWithDictionary:(NSMutableDictionary*)iTunesStoreResult;

-(id) initWithITunesTrack:(iTunesTrack*)t;

- (NSImage*)getSelectedTrackArtwork;

- (void)preloadNextArtwork;

- (BOOL)artworkLoading;

@end
