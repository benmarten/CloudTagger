//
//  CloudTaggerServiceController.m
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerServiceController.h"
#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerSearchEngine.h"
#import "CloudTaggerGoogleImageSearchEngine.h"

@implementation CloudTaggerServiceController
{
    CloudTaggerAppDelegate *appDelegate;
    CloudTaggerWindowController *windowController;
    NSOperationQueue *queue;
    
    CloudTaggerITunesHelper *iTunesHelper;
    NSArray *countryCodes;
}

- (id)initWithQueue:(NSOperationQueue*)q
{
    if (![super init]) return nil;
    
    queue = q;
    
    appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    
    windowController = [appDelegate windowController];
    
    iTunesHelper = [[CloudTaggerITunesHelper alloc] init];
    
    return self;
}

- (void)setWindowController:(CloudTaggerWindowController*)wc
{
    windowController = wc;
}

- (NSMutableArray*)retrieveSelectedTracks
{
    return [iTunesHelper retrieveSelectedTracks];
}

- (void)cleanTracks:(NSMutableArray*)tracks
{
    for (CloudTaggerTrackContainer *trackContainer in tracks)
    {
        CloudTaggerITunesHelper *worker = [[CloudTaggerITunesHelper alloc] initWithTrackContainer: trackContainer andOperationToPerform:OPERATION_CLEAN];
        [queue addOperation:worker];
    }
}

- (void)searchMetaDataForTracks:(NSMutableArray*)tracks
{
    
    for (int i = 0; i <tracks.count; i++)
    {
        CloudTaggerSearchEngine *worker = [[CloudTaggerSearchEngine alloc] initWithTrackContainer:[tracks objectAtIndex:i]];
        [queue addOperation:worker];
    }
}

- (void)updateTracks:(NSMutableArray*)tracks
{
    for (CloudTaggerTrackContainer *trackContainer in tracks)
    {
        if (trackContainer.selectedForUpdate == YES)
        {
            CloudTaggerITunesHelper *worker = [[CloudTaggerITunesHelper alloc] initWithTrackContainer: trackContainer andOperationToPerform:OPERATION_UPDATE];
            [queue addOperation:worker];
        }
    }
}

- (void)setTrackMetadataToSingle:(NSMutableArray *)tracks
{
    for (CloudTaggerTrackContainer *trackContainer in tracks)
    {
        if (trackContainer.selectedForUpdate == YES)
        {
            CloudTaggerITunesHelper *worker = [[CloudTaggerITunesHelper alloc] initWithTrackContainer: trackContainer andOperationToPerform:OPERATION_SET_METADATA_TO_SINGLE];
            [queue addOperation:worker];
        }
    }
}

- (void)searchAlbumartForTracks:(NSMutableArray*)tracks
{
    for (CloudTaggerTrackContainer *trackContainer in tracks)
    {
        if ([trackContainer retrieveSelectedMatchedTrack] == nil)
        {
            [trackContainer addMatchedTrack:[[CloudTaggerMatchedTrack alloc] initWithITunesTrack:trackContainer.track]];
            [trackContainer setMatchedTrackIndex:0];
        }
        CloudTaggerGoogleImageSearchEngine *worker = [[CloudTaggerGoogleImageSearchEngine alloc] initWithTrackContainer: trackContainer];
        [queue addOperation:worker];
    }
}

@end