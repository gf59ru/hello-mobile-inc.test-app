//
//  GifSearch.h
//  Test App
//
//  Created by Nikolai Borovennikov on 27.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

//NS_ASSUME_NONNULL_BEGIN

@import Foundation;

@protocol GifSearchDelegate;

@interface GifSearch: NSObject

@property (weak, nonatomic) id<GifSearchDelegate> delegate;

- (void)requestDataWithKeyword:(NSString *)keyword;

@end

//NS_ASSUME_NONNULL_END
