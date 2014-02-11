//
//  CloudTaggerWindowController.m
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerWindowController.h"
#import "CloudTaggerServiceController.h"
#import "CloudTaggerConstants.h"
#import "CloudTaggerHUDWindowController.h"

@implementation CloudTaggerWindowController
{
    NSMutableArray *tracks;
    NSString *currentOperation;
    CloudTaggerServiceController *serviceController;
    NSOperationQueue *queue;
    NSArray *countryCodes;
    CloudTaggerHUDWindowController *hudWindowController;
}

- (id)initWithWindowNibName:(NSString*)windowNibName
{
    if (![super initWithWindowNibName:windowNibName]) return nil;
    
    tracks = nil;
    
    currentOperation = OPERATION_NONE;
    
    //Queue:
    queue = [[NSOperationQueue alloc] init];
    [queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    
    serviceController = [[CloudTaggerServiceController alloc] initWithQueue:queue];
    
    hudWindowController = [[CloudTaggerHUDWindowController alloc] initWithWindowNibName:@"CloudTaggerHUDWindow"];
    
    return self;
}

- (IBAction)loadSelectedTracksButtonClicked:(id)sender;
{
    if (currentOperation == OPERATION_NONE)
    {
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [self disableAllButtonsExceptCurrentOperation];
        
        tracks = nil;
        
        tracks = [serviceController retrieveSelectedTracks];
        
        [self.dataSource setRowData:tracks];
        
        [self.tableView reloadData];
        
        [self enableAllButtons];
        
        [self.progressBar setIndeterminate:NO];
        [self.progressBar stopAnimation:self];
        [self resetProgressBar];
    }
}

- (IBAction)cleanTracksButtonClicked:(id)sender
{
    if (currentOperation == OPERATION_NONE)
    {
        if ([tracks count] > 0)
        {
            [self resetProgressBar];
            [self.progressBar setIndeterminate:YES];
            [self.progressBar startAnimation:self];
            
            [queue setMaxConcurrentOperationCount:MAX_CONCURRENT_ITUNES_OPERATION_COUNT];
            
            currentOperation = OPERATION_CLEAN;
            
            [self disableAllButtonsExceptCurrentOperation];
            
            [self.cleanTracksButton setTitle:BUTTON_TEXT_CANCEL];
            
            [NSThread detachNewThreadSelector:@selector(cleanTracks:) toTarget:serviceController withObject:tracks];
        }
    }
    else if (currentOperation == OPERATION_CLEAN)
    {
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [self.cleanTracksButton setEnabled:NO];
        
        [self.cleanTracksButton setTitle:BUTTON_TEXT_CANCELING];
        
        [queue cancelAllOperations];
    }
}

- (IBAction)searchMetaDataButtonClicked:(id)sender
{
    if (currentOperation == OPERATION_NONE)
    {
        [self resetMatchedTracks];
        
        if ([tracks count] > 0)
        {
            [self resetProgressBar];
            [self.progressBar setIndeterminate:YES];
            [self.progressBar startAnimation:self];
            
            [queue setMaxConcurrentOperationCount:MAX_CONCURRENT_OPERATION_COUNT];
            
            currentOperation = OPERATION_SEARCH_METADATA;
            
            [self disableAllButtonsExceptCurrentOperation];
            
            [self.searchMetaDataButton setTitle:BUTTON_TEXT_CANCEL];
            
            [NSThread detachNewThreadSelector:@selector(searchMetaDataForTracks:) toTarget:serviceController withObject:tracks];
        }
    }
    else
    {
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [self.searchMetaDataButton setEnabled:NO];
        
        [self.searchMetaDataButton setTitle:BUTTON_TEXT_CANCELING];
        
        [queue cancelAllOperations];
    }
}

- (IBAction)searchMissingAlbumartButtonClicked:(id)sender
{
    if (currentOperation == OPERATION_NONE)
    {
        NSMutableArray *tracksToProcess = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (CloudTaggerTrackContainer *trackContainer in tracks)
        {
            NSImage *img = [trackContainer getTrackArtworkNow];
            if (img == nil)
            {
                [tracksToProcess addObject:trackContainer];
            }
        }
        
        if (tracksToProcess.count > 0)
        {
            [self resetProgressBar];
            [self.progressBar setIndeterminate:YES];
            [self.progressBar startAnimation:self];
            
            [queue setMaxConcurrentOperationCount:MAX_CONCURRENT_OPERATION_COUNT];
            
            currentOperation = OPERATION_SEARCH_ALBUMART;
            
            [self disableAllButtonsExceptCurrentOperation];
            
            [self.searchMissingAlbumartButton setTitle:BUTTON_TEXT_CANCEL];
            
            [self.progressBar setMaxValue:tracksToProcess.count];
            
            [NSThread detachNewThreadSelector:@selector(searchAlbumartForTracks:) toTarget:serviceController withObject:tracksToProcess];
        }
    }
    else
    {
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [self.searchMissingAlbumartButton setEnabled:NO];
        
        [self.searchMissingAlbumartButton setTitle:BUTTON_TEXT_CANCELING];
        
        [queue cancelAllOperations];
    }
}

- (IBAction)updateTracksButtonClicked:(id)sender
{
    if (currentOperation == OPERATION_NONE)
    {
        if ([tracks count] > 0)
        {
            currentOperation = OPERATION_UPDATE;
            
            [self disableAllButtonsExceptCurrentOperation];
            
            [self.updateTracksButton setTitle:BUTTON_TEXT_CANCEL];
            
            [queue setMaxConcurrentOperationCount:MAX_CONCURRENT_ITUNES_OPERATION_COUNT];
            
            [self resetProgressBar];
            [self.progressBar setIndeterminate:YES];
            [self.progressBar startAnimation:self];
            
            [NSThread detachNewThreadSelector:@selector(updateTracks:) toTarget:serviceController withObject:tracks];
        }
    }
    else
    {
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [self.updateTracksButton setEnabled:NO];
        
        [self.updateTracksButton setTitle:BUTTON_TEXT_CANCELING];
        
        [queue cancelAllOperations];
    }
}

- (void)setTrackMetadataToSingle
{
    if ([tracks count] > 0)
    {
        currentOperation = OPERATION_UPDATE;
        
        [self disableAllButtonsExceptCurrentOperation];
        
        [self.updateTracksButton setTitle:BUTTON_TEXT_CANCEL];
        
        [queue setMaxConcurrentOperationCount:MAX_CONCURRENT_ITUNES_OPERATION_COUNT];
        
        [self resetProgressBar];
        [self.progressBar setIndeterminate:YES];
        [self.progressBar startAnimation:self];
        
        [NSThread detachNewThreadSelector:@selector(setTrackMetadataToSingle:) toTarget:serviceController withObject:tracks];
    }
}

- (void) loadSelectedTracksIfNoneLoaded
{
    if (currentOperation == OPERATION_NONE && tracks.count == 0)
    {
        [self loadSelectedTracksButtonClicked:self];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == queue && [keyPath isEqualToString:@"operations"])
    {
        if ([queue.operations count] == 0)
        {
            if (currentOperation == OPERATION_LOAD)
            {
                currentOperation = OPERATION_NONE;
                
                [self.loadSelectedTracksButton setTitle:BUTTON_TEXT_LOAD_SELECTED_TRACKS];
            }
            if (currentOperation == OPERATION_CLEAN)
            {
                currentOperation = OPERATION_NONE;
                
                [self.cleanTracksButton setTitle:BUTTON_TEXT_CLEAN_TRACKS];
            }
            if (currentOperation == OPERATION_SEARCH_METADATA)
            {
                currentOperation = OPERATION_NONE;
                
                [self.searchMetaDataButton setTitle:BUTTON_TEXT_SEARCH_META_DATA];
            }
            if (currentOperation == OPERATION_SEARCH_ALBUMART)
            {
                currentOperation = OPERATION_NONE;
                
                [self.searchMissingAlbumartButton setTitle:BUTTON_TEXT_SEARCH_MISSING_ALBUMART];
            }
            if (currentOperation == OPERATION_UPDATE)
            {
                currentOperation = OPERATION_NONE;
                
                [self.updateTracksButton setTitle:BUTTON_TEXT_UPDATE_TRACKS];
            }
            
            [self enableAllButtons];
            
            [self resetProgressBar];
        }
    }
}

- (void)disableAllButtonsExceptCurrentOperation
{
    if (currentOperation != OPERATION_LOAD)
    {
        [self.loadSelectedTracksButton setEnabled:NO];
    }
    if (currentOperation != OPERATION_CLEAN)
    {
        [self.cleanTracksButton setEnabled:NO];
    }
    if (currentOperation != OPERATION_SEARCH_METADATA)
    {
        [self.searchMetaDataButton setEnabled:NO];
    }
    if (currentOperation != OPERATION_SEARCH_ALBUMART)
    {
        [self.searchMissingAlbumartButton setEnabled:NO];
    }
    if (currentOperation != OPERATION_UPDATE)
    {
        [self.updateTracksButton setEnabled:NO];
    }
}

- (void)enableAllButtons
{
    [self.loadSelectedTracksButton setEnabled:YES];
    
    [self.cleanTracksButton setEnabled:YES];
    
    [self.searchMetaDataButton setEnabled:YES];
    
    [self.searchMissingAlbumartButton setEnabled:YES];
    
    [self.updateTracksButton setEnabled:YES];
}

- (void)resetProgressBar
{
    [self.progressBar stopAnimation:self];
    [self.progressBar setIndeterminate:NO];
    
    double max = ((tracks.count) * 2 * CloudTaggerConstants.COUNTRY_CODES_COUNT);
    
    if (max == 0)
    {
        max = 1;
    }
    
    [self.progressBar setMaxValue: max];
    
    [self.progressBar setDoubleValue:0.0];
}

- (void)resetMatchedTracks
{
    currentOperation = OPERATION_NONE;
    
    //Queue:
    queue = [[NSOperationQueue alloc] init];
    [queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    
    serviceController = [[CloudTaggerServiceController alloc] initWithQueue:queue];
    
    for (int i = 0; i < tracks.count; i++)
    {
        CloudTaggerTrackContainer *trackContainer = [tracks objectAtIndex:i];
        CloudTaggerTrackContainer *newTrackContainer = [[CloudTaggerTrackContainer alloc] initWithTrack: trackContainer.track];
        [newTrackContainer setRowIndex:trackContainer.rowIndex];
        [tracks replaceObjectAtIndex:i withObject:newTrackContainer];
    }
    
    
}

- (void)updateRow:(NSNumber*)rowIndex
{
    NSRect visibleRect = self.tableView.visibleRect;
    
    NSRange visibleRowRange = [self.tableView rowsInRect:visibleRect];
    
    //    NSLog(@"row: %i", rowIndex.intValue);
    //    NSLog(@"visibleRowRange.location %li", (unsigned long)visibleRowRange.location);
    //    NSLog(@"visibleRowRange.length %li", (unsigned long)visibleRowRange.length);
    //
    if ((rowIndex.intValue >= visibleRowRange.location && rowIndex.intValue < (visibleRowRange.location + visibleRowRange.length)) == NO)
    {
        [[tracks objectAtIndex:rowIndex.intValue] setAlreadyShown:YES];
    }
    
    [self.tableView reloadDataForRowIndexes:[[NSIndexSet alloc] initWithIndex:rowIndex.intValue] columnIndexes:[[NSIndexSet alloc] initWithIndex:0]];
}

- (void)updateProgressBar:(NSNumber*)value
{
    [self.progressBar stopAnimation:self];
    
    [self.progressBar setIndeterminate:NO];
    
    [self.progressBar setDoubleValue:self.progressBar.doubleValue + value.doubleValue];
}

- (void)selectTrack:(long)index
{
    CloudTaggerTrackContainer *trackContainerToToggle = [tracks objectAtIndex:index];
    
    [trackContainerToToggle setSelectedForUpdate:YES];
}

- (void)deselectTrack:(long)index
{
    CloudTaggerTrackContainer *trackContainerToToggle = [tracks objectAtIndex:index];
    
    [trackContainerToToggle setSelectedForUpdate:NO];
}

- (void)selectArtwork:(long)index
{
    CloudTaggerTrackContainer *trackContainer = [tracks objectAtIndex:index];
    
    CloudTaggerMatchedTrack *selectedMatchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    
    [selectedMatchedTrack setArtworkSelectedForUpdate:YES];
}

- (void)deselectArtwork:(long)index
{
    CloudTaggerTrackContainer *trackContainer = [tracks objectAtIndex:index];
    
    CloudTaggerMatchedTrack *selectedMatchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    
    [selectedMatchedTrack setArtworkSelectedForUpdate:NO];
}

- (void)setSelectedMatchedTrack:(NSArray*)index
{
    NSNumber* trackIndex = [index objectAtIndex:0];
    NSNumber* matchedTrackIndex = [index objectAtIndex:1];
    
    CloudTaggerTrackContainer *trackContainer = [tracks objectAtIndex:trackIndex.intValue];
    
    [trackContainer setMatchedTrackIndex:matchedTrackIndex.intValue];
    
    [self.tableView reloadDataForRowIndexes:[[NSIndexSet alloc] initWithIndex:trackIndex.intValue] columnIndexes:[[NSIndexSet alloc] initWithIndex:0]];
}

- (void)setSelectedArtworkFor:(NSArray*)index
{
    NSNumber *rowIndex = [index objectAtIndex:0];
    NSNumber *matchedArtworkIndex = [index objectAtIndex:1];
    
    CloudTaggerTrackContainer *trackContainer = [tracks objectAtIndex:rowIndex.intValue];
    
    CloudTaggerMatchedTrack *selectedMatchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    
    [selectedMatchedTrack setSelectedArtworkIndex:matchedArtworkIndex.intValue];
    
    [selectedMatchedTrack preloadNextArtwork];
    
    [self updateRow:rowIndex];
    
}

- (void)showArtworkPreviewHUD:(NSImage*)image
{
    [hudWindowController setImage:image];
    
    [hudWindowController showWindow:self];
}

@end
