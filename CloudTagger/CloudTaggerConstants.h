//
//  CloudTaggerConstants.h
//  CloudTagger
//
//  Created by Benjamin Marten on 31.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudTaggerConstants : NSObject

extern NSString *const TRACK_KIND_MATCHED;
extern NSString *const TRACK_KIND_AAC;
extern NSString *const TRACK_KIND_MP3;

extern NSString *const TRACK_COMMENT;

extern NSString *const TRACK_STATUS_QUEUED;
extern NSString *const TRACK_STATUS_CLEANING;
extern NSString *const TRACK_STATUS_CLEANED;
extern NSString *const TRACK_STATUS_UPDATING;
extern NSString *const TRACK_STATUS_UPDATED;
extern NSString *const TRACK_STATUS_NONE;
extern NSString *const TRACK_STATUS_SEARCHING;
extern NSString *const TRACK_STATUS_MATCHED;
extern NSString *const TRACK_STATUS_FOUND;
extern NSString *const TRACK_STATUS_NOT_FOUND;

extern NSString *const OPERATION_NONE;
extern NSString *const OPERATION_LOAD;
extern NSString *const OPERATION_CLEAN;
extern NSString *const OPERATION_SEARCH_METADATA;
extern NSString *const OPERATION_SEARCH_ALBUMART;
extern NSString *const OPERATION_UPDATE;

extern NSString *const BUTTON_TEXT_CANCEL;
extern NSString *const BUTTON_TEXT_CANCELING;
extern NSString *const BUTTON_TEXT_LOAD_SELECTED_TRACKS;
extern NSString *const BUTTON_TEXT_CLEAN_TRACKS;
extern NSString *const BUTTON_TEXT_SEARCH_META_DATA;
extern NSString *const BUTTON_TEXT_SEARCH_MISSING_ALBUMART;
extern NSString *const BUTTON_TEXT_UPDATE_TRACKS;
extern NSString *const OPERATION_SET_METADATA_TO_SINGLE;

extern NSString *const KEYWORDS_TO_EXCLUDE;

extern int const MAX_CONCURRENT_OPERATION_COUNT;
extern int const MAX_CONCURRENT_ITUNES_OPERATION_COUNT;
extern int const MAX_GOOGLE_IMAGE_SEARCH_RESULTS;
extern int const MAX_MATCHED_TRACKS_STORAGE;
extern double const STRING_BASED_SEARCH_MATCH_TRESHHOLD;

+ (NSArray*) COUNTRY_CODES;
+ (double) COUNTRY_CODES_COUNT;
+ (NSArray*) SEARCH_FILTER_STRINGS;

@end