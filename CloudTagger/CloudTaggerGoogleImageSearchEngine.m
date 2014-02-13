//
//  CloudTaggerGoogleImageSearchEngine.m
//  CloudTagger
//
//  Created by Benjamin Marten on 27.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerGoogleImageSearchEngine.h"
#import "NSString+URLEncodedString.h"
#import "TFHpple.h"
#import "CloudTaggerAppDelegate.h"
#import "CloudTaggerWindowController.h"
#import "CloudTaggerArtworkContainer.h"

@implementation CloudTaggerGoogleImageSearchEngine
{
    CloudTaggerTrackContainer *trackContainer;
    CloudTaggerWindowController *windowController;
}

- (id)initWithTrackContainer:(CloudTaggerTrackContainer*)tc
{
    if (![super init]) return nil;
    
    CloudTaggerAppDelegate *appDelegate = (CloudTaggerAppDelegate *)[[NSApplication sharedApplication] delegate];
    
    windowController = [appDelegate windowController];
    
    trackContainer = tc;
    
    return self;
}

- (void)main
{
    NSMutableArray *keywords = [[NSMutableArray alloc] initWithCapacity:0];
    
    CloudTaggerMatchedTrack *selectedMatchedTrack = [trackContainer retrieveSelectedMatchedTrack];
    
    if ([selectedMatchedTrack.album isEmpty] == NO)
    {
        [keywords addObject:selectedMatchedTrack.album];
    }
    if ([selectedMatchedTrack.album isEmpty] == NO && [selectedMatchedTrack.artist isEmpty] == NO)
    {
        [keywords addObject:[[selectedMatchedTrack.album stringByAppendingString:@" "] stringByAppendingString:selectedMatchedTrack.artist]];
    }
    if ([selectedMatchedTrack.title isEmpty] == NO)
    {
        [keywords addObject:selectedMatchedTrack.title];
    }
    if ([selectedMatchedTrack.title isEmpty] == NO && [selectedMatchedTrack.artist isEmpty] == NO)
    {
        [keywords addObject:[[selectedMatchedTrack.title stringByAppendingString:@" "] stringByAppendingString:selectedMatchedTrack.artist]];
    }
    
    if (keywords.count > 0)
    {
        NSMutableArray *imagesUrl = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSString *keyword in keywords)
        {
            [imagesUrl addObject:[self retrieveListOfImagesForKeyword:keyword]];
        }
        
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < MAX_GOOGLE_IMAGE_SEARCH_RESULTS; i++)
        {
            for (NSMutableArray *arr in imagesUrl)
            {
                @try {
                    [images addObject:[arr objectAtIndex:i]];
                }
                @catch (NSException *exception) {
                    ;
                }
            }
        }
        
        if (images.count > 0)
        {
            [selectedMatchedTrack setArtworkContainer:images];
            
            [selectedMatchedTrack setSelectedArtworkIndex:0];
            
            [selectedMatchedTrack preloadNextArtwork];
            
            [trackContainer setStatus:TRACK_STATUS_FOUND];
        }
    }
    
    [self updateTableRow:trackContainer.rowIndex];
    
    [self updateProgressBar: 1];
}

-(NSMutableArray*)retrieveListOfImagesForKeyword:(NSString*)keyword
{
    NSString *googleImageUrlString = @"http://images.google.com/images?ie=ISO-8859-1&hl=en&tbs=islt:vga,isz:ex,iszw:600,iszh:600&btnG=Google+Search&q=";
    NSString *googleImageUrlStringWithKeyword = [googleImageUrlString stringByAppendingString:[keyword URLEncodedString]];
    
    NSLog(@"%@", googleImageUrlStringWithKeyword);
    
    NSURL *googleImagesUrl = [NSURL URLWithString:googleImageUrlStringWithKeyword];
    
    NSData *googleImages = [[NSData alloc] initWithContentsOfURL:googleImagesUrl];
    
//    NSLog(@"data: %@", [[NSString alloc] initWithContentsOfURL:googleImagesUrl]);
    
    TFHpple *imagesParser = [TFHpple hppleWithHTMLData:googleImages];
    
    NSString *imagesXpathQueryString = @"//table[@class='images_table']/tr/td/a";
    NSArray *imageNodes = [imagesParser searchWithXPathQuery:imagesXpathQueryString];
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in imageNodes)
    {
        NSString *fullImageUrlString = [element objectForKey:@"href"];
        
        NSLog(@"found image url: %@", fullImageUrlString);
        
        NSRange begin = [fullImageUrlString rangeOfString:@"url?q="];
        NSRange end = [fullImageUrlString rangeOfString:@"&sa="];
        
        long l_begin = begin.location + begin.length;
        long l_end = end.location - begin.location - begin.length;
        
        if (l_begin < fullImageUrlString.length && l_end <= fullImageUrlString.length && l_end > l_begin)
        {
            NSString *imageUrlString = [fullImageUrlString substringWithRange:NSMakeRange(l_begin, l_end)];
            
//            NSString *targetWebsite = [NSString stringWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
            
//            NSLog(@"%@", targetWebsite);
            
            NSString *thumbnailUrlString = [[element firstChildWithTagName:@"img"] objectForKey:@"src"];
            
            CloudTaggerArtworkContainer *artworkContainer = [[CloudTaggerArtworkContainer alloc] initWithThumbnailUrl:[[NSURL alloc] initWithString: thumbnailUrlString] andArtworkUrl:[[NSURL alloc] initWithString:imageUrlString] andRowIndex:trackContainer.rowIndex];
            
            [images addObject:artworkContainer];
            
            if (images.count >= MAX_GOOGLE_IMAGE_SEARCH_RESULTS)
            {
                break;
            }
        }
    }
    
    return images;
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
