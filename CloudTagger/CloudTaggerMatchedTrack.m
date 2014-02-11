//
//  CloudTaggerMatchedTrack.m
//  CloudTagger
//
//  Created by Benjamin Marten on 13.10.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerMatchedTrack.h"
#import "CloudTaggerConstants.h"
#import "CloudTaggerGoogleImageSearchEngine.h"
#import "CloudTaggerArtworkContainer.h"

@implementation CloudTaggerMatchedTrack

@synthesize artist = _artist;
@synthesize album = _album;
@synthesize title = _title;
@synthesize discCount = _discCount;
@synthesize discNumber = _discNumber;
@synthesize trackCount = _trackCount;
@synthesize trackNumber = _trackNumber;
@synthesize genre = _genre;
@synthesize year = _year;
@synthesize comment = _comment;
@synthesize artworkUrl600 = _artworkUrl600;
@synthesize matchRating = _matchRating;
@synthesize artworkContainer = _artworkContainer;
@synthesize artworkSelectedForUpdate = _artworkSelectedForUpdate;
@synthesize selectedArtworkIndex = _selectedArtworkIndex;

- (id)init
{
    if (![super init]) return nil;
    
    [self setSelectedArtworkIndex: -1];
    [self setArtworkSelectedForUpdate:YES];
    
    [self setArtist:@""];
    [self setAlbum:@""];
    [self setTitle:@""];
    [self setDiscCount:@""];
    [self setDiscNumber:@""];
    [self setTrackCount:@""];
    [self setTrackNumber:@""];
    [self setGenre:@""];
    [self setYear:@""];
    [self setComment:@""];
    
    self.matchRating = 0;
    self.comment = TRACK_COMMENT;
    
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*)matchedTrack
{
    if (![self init]) return nil;
    
    if ([matchedTrack objectForKey:@"artistName"])
    {
        [self setArtist:[matchedTrack objectForKey:@"artistName"]];
    }
    if ([matchedTrack objectForKey:@"collectionName"])
    {
        [self setAlbum:[matchedTrack objectForKey:@"collectionName"]];
    }
    if ([matchedTrack objectForKey:@"trackName"])
    {
        [self setTitle: [matchedTrack objectForKey:@"trackName"]];
    }
    if ([matchedTrack objectForKey:@"discCount"])
    {
        [self setDiscCount: [[matchedTrack objectForKey:@"discCount"] stringValue]];
    }
    if ([matchedTrack objectForKey:@"discNumber"])
    {
        [self setDiscNumber: [[matchedTrack objectForKey:@"discNumber"] stringValue]];
    }
    if ([matchedTrack objectForKey:@"trackCount"])
    {
        [self setTrackCount: [[matchedTrack objectForKey:@"trackCount"] stringValue]];
    }
    if ([matchedTrack objectForKey:@"trackNumber"])
    {
        [self setTrackNumber: [[matchedTrack objectForKey:@"trackNumber"] stringValue] ];
    }
    if ([matchedTrack objectForKey:@"primaryGenreName"])
    {
        [self setGenre: [matchedTrack objectForKey:@"primaryGenreName"]];
    }
    if ([matchedTrack objectForKey:@"releaseDate"])
    {
        NSString *releaseDate = [matchedTrack objectForKey:@"releaseDate"];
        [self setYear: [releaseDate substringWithRange:NSMakeRange(0,4)]];
    }
    if ([matchedTrack objectForKey:@"artworkUrl100"])
    {
        [self setArtworkUrl600: [[matchedTrack objectForKey:@"artworkUrl100"] stringByReplacingOccurrencesOfString:@"100x100" withString:@"600x600"]];
    }
    
    return self;
}

-(id) initWithITunesTrack:(iTunesTrack*)t
{
    if (![self init]) return nil;
    
    [self setArtist:t.artist];
    [self setAlbum:t.album];
    [self setTitle:t.name];
    
    // track No & Count
    NSString *trackNumber = [[NSString alloc] initWithFormat:@"%li", t.trackNumber];
    NSString *trackCount = [[NSString alloc] initWithFormat:@"%li", t.trackCount];
    
    [self setTrackNumber:trackNumber];	
    [self setTrackCount:trackCount];
        
    // disc No & Count
    NSString *discNumber = [[NSString alloc] initWithFormat:@"%li", t.discNumber];
    NSString *discCount = [[NSString alloc] initWithFormat:@"%li", t.discCount];
    
    [self setDiscNumber:discNumber];
    [self setDiscCount:discCount];
    
    [self setGenre:t.genre];
    [self setYear:[[NSString alloc] initWithFormat:@"%li", t.year]];
    
    return self;
}

- (NSImage*)getSelectedTrackArtwork
{
    CloudTaggerArtworkContainer *artworkContainer = [_artworkContainer objectAtIndex:_selectedArtworkIndex];
    
    return [artworkContainer artwork];
}

- (BOOL)artworkLoading
{
    CloudTaggerArtworkContainer *artworkContainer = [_artworkContainer objectAtIndex:_selectedArtworkIndex];
    
    return artworkContainer.artworkLoading;
}

- (void)preloadNextArtwork
{
    if (_selectedArtworkIndex + 1 < _artworkContainer.count)
    {
        CloudTaggerArtworkContainer *artworkContainer = [_artworkContainer objectAtIndex:_selectedArtworkIndex + 1];
        [artworkContainer artwork];
    }
}

@end
