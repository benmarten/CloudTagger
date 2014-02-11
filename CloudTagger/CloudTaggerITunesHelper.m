//
//  CloudTaggerITunesHelper.m
//  CloudTagger
//
//  Created by Benjamin Marten on 04.09.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerITunesHelper.h"
#import "CloudTaggerConstants.h"
#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerWindowController.h"
#import "CloudTaggerConstants.h"

@implementation CloudTaggerITunesHelper
{
    CloudTaggerWindowController *windowController;
    iTunesApplication *iTunes;
    CloudTaggerTrackContainer *trackContainer;
    NSString *operation;
    long countryCodeCount;
}

- (id) init
{
    id result;
    
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    CloudTaggerAppDelegate *appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    
    windowController = [appDelegate windowController];
    
    if (iTunes != nil) {
        if ([iTunes isRunning] == true)
        {
            //            NSLog(@"iTunes application found started.");
            result = [super init];
        } else {
            NSLog(@"iTunes application found, but needs to be started manually.");
            result = nil;
        }
    } else {
        NSLog(@"iTunes application not found.");
        result = nil;
    }
    
    return result;
}

- (id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc andOperationToPerform:(NSString*)otp
{
    if (![self init]) return nil;
    
    trackContainer = tc;
    operation = otp;
    
    return self;
}

- (NSMutableArray*)retrieveSelectedTracks
{
    NSArray* trackList = [[iTunes selection] get];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (id t in trackList)
    {
        NSString *className = [[NSString alloc]initWithFormat:@"%@", [t class] ];
                
        if ([className isEqualToString:@"ITunesFileTrack"] == YES)
        {
            iTunesFileTrack* track = t;
            if ([self isOfCorrectType:track])
            {
                SBElementArray *sources = [iTunes sources];
                
                SBElementArray *entireLibrary = [[[[sources objectAtIndex:0] libraryPlaylists] objectAtIndex:0] fileTracks];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"persistentID == %@", track.persistentID];
                
                NSArray *playlistIndependentTracks = [entireLibrary filteredArrayUsingPredicate:predicate];
                
                iTunesTrack *playlistIndependentTrack = playlistIndependentTracks[0];
                
                CloudTaggerTrackContainer* tc = [[CloudTaggerTrackContainer alloc] initWithTrack:playlistIndependentTrack];
                
                [tc setRowIndex: result.count];
                
                NSLog(@"setting rowIndex: %li", result.count);
                
                [result addObject:tc];
            }
        }
        else
        {
            NSLog(@"the file in selection \n%@\nis not of correct type", t);
        }
    }
    
    NSLog(@"%li track(s) loaded from iTunes.", [trackList count]);
    
    return result;
}

