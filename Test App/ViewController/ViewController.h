//
//  ViewController.h
//  Test App
//
//  Created by Nikolai Borovennikov on 27.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

@import UIKit;

#import "GifSearch.h"
#import "GifDownload.h"
#import "GifSearchDelegate.h"
#import "GifDownloadDelegate.h"

@interface ViewController : UIViewController
        <UISearchBarDelegate,
        GifSearchDelegate,
        GifDownloadDelegate> {

    UIView *titleView;
    UILabel *titleLabel;
    UICollectionView *gifCollectionView;
    UISearchBar *gifSearchBar;

    UITapGestureRecognizer *tapRecognizer;

    NSLayoutConstraint *bottomConstraint;

    GifSearch *gifSearch;

    GifDownload *gifDownload;
    NSDate *gifDownloadToken;

    NSMutableArray<NSData *> *gifData;
}


@end

