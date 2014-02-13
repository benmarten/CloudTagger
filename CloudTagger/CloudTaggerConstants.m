//
//  CloudTaggerConstants.m
//  CloudTagger
//
//  Created by Benjamin Marten on 31.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerConstants.h"

NSString *const TRACK_KIND_MATCHED = @"Matched AAC audio file";
NSString *const TRACK_KIND_AAC = @"AAC audio file";
NSString *const TRACK_KIND_MP3 = @"MPEG audio file";

NSString *const TRACK_COMMENT = @"Matched with iTunes store by CloudTagger.";

NSString *const TRACK_STATUS_QUEUED = @"Waiting ...";
NSString *const TRACK_STATUS_CLEANING = @"Cleaning ...";
NSString *const TRACK_STATUS_CLEANED = @"Cleaned";
NSString *const TRACK_STATUS_UPDATING = @"Updating ...";
NSString *const TRACK_STATUS_UPDATED = @"Updated";
NSString *const TRACK_STATUS_NONE = @"";
NSString *const TRACK_STATUS_SEARCHING = @"Searching ...";
NSString *const TRACK_STATUS_MATCHED = @"Matched";
NSString *const TRACK_STATUS_FOUND = @"Found";
NSString *const TRACK_STATUS_NOT_FOUND = @"Not Found";

NSString *const OPERATION_NONE = @"NONE";
NSString *const OPERATION_LOAD = @"LOAD";
NSString *const OPERATION_CLEAN = @"CLEAN";
NSString *const OPERATION_SEARCH_METADATA = @"SEARCH_METADATA";
NSString *const OPERATION_SEARCH_ALBUMART = @"SEARCH_ALBUMART";
NSString *const OPERATION_UPDATE = @"UPDATE";
NSString *const OPERATION_SET_METADATA_TO_SINGLE = @"SET_METADATA_TO_SINGLE";

NSString *const BUTTON_TEXT_CANCEL = @"Cancel";
NSString *const BUTTON_TEXT_CANCELING = @"Canceling ...";
NSString *const BUTTON_TEXT_LOAD_SELECTED_TRACKS = @"Load Selected Tracks";
NSString *const BUTTON_TEXT_CLEAN_TRACKS = @"Clean Tracks";
NSString *const BUTTON_TEXT_SEARCH_META_DATA = @"Search Meta Data";
NSString *const BUTTON_TEXT_LOAD_ITUNES_ALBUMART = @"Load iTunes Albumart";
NSString *const BUTTON_TEXT_SEARCH_MISSING_ALBUMART = @"Search Missing Albumart";
NSString *const BUTTON_TEXT_UPDATE_TRACKS = @"Update Tracks";

NSString *const KEYWORDS_TO_EXCLUDE = @"only hits group|cover|originally performed|a tribute|tribute to|tribute performers|karaoke|as made famous|in the style|the hit co.|top hit makers";

int const MAX_CONCURRENT_OPERATION_COUNT = 20;
int const MAX_CONCURRENT_ITUNES_OPERATION_COUNT = 2;
int const MAX_GOOGLE_IMAGE_SEARCH_RESULTS = 5;
int const MAX_MATCHED_TRACKS_STORAGE = 10;
double const STRING_BASED_SEARCH_MATCH_TRESHHOLD = 0.9;

@implementation CloudTaggerConstants

+ (NSArray*) COUNTRY_CODES
{
    static NSArray* COUNTRY_CODES;
    
    if (COUNTRY_CODES == nil)
    {
        COUNTRY_CODES = [[NSArray alloc] initWithObjects: @"DE", @"US", @"AL", @"DZ", @"AO", @"AI", @"AG", @"AR", @"AM", @"AU", @"AT", @"AZ", @"BS", @"BH", @"BB", @"BY", @"BE", @"BZ", @"BJ", @"BM", @"BT", @"BO", @"BW", @"BR", @"VG", @"BN", @"BG", @"BF", @"KH", @"CA", @"CV", @"KY", @"TD", @"CL", @"CN", @"CO", @"CR", @"HR", @"CY", @"CZ", @"DK", @"DM", @"DO", @"EC", @"EG", @"SV", @"EE", @"FM", @"FJ", @"FI", @"FR", @"GM", @"GH", @"GR", @"GD", @"GT", @"GW", @"GY", @"HN", @"HK", @"HU", @"IS", @"IN", @"ID", @"IE", @"IL", @"IT", @"JM", @"JP", @"JO", @"KZ", @"KE", @"KR", @"KW", @"KG", @"LA", @"LV", @"LB", @"LR", @"LT", @"LU", @"MO", @"MK", @"MG", @"MW", @"MY", @"ML", @"MT", @"MR", @"MU", @"MX", @"MD", @"MN", @"MS", @"MZ", @"NA", @"NP", @"NL", @"NZ", @"NI", @"NE", @"NG", @"NO", @"OM", @"PK", @"PW", @"PA", @"PG", @"PY", @"PE", @"PH", @"PL", @"PT", @"QA", @"CD", @"RO", @"RU", @"KN", @"LC", @"VC", @"ST", @"SA", @"SN", @"SC", @"SL", @"SG", @"SK", @"SI", @"SB", @"ZA", @"ES", @"LK", @"SR", @"SZ", @"SE", @"CH", @"TW", @"TJ", @"TZ", @"TH", @"TT", @"TN", @"TR", @"TM", @"TC", @"UG", @"UA", @"AE", @"GB", @"UY", @"UZ", @"VE", @"VN", @"YE", @"ZW", nil];
        
//        COUNTRY_CODES = [[NSArray alloc] initWithObjects:    @"US", @"DE", @"AU", @"GB", @"ES", @"PT", @"PL", @"CH", @"BE", @"SE", @"IT", @"CA", @"RO", @"MX", @"SI", @"NL", @"FR", @"AT", @"FI", @"GR", @"LU", @"IE", @"NO", @"DK", @"NZ", @"BG", @"CY", @"CZ", @"EE", @"HU", @"LT", @"MT",  @"SK", @"AR", @"BR", @"BO", @"CL", @"CO", @"CR", @"DO", @"EC", @"SV", @"GT", @"HN", @"NI", @"PA", @"PY", @"PE", @"VE", @"BN", @"KH", @"HK", @"LA", @"MO", @"MY", @"PH", @"SG", @"LK", @"TW", @"TH", @"VN", nil];
    }
    
    //, @"JP"
    return COUNTRY_CODES;
}

+ (double) COUNTRY_CODES_COUNT
{
    return (double)[CloudTaggerConstants COUNTRY_CODES].count;
}

+ (NSArray*) SEARCH_FILTER_STRINGS
{
    static NSArray* SEARCH_FILTER_STRINGS;
    
    if (SEARCH_FILTER_STRINGS == nil)
    {
        SEARCH_FILTER_STRINGS = [[NSArray alloc] initWithObjects: @"\\(.*\\)", @"\\(.*", @"\\[.*\\]", @"\\[.*", @" feat.*", @" ft..*", @"vs.*", nil];
    }
    return SEARCH_FILTER_STRINGS;
}

@end


