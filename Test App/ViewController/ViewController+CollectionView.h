//
//  ViewController+CollectionView.h
//  Test App
//
//  Created by Nikolai Borovennikov on 28.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

@import UIKit;

#import "ViewController.h"

@interface ViewController (CollectionView) <UICollectionViewDelegate,
        UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout>

@end
