//
// Created by Nikolai Borovennikov on 28.07.2020.
// Copyright (c) 2020 Hello Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifDownload.h"
#import "GifDownloadDelegate.h"


@implementation GifDownload {
    NSMutableArray<NSURLSessionTask *> *downloadTasks;
}

- (instancetype)init {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    downloadTasks = NSMutableArray.new;

    return self;
}

- (void)downloadGifWithUrl:(NSURL *)url withToken:(NSDate *)token {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak GifDownload *weakSelf = self;
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (weakSelf == nil) { return; }

        if (data == nil) { return; }

        __strong GifDownload *strongSelf = weakSelf;
        [strongSelf.delegate downloadComplete:data andToken:token];
    }];

    [downloadTasks addObject:task];

    [task resume];
}

- (void)cancelDownloadTasks {
    for(NSURLSessionTask *task in downloadTasks) {
        [task cancel];
    }
    [downloadTasks removeAllObjects];
}

@end