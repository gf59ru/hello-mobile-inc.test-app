//
// Created by Nikolai Borovennikov on 28.07.2020.
// Copyright (c) 2020 Hello Mobile Inc. All rights reserved.
//

@import Foundation;

@protocol GifDownloadDelegate <NSObject>

- (void)downloadComplete:(NSData *)data andToken:(NSDate *)token;

@end