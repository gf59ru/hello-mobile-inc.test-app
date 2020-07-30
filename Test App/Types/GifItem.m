//
// Created by Nikolai Borovennikov on 30.07.2020.
// Copyright (c) 2020 Hello Mobile Inc. All rights reserved.
//

#import "GifItem.h"


@implementation GifItem {
    NSString *_identifier;
    CGSize _originalSize;
}

@synthesize size, gifData;

- (instancetype)initWithId:(NSString *)identifier andSize:(CGSize)itemSize {
    self = super.init;
    if (self == nil) { return nil; }

    _identifier = identifier;
    _originalSize = itemSize;
    self.size = itemSize;

    return self;
}

- (NSString *)identifier { return _identifier; }

- (CGSize)originalSize { return _originalSize; }

@end