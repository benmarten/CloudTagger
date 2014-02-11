//
//  CloudTaggerUtil.m
//  CloudTagger
//
//  Created by Benjamin Marten on 27.01.13.
//  Copyright (c) 2013 Benjamin Marten. All rights reserved.
//

#import "CloudTaggerUtil.h"
#import "CloudTaggerConstants.h"

@implementation CloudTaggerUtil

+(NSString*)getFilteredString:(NSString*)string
{  
    NSString *result = [string lowercaseString];
    
    for (NSString *filter in CloudTaggerConstants.SEARCH_FILTER_STRINGS)
    {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:filter options:0 error:nil];
        NSRange range = NSMakeRange(0, result.length);
        result = [re stringByReplacingMatchesInString:result options:0 range:range withTemplate:@""];
    }
        
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    result = [[result componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzäöüßáéíóúàèìòùâêîôû0123456789.-' "] invertedSet]] componentsJoinedByString:@""];
    
//    NSLog(@"%@", [[string stringByAppendingString:@" --> "]stringByAppendingString:result]);
    
    return result;
}

@end
