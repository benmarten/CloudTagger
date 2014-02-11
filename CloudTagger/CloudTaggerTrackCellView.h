//
//  CloudTaggerTrackCellView.h
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CloudTaggerTrackCellView : NSTableCellView<NSTableViewDataSource, NSAnimationDelegate>

@property long rowIndex;

@property (weak) IBOutlet NSView *nowView;

@property (weak) IBOutlet NSTextField *status;

@property (strong) IBOutlet NSImageView *albumartNow;
@property (weak) IBOutlet NSTextField *artistNow;
@property (weak) IBOutlet NSTextField *titleNow;
@property (weak) IBOutlet NSTextField *trackNoCountNow;
@property (weak) IBOutlet NSTextField *albumNow;
@property (weak) IBOutlet NSTextField *discNoCountNow;
@property (weak) IBOutlet NSTextField *genreNow;
@property (weak) IBOutlet NSTextField *yearNow;

@property (weak) IBOutlet NSImageView *arrow;

@property (weak) IBOutlet NSView *thenView;
@property (strong) IBOutlet NSImageView *albumartThen;
@property (weak) IBOutlet NSButton *enlargeAlbumartButton;
@property (weak) IBOutlet NSProgressIndicator *albumartProgressIndicator;
@property (weak) IBOutlet NSButton *albumartCheckboxThen;
@property (weak) IBOutlet NSStepper *albumartStepperThen;
@property (weak) IBOutlet NSTextField *artistThen;
@property (weak) IBOutlet NSTextField *numberOfResults;
@property (weak) IBOutlet NSButton *metadataCheckboxThen;
@property (weak) IBOutlet NSTextField *titleThen;
@property (weak) IBOutlet NSTextField *trackNoCountThen;
@property (weak) IBOutlet NSTextField *albumThen;
@property (weak) IBOutlet NSTextField *discNoCountThen;
@property (weak) IBOutlet NSTextField *genreThen;
@property (weak) IBOutlet NSTextField *yearThen;
@property (weak) IBOutlet NSStepper *metadataStepperThen;

- (IBAction)metadataCheckBoxClicked:(NSButton*)sender;
- (IBAction)metadataStepperClicked:(NSStepper*)sender;
- (IBAction)artworkCheckBoxClicked:(NSButton*)sender;
- (IBAction)artworkStepperClicked:(NSStepper*)sender;
- (IBAction)enlargeArtworkButtonClicked:(NSButton*)sender;

@end
