//
//  CloudTaggerSearchEngine.m
//  CloudTagger
//
//  Created by Benjamin Marten on 04.09.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerSearchEngine.h"
#import "iTunes.h"
#import "CloudTaggerTrackContainer.h"
#import <CommonCrypto/CommonDigest.h>
#import "CloudTaggerConstants.h"
#import "CloudTaggerUtil.h"
#import "CloudTaggerGoogleImageSearchEngine.h"
#import "CloudTaggerArtworkContainer.h"
#import "NSString+Levenshtein.h"

@implementation CloudTaggerSearchEngine
{
    NSOperationQueue *queue;
    CloudTaggerTrackContainer* trackContainer;
    CloudTaggerAppDelegate *appDelegate;
    CloudTaggerWindowController *windowController;
}

-(id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc
{
    if (![super init]) return nil;
    
    trackContainer = tc;
    
    [trackContainer setStatus:TRACK_STATUS_QUEUED];
    
    appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    windowController = [appDelegate windowController];
    
    return self;
}

-(void)main
{
    [trackContainer setStatus:TRACK_STATUS_SEARCHING];
    
    [windowController performSelectorOnMainThread:@selector(updateRow:) withObject:[[NSNumber alloc] initWithLong:trackContainer.rowIndex] waitUntilDone:YES];
    
    iTunesTrack *track = [trackContainer track];
    
    BOOL exactMatch = NO;
    
    if ([track.kind isEqualToString: TRACK_KIND_MATCHED])
    {
        exactMatch = [self searchItunesStoreIdBased];
        
        if (exactMatch == YES)
        {
            [trackContainer setStatus:TRACK_STATUS_MATCHED];
        }
    }
    else
    {
        [self updateProgressBar:CloudTaggerConstants.COUNTRY_CODES_COUNT];
    }
    
    if (self.isCancelled == false && exactMatch == NO && [[track.artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] == NO && [[track.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] == NO)
    {
        [self searchItunesStoreStringBased];
                
        CloudTaggerMatchedTrack *matchedTrack = [trackContainer retrieveSelectedMatchedTrack];
        
        if (matchedTrack != nil)
        {
            [trackContainer sortMatchedTracks];
            
            [trackContainer setStatus:TRACK_STATUS_FOUND];
        }
        else
        {
            [trackContainer setStatus:TRACK_STATUS_NOT_FOUND];
        }
    }
    
    [windowController performSelectorOnMainThread:@selector(updateRow:) withObject:[[NSNumber alloc] initWithLong:trackContainer.rowIndex] waitUntilDone:YES];
    
    return;
}

-(BOOL)searchItunesStoreIdBased
{
    iTunesTrack *track = [trackContainer track];
    NSInteger iTunesTrackID = [self getITunesTrackID:track];
    double counter = 0;
    
    for (NSString *countryCode in CloudTaggerConstants.COUNTRY_CODES)
    {
        if ([self isCancelled])
        {
            [trackContainer setStatus:TRACK_STATUS_NONE];
            [self updateProgressBar:CloudTaggerConstants.COUNTRY_CODES_COUNT - counter];
            return NO;
        }
        
        NSLog(@"Searching %@ iTunes Store with iTunes Match ID ...", countryCode);
        
        NSString *iTunesStoreURL = [[[@"https://itunes.apple.com/lookup?id=" stringByAppendingFormat:@"%li", iTunesTrackID] stringByAppendingString:@"&country="] stringByAppendingFormat:@"%@", countryCode];
        
        NSDictionary *iTunesStoreResults = [self getUrlResult:iTunesStoreURL];
        
        NSInteger trackCount = [[iTunesStoreResults objectForKey:@"resultCount"] integerValue];
        
        if (trackCount == 1) {
            NSLog(@"Exactly 1 result found in iTunes Store for itunesTrackID = %li.", iTunesTrackID);
            
            // set result
            NSMutableDictionary *result = [[iTunesStoreResults objectForKey:@"results"] objectAtIndex:0];
            
            CloudTaggerMatchedTrack *matchedTrack = [[CloudTaggerMatchedTrack alloc] initWithDictionary:result];
            
            [trackContainer addMatchedTrack:matchedTrack];
            
            [self setITunesArtwork:matchedTrack];
            
            // progress bar
            [self updateProgressBar: 2 * CloudTaggerConstants.COUNTRY_CODES_COUNT - counter];
            
            return YES;
        }
        else if (trackCount > 1)
        {
            NSLog(@"More results for this ID found.");
        }
        
        [self updateProgressBar:1];
        counter += 1;
    }
    return NO;
}

-(BOOL)searchItunesStoreStringBased
{
    BOOL resultsFound = NO;
    BOOL canceled = NO;
    
    iTunesTrack *track = [trackContainer track];
    double counter = 0;
    
    for (NSString *countryCode in CloudTaggerConstants.COUNTRY_CODES)
    {
        if ([trackContainer getMatchedTracksCount] < MAX_MATCHED_TRACKS_STORAGE)
        {
            NSLog(@"Searching %@ iTunes Store ", countryCode);
            
            if (self.isCancelled == YES || canceled == YES)
            {
                [trackContainer setStatus:TRACK_STATUS_NONE];
                [self updateProgressBar:CloudTaggerConstants.COUNTRY_CODES_COUNT - counter];
                return resultsFound;
            }
            
            NSString *searchTerm = [[[CloudTaggerUtil getFilteredString:track.artist] stringByAppendingString:@" "] stringByAppendingString:[CloudTaggerUtil getFilteredString:track.name]];
            
//            searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *encodedSearchString = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *iTunesStoreURL = [[[@"https://itunes.apple.com/search?term=" stringByAppendingString: encodedSearchString] stringByAppendingString:@"&entity=song&country="] stringByAppendingFormat:@"%@", countryCode];
            
            NSDictionary *iTunesStoreResults = [self getUrlResult:iTunesStoreURL];
            
            for (int i = 0; i <[[iTunesStoreResults objectForKey:@"results"] count]; i++) {
                NSMutableDictionary *result = [[iTunesStoreResults objectForKey:@"results"] objectAtIndex:i];
                
                CloudTaggerMatchedTrack *matchedTrack = [[CloudTaggerMatchedTrack alloc] initWithDictionary:result];
                
                if ([self isGoodMatchedTrack:matchedTrack] == YES)
                {
                    [self setITunesArtwork:matchedTrack];

                    [matchedTrack setMatchRating:[self calculateRatingInPercentForMatchedTrack:matchedTrack andTrack:track]];
                    
                    [trackContainer addMatchedTrack:matchedTrack];
                                        
                    resultsFound = YES;
                    
                    if (matchedTrack.matchRating >= STRING_BASED_SEARCH_MATCH_TRESHHOLD)
                    {
                        canceled = YES;
                    }
                }
            }
        }
        [self updateProgressBar:1];
        counter += 1;
    }
    return resultsFound;
}

-(void)updateProgressBar:(double)value
{
    NSNumber *v = [[NSNumber alloc] initWithDouble:value];
    
    [windowController performSelectorOnMainThread:@selector(updateProgressBar:) withObject:v waitUntilDone:YES];
}

-(NSInteger)getITunesTrackID:(iTunesTrack*)track
{
    iTunesFileTrack *fileTrack = (iTunesFileTrack*)track;
    
    NSData *fileTrackData = [[NSData alloc] initWithContentsOfURL:fileTrack.location];
    
    NSString *a = [[[fileTrackData subdataWithRange:NSMakeRange(624, 4)] description] substringWithRange:NSMakeRange(1,8)];
    
    unsigned result = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:a];
    
    [scanner scanHexInt:&result];
    
    NSInteger iTunesTrackID = result;
    
    NSLog(@"iTunesTrackID: %li", iTunesTrackID);
    
    return iTunesTrackID;
}

- (NSDictionary*)getUrlResult:(NSString*)url
{
    NSDictionary *result = nil;
    
    NSURL *u = [NSURL URLWithString:url];
//    NSLog(@"%@", u);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:u];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    
    id data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    
    if(data != nil && [data isKindOfClass:[NSDictionary class]])
        result = data;
    
    return result;
}

-(void)setITunesArtwork:(CloudTaggerMatchedTrack*)mt
{
    // set itunes store artwork if not already available in track
    if (trackContainer.track.artworks.count == 0)
    {
        if (mt.artworkUrl600 != nil)
        {
            CloudTaggerArtworkContainer *awc = [[CloudTaggerArtworkContainer alloc] initWithThumbnailUrl:[[NSURL alloc] initWithString:mt.artworkUrl600] andArtworkUrl:[[NSURL alloc] initWithString:mt.artworkUrl600] andRowIndex:trackContainer.rowIndex];
    
        mt.artworkContainer = [[NSMutableArray alloc]initWithObjects:awc, nil];
        }
            
        [mt setSelectedArtworkIndex:0];
    }
}

-(BOOL)isGoodMatchedTrack:(CloudTaggerMatchedTrack*)matchedTrack
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:KEYWORDS_TO_EXCLUDE
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSString *searchString = [[matchedTrack.artist stringByAppendingString:matchedTrack.title]stringByAppendingString:matchedTrack.album];
    if ([regex matchesInString:searchString options:0 range:NSMakeRange(0, searchString.length)].count == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(double)calculateRatingInPercentForMatchedTrack:(CloudTaggerMatchedTrack*)matchedTrack andTrack:(iTunesTrack*)track
{
    double result = 0.0;
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
        result = 0.45*artistRating+0.45*titleRating+0.1*albumRating;
    }
    return result;
}

@end
