//
//  UIImage+gif.m
//  Test App
//
//  Created by Nikolai Borovennikov on 28.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "UIImageView+gif.h"

@implementation UIImageView (gif)

- (void)loadGifImageFromData:(NSData *)data {
    CFDataRef dataRef = (__bridge CFDataRef)data;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData(dataRef, nil);

    size_t imagesCount = CGImageSourceGetCount(imageSourceRef);

    NSMutableArray *images = NSMutableArray.new;
    for (size_t i = 0; i < imagesCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, i, nil);
        UIImage *image = [UIImage imageWithCGImage:imageRef];

        if (image != nil) {
            [images addObject:image];
        }

        CFRelease(imageRef);
    }

    CFRelease(imageSourceRef);

    self.animationImages = images;
    self.animationDuration = 3;
    [self startAnimating];
}

@end
