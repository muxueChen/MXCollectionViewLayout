//
//  MXCollectionViewFlowLayout.h
//  CollectionViewFlowLayoutDemo
//
//  Created by muxue on 2019/7/7.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXCollectionViewFlowLayout;

typedef enum : NSUInteger {
    // banner
    MXCollectionViewSectionTypeBanner = 1,
    // 文本内容
    MXCollectionViewSectionTypeText,
    // 话题布局
    MXCollectionViewSectionTypeTopic,
    // 瀑布流布局
    MXCollectionViewSectionTypePinterest,
} MXCollectionViewSectionType;

NS_ASSUME_NONNULL_BEGIN
@protocol MXCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
@optional
/** 获取当前分组类型 */
- (MXCollectionViewSectionType)collectionViewFlowLayout:(MXCollectionViewFlowLayout *)layout numberSection:(NSInteger)section;
@end

/** 自定义布局类 */
@interface MXCollectionViewFlowLayout : UICollectionViewFlowLayout
- (void)removeItemFrameCache;
@end

NS_ASSUME_NONNULL_END
