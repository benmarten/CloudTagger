//
//  CloudTaggerArtworkContainer.h
//  CloudTagger
//
//  Created by Benjamin Marten on 09.02.13.
//  Copyright (c) 2013 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudTaggerArtworkContainer : NSObject

@property NSURL *thumbnailUrl;
@property NSURL *artworkUrl;
@property NSImage *artwork;
@property BOOL artworkLoading;
@property long rowIndex;

- (id)initWithThumbnailUrl:(NSURL*)thumbnailUrl andArtworkUrl:(NSURL*)artworkUrl andRowIndex:(long)rowIndex;

@end
