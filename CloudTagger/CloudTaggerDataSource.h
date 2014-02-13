//
//  CloudTaggerDataSource.h
//  CloudTagger
//
//  Created by Benjamin Marten on 28.12.12.
//  Copyright (c) 2012 Benjamin Marten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudTaggerDataSource : NSObject<NSTableViewDataSource, NSAnimationDelegate>

@property NSMutableArray *rowData;

@end
