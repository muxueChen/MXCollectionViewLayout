//
//  ViewController.m
//  CollectionViewFlowLayoutDemo
//
//  Created by muxue on 2019/7/7.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "ViewController.h"
#import "MXCollectionViewFlowLayout.h"
#import "MXBannerCell.h"
#import "MXTextCell.h"
#import "MXTopicCell.h"
#import "MXPinterestCell.h"
#import "MXBannerHeaderView.h"
#import "MXTextHeaderView.h"
#import "MXPinterstHeaderView.h"
#import "MXTopicHeaderView.h"

@interface ViewController () <UICollectionViewDataSource, MXCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MXCollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *sectionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

-  (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[MXCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.blackColor;
        
        [_collectionView registerClass:MXBannerCell.class forCellWithReuseIdentifier:@"MXBannerCell"];
        [_collectionView registerClass:MXTextCell.class forCellWithReuseIdentifier:@"MXTextCell"];
        [_collectionView registerClass:MXTopicCell.class forCellWithReuseIdentifier:@"MXTopicCell"];
        [_collectionView registerClass:MXPinterestCell.class forCellWithReuseIdentifier:@"MXPinterestCell"];
        [_collectionView registerClass:MXBannerHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXBannerHeaderView"];
        [_collectionView registerClass:MXTextHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXTextHeaderView"];
        [_collectionView registerClass:MXTopicHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXTopicHeaderView"];
        [_collectionView registerClass:MXPinterstHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXPinterstHeaderView"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MXCollectionViewSectionType type = [self.sectionArray[section] integerValue];
    if (type == MXCollectionViewSectionTypeBanner) {
        return 2;
    } else if (type == MXCollectionViewSectionTypeText) {
        return 1;
    } else if (type == MXCollectionViewSectionTypeTopic) {
        return 10;
    } else if (type == MXCollectionViewSectionTypePinterest) {
        return 20;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXCollectionViewSectionType type = [self.sectionArray[indexPath.section] integerValue];
    
    if (type == MXCollectionViewSectionTypeBanner) {
        MXBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXBannerCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.blueColor;
        return cell;
    } else if (type == MXCollectionViewSectionTypeText) {
        MXTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXTextCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.orangeColor;
        return cell;
    } else if (type == MXCollectionViewSectionTypeTopic) {
        MXTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXTopicCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.purpleColor;
        return cell;
    } else if (type == MXCollectionViewSectionTypePinterest) {
        MXPinterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXPinterestCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        return cell;
    }
    return nil;
}

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = @[@(MXCollectionViewSectionTypeBanner), @(MXCollectionViewSectionTypeText), @(MXCollectionViewSectionTypeTopic), @(MXCollectionViewSectionTypePinterest)];
    }
    return _sectionArray;
}

- (MXCollectionViewSectionType)collectionViewFlowLayout:(MXCollectionViewFlowLayout *)layout numberSection:(NSInteger)section {
    return [self.sectionArray[section] integerValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    MXCollectionViewSectionType type = [self.sectionArray[section] integerValue];
    if (type == MXCollectionViewSectionTypeBanner) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (type == MXCollectionViewSectionTypeText) {
        return UIEdgeInsetsMake(0, 0, 0, 0 );
    } else if (type == MXCollectionViewSectionTypeTopic) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    } else if (type == MXCollectionViewSectionTypePinterest) {
        return UIEdgeInsetsMake(5, 10, 10, 10);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXCollectionViewSectionType type = [self.sectionArray[indexPath.section] integerValue];
    if (type == MXCollectionViewSectionTypeBanner) {
        return CGSizeMake(self.view.frame.size.width, 200);
    } else if (type == MXCollectionViewSectionTypeText) {
        return CGSizeMake(self.view.frame.size.width, 200);
    } else if (type == MXCollectionViewSectionTypeTopic) {
                return CGSizeMake(100, 30);
    } else if (type == MXCollectionViewSectionTypePinterest) {
        CGFloat H = 300 + arc4random() %200;
        CGFloat W = (self.view.frame.size.width - 30)/2.0;
        return CGSizeMake(W, H);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 50);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MXCollectionViewSectionType type = [self.sectionArray[indexPath.section] integerValue];
        if (type == MXCollectionViewSectionTypeBanner) {
            MXBannerHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXBannerHeaderView" forIndexPath:indexPath];
            header.backgroundColor = UIColor.whiteColor;
            return header;
        } else if (type == MXCollectionViewSectionTypeText) {
            MXTextHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXTextHeaderView" forIndexPath:indexPath];
            header.backgroundColor = UIColor.whiteColor;
            return header;
        } else if (type == MXCollectionViewSectionTypeTopic) {
            MXTopicHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXTopicHeaderView" forIndexPath:indexPath];
            header.backgroundColor = UIColor.whiteColor;
            return header;
        } else if (type == MXCollectionViewSectionTypePinterest) {
            MXPinterstHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXPinterstHeaderView" forIndexPath:indexPath];
            header.backgroundColor = UIColor.whiteColor;
            return header;
        }
    }
    return nil;
}
@end
