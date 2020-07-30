//
//  ViewController.m
//  Test App
//
//  Created by Nikolai Borovennikov on 27.07.2020.
//  Copyright © 2020 Hello Mobile Inc. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+CollectionView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initSubviews];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

    gifSearch = GifSearch.new;
    gifSearch.delegate = self;

    [gifSearch requestDataWithKeyword:nil];

    gifDownload = GifDownload.new;
    gifDownload.delegate = self;
    gifDownloadToken = nil;

    gifData = [NSMutableArray<GifItem *> new];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];

    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];

}

- (void)initSubviews {

    self.view.translatesAutoresizingMaskIntoConstraints = false;
    [self initTitle];
    [self initSearchBar];

    [self initGifCollectionView];
    [self.view layoutIfNeeded];
}

- (void)initTitle {
    titleView = [UIView.alloc initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 88)];
    titleView.backgroundColor = UIColor.whiteColor;
    titleView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:titleView];

    titleLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44)];
    titleLabel.text = @"Test Task";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:titleLabel];

    [NSLayoutConstraint activateConstraints:@[
            [self.view.topAnchor constraintEqualToAnchor:titleView.topAnchor],
            [self.view.leadingAnchor constraintEqualToAnchor:titleView.leadingAnchor],
            [self.view.trailingAnchor constraintEqualToAnchor:titleView.trailingAnchor],

            [titleLabel.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor],
            [titleLabel.centerXAnchor constraintEqualToAnchor:titleView.centerXAnchor],
            [titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:16],
            [titleLabel.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:16],
            [titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [titleLabel.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)initSearchBar {
    gifSearchBar = [UISearchBar.alloc initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 51, UIScreen.mainScreen.bounds.size.width, 51)];
    gifSearchBar.delegate = self;
    gifSearchBar.returnKeyType = UIReturnKeyDone;
    gifSearchBar.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:gifSearchBar];

    bottomConstraint = [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:gifSearchBar.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[
            [gifSearchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [gifSearchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            bottomConstraint,
            [gifSearchBar.heightAnchor constraintEqualToConstant:51],
    ]];
}

- (void)initGifCollectionView {
    UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;

    gifCollectionView = [UICollectionView.alloc initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:flowLayout];
    gifCollectionView.delegate = self;
    gifCollectionView.dataSource = self;
    gifCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    gifCollectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:gifCollectionView];

    [NSLayoutConstraint activateConstraints:@[
            [gifCollectionView.topAnchor constraintEqualToAnchor:titleView.bottomAnchor],
            [gifCollectionView.bottomAnchor constraintEqualToAnchor:gifSearchBar.topAnchor],
            [gifCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [gifCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        ]];

    [gifCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"gifCell"];

    tapRecognizer = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(dismissKeyboard)];
    [gifCollectionView addGestureRecognizer:tapRecognizer];
}

- (void)dismissKeyboard {
    [gifSearchBar resignFirstResponder];
}

- (CGFloat)rowHeight { return 94; }

#pragma mark search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length < 2 && searchText.length != 0) { return; }

    SEL searchSelector = @selector(search);
    [UIView cancelPreviousPerformRequestsWithTarget:self selector:searchSelector object:nil];
    [self performSelector:searchSelector withObject:nil afterDelay:0.5];
}

- (void)search {
    [gifSearch requestDataWithKeyword:gifSearchBar.text];
}

#pragma mark keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSValue *keyboardFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];

    if (keyboardFrameValue == nil || duration == nil || curve == nil) { return; }

    CGFloat keyboardHeight = keyboardFrameValue.CGRectValue.size.height;

    bottomConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom;

    __weak ViewController *weakSelf = self;
    [UIView animateWithDuration:duration.doubleValue
                          delay:0
                        options:(UIViewAnimationOptions)curve.intValue
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];

    if (duration == nil || curve == nil) { return; }

    bottomConstraint.constant = 0;

    __weak ViewController *weakSelf = self;
    [UIView animateWithDuration:duration.doubleValue
                          delay:0
                        options:(UIViewAnimationOptions)curve.intValue
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:nil];
}

#pragma mark gif search & download delegate

- (void)gifSearchHasResult:(NSArray *)result {
    NSLog(@"Search Results: %@", result);

    if (gifDownloadToken != nil) {
        [gifDownload cancelDownloadTasks];
    }

    NSDate *token = NSDate.now;
    gifDownloadToken = token;
    [gifData removeAllObjects];

    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf reloadGifCollectionView];
    });

    for (id item in result) {
        if (![item isKindOfClass:NSDictionary.class]) { continue; }

        id gifId = item[@"id"];
        if (gifId == nil || ![gifId isKindOfClass:NSString.class]) { continue; }

        id media = item[@"media"];
        if (media == nil || ![media isKindOfClass:NSArray.class]) { continue; }

        id firstItem = media[0];
        if (firstItem == nil || ![firstItem isKindOfClass:NSDictionary.class]) { continue; }

        id gif1 = firstItem[@"gif"];
        if (gif1 == nil || ![gif1 isKindOfClass:NSDictionary.class]) { continue; }

        id urlString = gif1[@"url"];
        if (urlString == nil || ![urlString isKindOfClass:NSString.class]) { continue; }

        id dims = gif1[@"dims"];
        if ((dims == nil || ![dims isKindOfClass:NSArray.class]) && [dims count] != 2) { continue; }
        id width = dims[0];
        id height = dims[1];
        if (![width isKindOfClass:NSNumber.class] ||
            ![height isKindOfClass:NSNumber.class]) { continue; }
        CGSize size = CGSizeMake([width floatValue], [height floatValue]);

        NSURL *url = [NSURL URLWithString:urlString];
        if (url == nil) { continue; }

        [gifData addObject:[GifItem.alloc initWithId:gifId andSize:size]];
        [gifDownload downloadGifWithUrl:url id:gifId usingToken:token];
    }

    [self calculateGifSizeFitting];
}

- (void)calculateGifSizeFitting {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat currentRowWidth = 0;
    uint newRowStartedFrom = 0;

    for (uint i = 0; i < gifData.count; i++) {
        GifItem *gifItem = gifData[i];
        CGFloat ratio = gifItem.size.height / self.rowHeight;
        CGFloat width = gifItem.size.width / ratio;

        [gifItem setSize:CGSizeMake(width, self.rowHeight)];

        currentRowWidth += width;
        if (currentRowWidth >= screenWidth) {
            ratio = currentRowWidth / screenWidth * 1.00001;

            for (uint j = newRowStartedFrom; j <= i; j++) {
                GifItem *resizingGifItem = gifData[j];
                CGSize size = resizingGifItem.size;
                CGFloat newWidth = size.width / ratio;
                [resizingGifItem setSize:CGSizeMake(newWidth, size.height / ratio)];
            }

            currentRowWidth = 0;
            newRowStartedFrom = i + 1;
        }
    }

    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf reloadGifCollectionView];
    });
}

- (void)downloadComplete:(NSData *)data forId:(NSString *)identifier andToken:(NSDate *)token {
    if (![token isEqualToDate:gifDownloadToken]) { return; }

    for (GifItem *gifItem in gifData) {
        if ([gifItem.identifier isEqualToString:identifier]) {
            [gifItem setGifData:data];
            __weak ViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadGifCollectionView];
            });

            return;
        }
    }
}

- (void)reloadGifCollectionView {
    [gifCollectionView reloadData];
}

@end
