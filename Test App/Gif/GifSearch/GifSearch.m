//
//  GifSearch.m
//  Test App
//
//  Created by Nikolai Borovennikov on 27.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

#import "GifSearch.h"
#import "GifSearchDelegate.h"

@implementation GifSearch {
    NSURLSessionTask *searchTask;
}

const NSString *apiKey = @"R911GOAN98UV";

- (void)requestDataWithKeyword:(NSString *)keyword
{
    int limit = 30;
    NSString *urlString;
    if ([keyword stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet].length > 0) {
        urlString = [NSString stringWithFormat:@"https://api.tenor.com/v1/search?key=%@&q=%@&limit=%d", apiKey, keyword, limit];
    }
    else {
        urlString = [NSString stringWithFormat:@"https://api.tenor.com/v1/search?key=%@&limit=%d", apiKey, limit];
    }

    NSURL *searchUrl = [NSURL URLWithString:urlString];
    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:searchUrl];

    __weak GifSearch *weakSelf = self;
    [self makeWebRequest:searchRequest withCallback:^(NSDictionary *dictionary) {
        NSArray *topGifs = dictionary[@"results"];
        [weakSelf stopTask];

        [weakSelf.delegate gifSearchHasResult:topGifs];
    }];
}

-(void)makeWebRequest:(NSURLRequest *)urlRequest withCallback:(void (^)(NSDictionary *))callback
{
    if (searchTask != nil) {
        [self stopTask];
    }
    searchTask = [NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) { return; }

        NSError *jsonError = nil;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];

        if(jsonError != nil) {
            NSLog(@"%@", jsonError.localizedDescription);
            return;
        }

        // Push the results to our callback
        callback(jsonResult);
    }];

    [searchTask resume];
}

- (void)stopTask {
    [searchTask cancel];
    searchTask = nil;
}

@end
