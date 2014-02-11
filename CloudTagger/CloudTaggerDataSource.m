//
//  CloudTaggerDataSource.m
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerDataSource.h"
#import "CloudTaggerTrackContainer.h"
#import "CloudTaggerTrackCellView.h"
#import "CloudTaggerConstants.h"

@implementation CloudTaggerDataSource

@synthesize rowData = _rowData;

-(id)init
{
    if (![super init]) return nil;
    
    self.rowData = [[NSMutableArray alloc] initWithCapacity:0];
    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.rowData count];
}

- (NSColor *)getColorFromRed:(int)r green:(int)g blue:(int)b
{
    float red = r/256.0f;
    float green = g/256.0f;
    float blue = b/256.0f;
    
    return [NSColor colorWithSRGBRed:red green:green blue:blue alpha:1.0f];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CloudTaggerTrackCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    [result setRowIndex:row];
    
    CloudTaggerTrackContainer *trackContainer = [self.rowData objectAtIndex:row];
    iTunesTrack *track = [trackContainer track];
    
    [[result status] setStringValue:trackContainer.status];
    
    [result.status setBackgroundColor: [NSColor lightGrayColor]];
    
    
    if ([trackContainer.status isEqualToString: TRACK_STATUS_SEARCHING])
    {
        [result.status setBackgroundColor: [self getColorFromRed:181 green:111 blue:226]];
    }    
    if ([trackContainer.status isEqualToString:TRACK_STATUS_MATCHED] || [trackContainer.status isEqualToString:TRACK_STATUS_UPDATED])
    {
        [result.status setBackgroundColor: [self getColorFromRed:146 green:236 blue:126]];
    }
    if ([trackContainer.status isEqualToString: TRACK_STATUS_FOUND])
    {
        [result.status setBackgroundColor: [self getColorFromRed:252 green:255 blue:118]];
    }
    if ([trackContainer.status isEqualToString:TRACK_STATUS_NOT_FOUND])
    {
        [result.status setBackgroundColor: [self getColorFromRed:238 green:143 blue:132]];
    }
    
    // ----- NOW -----
    // artwork
    
    //    if ([result.albumartNow image] != nil)
    //    {
    //        NSBundle *bundle = [NSBundle mainBundle];
    //        NSString *path = [bundle pathForResource:@"music" ofType:@"png"];
    //        NSImage *myImage = [[NSImage alloc] initWithContentsOfFile:path];
    //        [[result albumartNow] setImage:myImage];
    //    }
    
    NSImage *artwork = [trackContainer getTrackArtworkNow];
    if (artwork == nil)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"music" ofType:@"png"];
        artwork = [[NSImage alloc] initWithContentsOfFile:path];
    }
    [[result albumartNow] setImage:artwork];
    
    
    // artist
    [[result artistNow] setStringValue:[track artist]];
    
    // title
    [[result titleNow] setStringValue:[track name]];
    
    // track No & Count
    NSString *trackNoNow = @"";
    if (track.trackNumber != 0)
    {
        trackNoNow = [[NSString alloc] initWithFormat:@"%li", track.trackNumber ];
    }
    
    NSString *trackCountNow = @"";
    if (track.trackCount != 0)
    {
        trackCountNow = [[NSString alloc] initWithFormat:@"%li", track.trackCount ];
    }
    
    if (track.trackNumber != 0 && track.trackCount != 0)
    {
        [[result trackNoCountNow]setStringValue:[[trackNoNow stringByAppendingString: @"/"] stringByAppendingString:trackCountNow]];
    }
    else
    {
        [[result trackNoCountNow]setStringValue:@""];
    }
    
    [[result albumNow]setStringValue:[track album]];
    
    // album No & Count
    NSString *discNoNow = @"";
    if (track.discNumber != 0)
    {
        discNoNow = [[NSString alloc] initWithFormat:@"%li", track.discNumber ];
    }
    
    NSString *discCountNow = @"";
    if (track.discCount != 0)
    {
        discCountNow = [[NSString alloc] initWithFormat:@"%li", track.discCount ];
    }
    
    if (track.discNumber != 0 && track.discCount != 0)
    {
        [[result discNoCountNow]setStringValue:[[discNoNow stringByAppendingString: @"/"] stringByAppendingString:discCountNow]];
    }
    else
    {
        [[result discNoCountNow]setStringValue:@""];
    }
    
    [[result genreNow] setStringValue:[track genre]];
    
    // album & year
    if (track.year != 0)
    {
        NSString *yearNow = [[NSString alloc] initWithFormat:@"%li", [track year] ];
        [[result yearNow]setStringValue:yearNow];
    }
    else
    {
        [[result yearNow]setStringValue:@""];
    }
    
    // ----- THEN -----
    
    CloudTaggerMatchedTrack *matchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    long numberOfResults = [trackContainer getMatchedTracksCount];
    
    if (trackContainer.status == TRACK_STATUS_MATCHED || trackContainer.status == TRACK_STATUS_FOUND || trackContainer.status == OPERATION_SEARCH_ALBUMART)
    {
        // artwork
        NSImage *artwork = [matchedTrack getSelectedTrackArtwork];
        
        if (artwork == nil)
        {
            artwork = [trackContainer getTrackArtworkNow];
        }
        if (artwork == nil)
        {
            NSBundle *bundle = [NSBundle mainBundle];
            
            NSString *path = [bundle pathForResource:@"music" ofType:@"png"];
            
            artwork = [[NSImage alloc] initWithContentsOfFile:path];
        }
        
        [[result albumartThen] setImage:artwork];
        [[result albumartCheckboxThen] setHidden:NO];
        
        if (matchedTrack.selectedArtworkIndex == -1)
        {
            [result.albumartCheckboxThen setHidden:YES];
            [result.enlargeAlbumartButton setHidden:YES];
        }
        else
        {
            [result.albumartCheckboxThen setHidden:NO];
            [result.enlargeAlbumartButton setHidden:NO];
        }
        
        if ([matchedTrack artworkLoading] == YES)
        {
            [result.albumartProgressIndicator startAnimation:nil];
        }
        else
        {
            [result.albumartProgressIndicator stopAnimation:nil];
        }
        
        if (matchedTrack.artworkSelectedForUpdate == YES)
        {
            [result.albumartCheckboxThen setState:1];
        }
        else
        {
            [result.albumartCheckboxThen setState:0];
        }
        
        if (matchedTrack.artworkContainer.count > 1)
        {
            [result.albumartStepperThen setHidden:NO];
            [result.albumartStepperThen setMaxValue:(matchedTrack.artworkContainer.count - 1)];
        }
        else
        {
            [result.albumartStepperThen setHidden:YES];
        }
        
        if (trackContainer.selectedForUpdate == YES)
        {
            [result.metadataCheckboxThen setState:1];
        }
        else
        {
            [result.metadataCheckboxThen setState:0];
        }
        
        if ([trackContainer getMatchedTracksCount] > 1)
        {
            [result.metadataStepperThen setHidden:NO];
            [result.metadataStepperThen setMaxValue:(numberOfResults - 1)];
        }
        else
        {
            [result.metadataStepperThen setHidden:YES];
        }
                
        [result.artistThen setStringValue:matchedTrack.artist];
        
        if (numberOfResults > 1)
        {
            NSString *percent = [[[NSString alloc] initWithFormat:@"%.1f", (matchedTrack.matchRating*100)] stringByAppendingString:@"%"];
            
            NSString *noResults = [[[[NSString alloc]initWithFormat:@"%i", trackContainer.matchedTrackIndex + 1]stringByAppendingString:@"/"] stringByAppendingFormat:@"%li", numberOfResults];
            
            [result.numberOfResults setStringValue: [[percent stringByAppendingString:@" | "] stringByAppendingString:noResults]];
            [result.numberOfResults setHidden:NO];
        }
        else
        {
            [result.numberOfResults setStringValue:@""];
        }
        
        [result.titleThen setStringValue:matchedTrack.title];
        
        // track No & Count
        NSString *trackNumber = matchedTrack.trackNumber;
        NSString *trackCount = matchedTrack.trackCount;
        
        if ([trackNumber isEqualToString:@""] == NO  && [trackCount  isEqualToString:@""] == NO)
        {
            NSString *trackNoCountThen = [[trackNumber stringByAppendingString:@"/"] stringByAppendingString:trackCount];
            [[result trackNoCountThen]setStringValue:trackNoCountThen];
        }
        else
        {
            [[result trackNoCountThen]setStringValue:@""];
        }
        
        [result.albumThen setStringValue:matchedTrack.album];
        
        // disc No & Count
        NSString *discNumber = matchedTrack.discNumber;
        NSString *discCount = matchedTrack.discCount;
        
        if ([discNumber isEqualToString: @""] == NO && [discCount isEqualToString: @""] == NO)
        {
            NSString *discNoCountThen = [[discNumber stringByAppendingString:@"/"] stringByAppendingString:discCount];
            [[result discNoCountThen]setStringValue:discNoCountThen];
        }
        else
        {
            [[result trackNoCountThen]setStringValue:@""];
        }
        
        [result.genreThen setStringValue:matchedTrack.genre];
        
        [result.yearThen setStringValue:matchedTrack.year];
        
        if (trackContainer.alreadyShown == NO) {
            [self showRightViewWithAnimation:result];
            [trackContainer setAlreadyShown:YES];
        }
        else
        {
            [self showRightView:result];
        }
    }
    else
    {
        [self hideRightView:result];
        [result.numberOfResults setHidden:YES];
    }
    return result;
}