- (Boolean)isOfCorrectType:(iTunesTrack*)track
{
    NSLog(@"%@", track.kind);
//    NSLog(@"%@", NSLocalizedString(TRACK_KIND_MATCHED, nil));
    
    if ([[track kind] isEqualToString:NSLocalizedString(TRACK_KIND_MATCHED, nil)])
    {
        return true;
    }
    else if ([[track kind] isEqualToString:NSLocalizedString(TRACK_KIND_AAC, nil)])
    {
        return true;
    }
    else if ([[track kind] isEqualToString:NSLocalizedString(TRACK_KIND_MP3, nil)])
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(void)main
{
    if (operation == OPERATION_UPDATE)
    {
        CloudTaggerMatchedTrack* matchedTrack = [trackContainer retrieveSelectedMatchedTrack];
        
        if (matchedTrack != nil)
        {
            [trackContainer setStatus:TRACK_STATUS_UPDATING];
            [self updateTrack];
        }
    }
    else if (operation == OPERATION_CLEAN)
    {
        [trackContainer setStatus:TRACK_STATUS_CLEANING];
        [self cleanTrack];
    }
    else if (operation == OPERATION_SET_METADATA_TO_SINGLE)
    {
        [trackContainer setStatus:TRACK_STATUS_UPDATING];
        [self setTrackMetadataToSingle];
    }
}

-(void)updateTrack
{
    CloudTaggerMatchedTrack* matchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    
    iTunesTrack *iTunesTrack = [trackContainer track];
    
    if (matchedTrack.artworkSelectedForUpdate == YES)
    {
        NSImage *aw = [matchedTrack getSelectedTrackArtwork];
        
        iTunesArtwork *tArtw = [[iTunesTrack artworks] objectAtIndex:0];
     
        if (tArtw != nil)
        {
            tArtw.data = aw; // set the track's artwork
        }
    }
    
    [iTunesTrack setArtist:[matchedTrack artist]];
    
    [iTunesTrack setAlbum:[matchedTrack album]];
    
    [iTunesTrack setName:[matchedTrack title]];
    
    [iTunesTrack setDiscCount:[[matchedTrack discCount] intValue]];
    
    [iTunesTrack setDiscNumber:[[matchedTrack discNumber] intValue]];
    
    [iTunesTrack setTrackCount:[[matchedTrack trackCount] intValue]];
    
    [iTunesTrack setTrackNumber:[[matchedTrack trackNumber] intValue]];
    
    [iTunesTrack setGenre:[matchedTrack genre]];
    
    [iTunesTrack setYear:[[matchedTrack year] intValue]];
    
    [iTunesTrack setComment:[matchedTrack comment]];
    
    [trackContainer setStatus:TRACK_STATUS_UPDATED];
    
    [self updateTableRow:trackContainer.rowIndex];
    
    [self updateProgressBar:2 * CloudTaggerConstants.COUNTRY_CODES_COUNT];
}

-(void)setTrackMetadataToSingle
{    
    iTunesTrack *iTunesTrack = [trackContainer track];
    
    NSString *artist = [[iTunesTrack artist] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *title = [[iTunesTrack name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [iTunesTrack setArtist:artist];
    
    [iTunesTrack setAlbum:[title stringByAppendingString:@" - Single"]];
    
    [iTunesTrack setName:title];
    
    [iTunesTrack setDiscCount:1];
    
    [iTunesTrack setDiscNumber:1];
    
    [iTunesTrack setTrackCount:1];
    
    [iTunesTrack setTrackNumber:1];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:iTunesTrack.dateAdded];
    
    [iTunesTrack setYear:components.year];
    
    [iTunesTrack setComment:TRACK_COMMENT];
    
    [trackContainer setStatus:TRACK_STATUS_UPDATED];
    
    [self updateTableRow:trackContainer.rowIndex];
    
    [self updateProgressBar:2 * CloudTaggerConstants.COUNTRY_CODES_COUNT];
}

- (void)cleanTrack
{
    iTunesTrack *iTunesTrack = [trackContainer track];
    
    [iTunesTrack setAlbum:@""];
    
    [iTunesTrack setDiscCount:[@"" intValue]];
    
    [iTunesTrack setDiscNumber:[@"" intValue]];
    
    [iTunesTrack setTrackCount:[@"" intValue]];
    
    [iTunesTrack setTrackNumber:[@"" intValue]];
    
    [iTunesTrack setGenre:@""];
    
    [iTunesTrack setYear:[@"" intValue]];
    
    [iTunesTrack setComment:@""];
    
    [iTunesTrack setComposer:@""];
    
    [iTunesTrack setGrouping:@""];
    
    NSMutableArray *artworks = [iTunesTrack artworks];
    
    [artworks removeAllObjects];
    
    [trackContainer setStatus:TRACK_STATUS_CLEANED];
    
    [self updateTableRow:trackContainer.rowIndex];
    
    [self updateProgressBar: 2 * CloudTaggerConstants.COUNTRY_CODES_COUNT];
}

-(void)updateProgressBar:(double)value
{
    NSNumber *v = [[NSNumber alloc] initWithDouble:value];
    
    [windowController performSelectorOnMainThread:@selector(updateProgressBar:) withObject:v waitUntilDone:YES];
}

-(void)updateTableRow:(long)rowIndex
{
    NSNumber *v = [[NSNumber alloc] initWithLong:rowIndex];
    
    [windowController performSelectorOnMainThread:@selector(updateRow:) withObject:v waitUntilDone:YES];
}

@end
