//
//  CloudTaggerServiceController.h
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudTaggerITunesHelper.h"
#import "CloudTaggerDataSource.h"
#import "CloudTaggerWindowController.h"
#import "CloudTaggerConstants.h"
#import "CloudTaggerServiceController.h"

@interface CloudTaggerServiceController : NSObject

- (id)initWithQueue:(NSOperationQueue*)q;

- (NSMutableArray*)retrieveSelectedTracks;

- (void)cleanTracks:(NSMutableArray*)tracks;

- (void)searchMetaDataForTracks:(NSMutableArray*)tracks;

- (void)updateTracks:(NSMutableArray*)tracks;

- (void)setTrackMetadataToSingle:(NSMutableArray*)tracks;

- (void)searchAlbumartForTracks:(NSMutableArray*)tracks;

@end
