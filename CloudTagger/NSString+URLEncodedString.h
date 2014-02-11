//
//  NSString+NSString.h
//  CloudTagger
//
//  Created by Benjamin Marten on 27.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
@property (readonly) NSString *URLEncodedString;
@property (readonly) BOOL isEmpty;
@end
