//
//  CloudTaggerWindowController.h
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CloudTaggerDataSource.h"
#import "CloudTaggerServiceController.h"

@interface CloudTaggerWindowController : NSWindowController

@property (weak) IBOutlet CloudTaggerDataSource *dataSource;
@property (weak) IBOutlet NSScrollView *scrollTableView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *loadSelectedTracksButton;
@property (weak) IBOutlet NSButton *cleanTracksButton;
@property (weak) IBOutlet NSButton *searchMetaDataButton;
@property (weak) IBOutlet NSButton *searchMissingAlbumartButton;
@property (weak) IBOutlet NSButton *updateTracksButton;
@property (weak) IBOutlet NSProgressIndicator *progressBar;

- (IBAction)loadSelectedTracksButtonClicked:(id)sender;
- (IBAction)cleanTracksButtonClicked:(id)sender;
- (IBAction)searchMetaDataButtonClicked:(id)sender;
- (IBAction)searchMissingAlbumartButtonClicked:(id)sender;
- (IBAction)updateTracksButtonClicked:(id)sender;

- (void)loadSelectedTracksIfNoneLoaded;
- (void)resetProgressBar;
- (void)updateRow:(NSNumber*)rowIndex;
- (void)updateProgressBar:(NSNumber*)value;
- (void)selectTrack:(long)index;
- (void)deselectTrack:(long)index;
- (void)setSelectedMatchedTrack:(NSArray*)index;
;
- (void)setSelectedArtworkFor:(NSArray*)index
;
- (void)selectArtwork:(long)index;
- (void)deselectArtwork:(long)index;
- (void)showArtworkPreviewHUD:(NSImage*)image;
- (void)setTrackMetadataToSingle;

@end
