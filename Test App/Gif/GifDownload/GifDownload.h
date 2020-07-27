//
// Created by Nikolai Borovennikov on 28.07.2020.
// Copyright (c) 2020 Hello Mobile Inc. All rights reserved.
//

@import Foundation;

@protocol GifDownloadDelegate;

@interface GifDownload : NSObject

@property (weak, nonatomic) id<GifDownloadDelegate> delegate;

- (void)downloadGifWithUrl:(NSURL *)url withToken:(NSDate *)token;

- (void)cancelDownloadTasks;

@end