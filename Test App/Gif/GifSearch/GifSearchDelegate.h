//
//  GifSearchDelegate.h
//  Test App
//
//  Created by Nikolai Borovennikov on 27.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GifSearchDelegate <NSObject>

- (void)gifSearchHasResult:(NSArray *)result;

@end

NS_ASSUME_NONNULL_END
