//
//  CloudTaggerGoogleImageSearchEngine.h
//  CloudTagger
//
//  Created by Benjamin Marten on 27.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudTaggerTrackContainer.h"
#import "CloudTaggerConstants.h"

@interface CloudTaggerGoogleImageSearchEngine : NSOperation

-(id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc;

-(NSMutableArray*)retrieveListOfImagesForKeyword:(NSString*)keyword;

@end
