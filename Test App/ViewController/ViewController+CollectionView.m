//
//  ViewController+CollectionView.m
//  Test App
//
//  Created by Nikolai Borovennikov on 28.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

#import "ViewController+CollectionView.h"
#import "UIImageView+gif.h"

@implementation ViewController (CollectionView)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gifCell" forIndexPath:indexPath];

    while (cell.contentView.subviews.count > 0) {
        [cell.contentView.subviews[0] removeFromSuperview];
    }

    UIImageView *imageView = UIImageView.new;
    [imageView setClipsToBounds:YES];
    [cell.contentView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
            [imageView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
            [imageView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
            [imageView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
            [imageView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
    ]];

    NSUInteger row = (NSUInteger) indexPath.row;
    if (row < gifData.count) {
        NSData *itemData = gifData[row].gifData;
        if (itemData == nil) { imageView.image = nil; }
        else {[imageView loadGifImageFromData:itemData]; }
    }
    else { imageView.image = nil; }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = (NSUInteger)indexPath.row;
    CGSize size = gifData[row].size;
    return CGSizeMake(size.width, self.rowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return gifData.count;
}

@end
