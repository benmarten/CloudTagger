//
//  NSString+NSString.m
//  CloudTagger
//
//  Created by Benjamin Marten on 27.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import "NSString+URLEncodedString.h"

@implementation NSString (URLEncoding)

- (NSString*)URLEncodedString
{
    return (__bridge NSString *)(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, NULL, CFSTR(" :/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
}

- (BOOL)isEmpty
{
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end