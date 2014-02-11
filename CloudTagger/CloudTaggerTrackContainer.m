//
//  CloudTaggerTrack.m
//  CloudTagger
//
//  Created by Benjamin Marten on 13.10.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerTrackContainer.h"
#import "CloudTaggerConstants.h"
#import "NSString+Levenshtein.h"
#import "CloudTaggerUtil.h"
#import "CloudTaggerWindowController.h"
#import "CloudTaggerAppDelegate.h"

@implementation CloudTaggerTrackContainer
{
    CloudTaggerWindowController *windowController;
    iTunesTrack *track;
    NSMutableArray *matchedTracks;
    int maxMatchRating;
}

@synthesize status = _status;
@synthesize alreadyShown = _alreadyShown;
@synthesize selectedForUpdate;
@synthesize matchedTrackIndex = _matchedTrackIndex;
@synthesize rowIndex = _rowIndex;

- (id)initWithTrack:(iTunesTrack*)t
{
    if (![super init]) return nil;
    
    CloudTaggerAppDelegate *appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    windowController = [appDelegate windowController];
    
    matchedTracks = [[NSMutableArray alloc]initWithCapacity:0];
    maxMatchRating = -1;
    track = t;
    [self setMatchedTrackIndex: -1];
    [self setStatus: TRACK_STATUS_NONE];
    [self setAlreadyShown: NO];
    [self setSelectedForUpdate:YES];
    
    return self;
}

- (void)addMatchedTrack:(CloudTaggerMatchedTrack*)mt
{
    if (matchedTracks.count == 0)
    {
        [matchedTracks addObject:mt];
        [self setMatchedTrackIndex: 0];
    }
    else
    {
        BOOL equal1;
        BOOL equal2;
        BOOL equal3;
        for (CloudTaggerMatchedTrack *existing in matchedTracks)
        {
//            NSLog(@"%@", [[existing.album stringByAppendingString:@"-"] stringByAppendingString:mt.album]);
            
            equal1 = [mt.artist isEqualToString:existing.artist];
            equal2 = [mt.title isEqualToString:existing.title];
            equal3 = [mt.album isEqualToString:existing.album];
            if (equal1 == YES && equal2 == YES & equal3 == YES)
            {
                break;
            }
        }
        if ((equal1 == YES && equal2 == YES & equal3 == YES) == NO)
        {
            [matchedTracks addObject:mt];
            [self setMatchedTrackIndex: 0];
        }
    }
}

- (void)filterMatchedTracks
{
    NSMutableArray *tracksToRemove = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < matchedTracks.count; i++) {
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:KEYWORDS_TO_EXCLUDE
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        CloudTaggerMatchedTrack *matchedTrack = [matchedTracks objectAtIndex:i];
        NSString *searchString = [[matchedTrack.artist stringByAppendingString:matchedTrack.title]stringByAppendingString:matchedTrack.album];
        [regex enumerateMatchesInString:searchString options:0 range:NSMakeRange(0, [searchString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            [tracksToRemove addObject:matchedTrack];
        }];
    }
    
    for (CloudTaggerMatchedTrack *t in tracksToRemove)
    {
        NSLog(@"filtered out result: %@", [t.artist stringByAppendingString:t.title]);
        [matchedTracks removeObject:t];
    }
}

- (void)rateMatchedTracks
{
    for (CloudTaggerMatchedTrack *matchedTrack in matchedTracks)
    {
        double artistRating = 0.0;
        double titleRating = 0.0;
        double albumRating = 0.0;
        
        if ([track.artist isEqualToString:@""] == NO)
        {
            artistRating = (int)[[CloudTaggerUtil getFilteredString:track.artist ] asciiLevenshteinDistanceWithString:[CloudTaggerUtil getFilteredString:matchedTrack.artist]];
        }
        if ([track.name isEqualToString:@""] == NO)
        {
            titleRating = (double)[[CloudTaggerUtil getFilteredString:track.name] asciiLevenshteinDistanceWithString:[CloudTaggerUtil getFilteredString:matchedTrack.title]];
            albumRating = (double)[[CloudTaggerUtil getFilteredString:track.name] asciiLevenshteinDistanceWithString:[CloudTaggerUtil getFilteredString:matchedTrack.album]];
            [matchedTrack setMatchRating:0.45*artistRating+0.45*titleRating+0.1*albumRating];
        }
        
//        NSLog(@"%@",[[track.artist stringByAppendingString:@"-"] stringByAppendingString:track.name]);
//        NSLog(@"%@",[[matchedTrack.artist stringByAppendingString:@"-"] stringByAppendingString:matchedTrack.title]);
//        NSLog(@"%f", 0.5*artistRating+0.5*titleRating);

    }
}

- (void)sortMatchedTracks
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"matchRating"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [matchedTracks sortedArrayUsingDescriptors:sortDescriptors];
    matchedTracks = [[NSMutableArray alloc]initWithArray:sortedArray];
    self.matchedTrackIndex = 0;
}

- (CloudTaggerMatchedTrack*)retrieveSelectedMatchedTrack
{
    CloudTaggerMatchedTrack *matchedTrack = nil;
    
    if (self.matchedTrackIndex >= 0 && self.matchedTrackIndex < matchedTracks.count)
    {
        matchedTrack = [matchedTracks objectAtIndex:self.matchedTrackIndex];
    }
    else if (self.matchedTrackIndex < matchedTracks.count)
    {
        NSLog(@"retrieveSelectedMatchedTrack: matchedTrackIndex out of bounds");
    }
    
    return matchedTrack;
}

- (NSImage*)getTrackArtworkNow
{
    NSImage *aw = nil;
    
    if (track.artworks.count > 0)
    {
        iTunesArtwork *iTunesArtwork = [[track artworks]objectAtIndex:0];
        
        aw = [[NSImage alloc] initWithData:[iTunesArtwork rawData]];
    }
    
    return aw;
}
//
//- (NSImage*)getTrackArtworkThen
//{
//    NSImage *aw = nil;
//    
//    if (self.matchedTrackIndex >= 0 && self.matchedTrackIndex < matchedTracks.count)
//    {
//        CloudTaggerMatchedTrack *matchedTrack = [matchedTracks objectAtIndex:self.matchedTrackIndex];
//        
//        if (matchedTrack.selectedArtworkIndex < matchedTrack.artworkContainer.count)
//        {
//            aw = matchedTrack.artworkContainer ;
//            
//            aw = [matchedTrack.artworkContainer objectAtIndex: matchedTrack.selectedArtworkIndex];
//        }
//    }
//    
//    return aw;
//}

- (int)getMatchedTracksCount
{
    return (int)matchedTracks.count;
}

- (iTunesTrack*)track
{
    return track;
}
//
//- (void)loadArtworkImageFor:(NSArray*)index
//{
//    NSNumber *rowIndex = [index objectAtIndex:0];
//    NSNumber *matchedArtworkIndex = [index objectAtIndex:1];
//    
//    CloudTaggerMatchedTrack *matchedTrack = [matchedTracks objectAtIndex:self.matchedTrackIndex];
//    
//    NSURL *url = [[NSURL alloc] initWithString:[matchedTrack.artworkUrls objectAtIndex:matchedArtworkIndex.intValue]];
//    
//    [matchedTrack addArtworkFromUrl:url];
//
//    [windowController performSelectorOnMainThread:@selector(updateRow:) withObject:rowIndex waitUntilDone:YES];
//    
//}
//

- (void)resetMatchedTracks
{
    matchedTracks = [[NSMutableArray alloc]initWithCapacity:0];
    _matchedTrackIndex = -1;
}

@end
