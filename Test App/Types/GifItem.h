//
// Created by Nikolai Borovennikov on 30.07.2020.
// Copyright (c) 2020 Hello Mobile Inc. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@interface GifItem : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic) CGSize size;
@property (nonatomic, strong) NSData *gifData;

- (instancetype)initWithId:(NSString *)identifier andSize:(CGSize)itemSize;

@end