- (void)hideRightView:(CloudTaggerTrackCellView*)cellView
{
    NSView *leftView = cellView.nowView;
    NSView *rightView = cellView.thenView;
    NSImageView *arrow = cellView.arrow;
    
    [leftView setFrameSize:NSMakeSize(cellView.frame.size.width, leftView.frame.size.height)];
    
    [arrow setFrameOrigin:NSMakePoint(10000, arrow.frame.origin.y)];
    [arrow setHidden:YES];
    
    [rightView setFrameOrigin:NSMakePoint(10000, rightView.frame.origin.y)];
    [rightView setHidden:YES];
}

- (void)hideRightViewWithAnimation:(CloudTaggerTrackCellView*)cellView
{
    NSView *leftView = cellView.nowView;
    NSView *rightView = cellView.thenView;
    
    NSMutableDictionary *collapseLeftViewAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [collapseLeftViewAnimationDict setObject:leftView forKey:NSViewAnimationTargetKey];
    NSRect newLeftViewFrame = leftView.frame;
    newLeftViewFrame.size.width =  cellView.frame.size.width;
    [collapseLeftViewAnimationDict setObject:[NSValue valueWithRect:newLeftViewFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary *collapseRightViewAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [collapseRightViewAnimationDict setObject:rightView forKey:NSViewAnimationTargetKey];
    NSRect newRightViewFrame = rightView.frame;
    newRightViewFrame.origin.x = cellView.frame.size.width;
    [collapseRightViewAnimationDict setObject:[NSValue valueWithRect:newRightViewFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSViewAnimation *collapseAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:collapseLeftViewAnimationDict,  collapseRightViewAnimationDict, nil]];
    [collapseAnimation setDuration:0.33f];
    [collapseAnimation setDelegate:cellView];
    
    [collapseAnimation startAnimation];
}

- (void)showRightViewWithAnimation:(CloudTaggerTrackCellView*)cellView
{
    NSView *leftView = cellView.nowView;
    NSView *rightView = cellView.thenView;
    NSImageView *arrow = cellView.arrow;
    
    NSMutableDictionary *expandLeftViewAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [expandLeftViewAnimationDict setObject:leftView forKey:NSViewAnimationTargetKey];
    NSRect newLeftViewFrame = leftView.frame;
    newLeftViewFrame.size.width = cellView.frame.size.width / 2;
    [expandLeftViewAnimationDict setObject:[NSValue valueWithRect:newLeftViewFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary *expandRightViewAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [expandRightViewAnimationDict setObject:rightView forKey:NSViewAnimationTargetKey];
    NSRect newRightViewFrame = rightView.frame;
    newRightViewFrame.size.width =  cellView.frame.size.width / 2;
    newRightViewFrame.origin.x =  cellView.frame.size.width / 2;
    [expandRightViewAnimationDict setObject:[NSValue valueWithRect:newRightViewFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary *expandArrowAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [expandArrowAnimationDict setObject:arrow forKey:NSViewAnimationTargetKey];
    NSRect newArrowFrame = arrow.frame;
    newArrowFrame.origin.x =  (cellView.frame.size.width - arrow.frame.size.width) / 2;
    [expandArrowAnimationDict setObject:[NSValue valueWithRect:newArrowFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSViewAnimation *expandAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:expandLeftViewAnimationDict, expandRightViewAnimationDict, expandArrowAnimationDict, nil]];
    [expandAnimation setDuration:0.25];
    
    [rightView setFrameOrigin:NSMakePoint(cellView.frame.size.width, rightView.frame.origin.y)];
    [rightView setHidden:NO];
    
    [arrow setFrameOrigin:NSMakePoint(cellView.frame.size.width, arrow.frame.origin.y)];
    [arrow setHidden:NO];
    
    [expandAnimation startAnimation];
}

- (void)showRightView:(CloudTaggerTrackCellView*)cellView
{
    NSView *leftView = cellView.nowView;
    NSView *rightView = cellView.thenView;
    NSImageView *arrow = cellView.arrow;
    int frameSize = cellView.frame.size.width;
    
    [leftView setFrameSize:NSMakeSize(frameSize / 2, leftView.frame.size.height)];
    
    [rightView setFrameOrigin:NSMakePoint(cellView.frame.size.width / 2, rightView.frame.origin.y)];
    [rightView setFrameSize:NSMakeSize(frameSize / 2, rightView.frame.size.height)];
    [rightView setHidden:NO];
    
    [arrow setFrameOrigin:NSMakePoint((cellView.frame.size.width - arrow.frame.size.width) / 2, arrow.frame.origin.y)];
    [arrow setHidden:NO];
}

@end
