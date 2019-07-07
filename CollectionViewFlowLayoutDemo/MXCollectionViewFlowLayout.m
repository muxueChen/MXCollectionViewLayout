//
//  MXCollectionViewFlowLayout.m
//  CollectionViewFlowLayoutDemo
//
//  Created by muxue on 2019/7/7.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXCollectionViewFlowLayout.h"

@interface MXCollectionViewFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary *cellFrameCache;
@property (nonatomic, strong) NSValue *leftFrame;
@property (nonatomic, strong) NSValue *rightFrame;
@property (nonatomic, strong) NSValue *contentSize;
@end

@implementation MXCollectionViewFlowLayout

- (void)removeItemFrameCache {
    [self.cellFrameCache removeAllObjects];
    self.leftFrame = nil;
    self.rightFrame = nil;
    self.contentSize = nil;
}

#pragma mark - UICollectionViewLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    return updatedAttributes;
}

- (CGSize)collectionViewContentSize {
    if (self.contentSize) {
        return [self.contentSize CGSizeValue];
    }
    return [super collectionViewContentSize];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 布局如果是分组的头部视图或者追加视图，则直接返回
    id <MXCollectionViewFlowLayoutDelegate>delegate = (id<MXCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
    MXCollectionViewSectionType type = [delegate collectionViewFlowLayout:self numberSection:indexPath.section];
    // 列间距
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    // 行间距
    CGFloat minimumLineSpacing = [self minimumLineSpacingForSectionAtIndex:indexPath.section];
    // 当前的frame
    CGRect frame = layoutAttributes.frame;
    // 瀑布流布局
    if (type == MXCollectionViewSectionTypePinterest) {
        if (self.cellFrameCache[@(indexPath.row)]) {
            frame = [self.cellFrameCache[@(indexPath.row)] CGRectValue];
            // 判断当前瀑布流的第一个布局是否存在,如果不存在则
        } else if (!self.leftFrame) {
            NSValue *frameValue  = [NSValue valueWithCGRect:frame];
            self.leftFrame = frameValue;
            self.cellFrameCache[@(indexPath.row)] = frameValue;
            // 判断瀑布流的第二个是存在
        } else if (!self.rightFrame) {
            CGRect leftFrame = [self.leftFrame CGRectValue];
            frame.origin.y = leftFrame.origin.y;
            frame.origin.x = CGRectGetMaxX(leftFrame) + minimumInteritemSpacing;
            NSValue *frameValue  = [NSValue valueWithCGRect:frame];
            self.rightFrame = frameValue;
            self.cellFrameCache[@(indexPath.row)] = frameValue;
        } else {
            CGRect leftFrame = [self.leftFrame CGRectValue];
            CGRect rightFrame = [self.rightFrame CGRectValue];
            // 把当前视图放在左边放在最短的一边
            if (CGRectGetMaxY(leftFrame) <= CGRectGetMaxY(rightFrame)) {
                frame.origin.x = leftFrame.origin.x;
                frame.origin.y = CGRectGetMaxY(leftFrame) + minimumLineSpacing;
                NSValue *frameValue = [NSValue valueWithCGRect:frame];
                self.leftFrame = frameValue;
                self.cellFrameCache[@(indexPath.row)] = frameValue;
            } else {
                frame.origin.x = rightFrame.origin.x;
                frame.origin.y = CGRectGetMaxY(rightFrame) + minimumLineSpacing;
                NSValue *frameValue = [NSValue valueWithCGRect:frame];
                self.cellFrameCache[@(indexPath.row)] = frameValue;
                self.rightFrame = frameValue;
            }
        }
    // 话题布局
    } else if (type == MXCollectionViewSectionTypeTopic) {
        UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
        BOOL isFirstItemInSection = indexPath.item == 0;
        // 可布局的最大宽度
        CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
         // 等于第一行第一个
        if (isFirstItemInSection) {
            frame.origin.x = sectionInset.left;
        } else {
            NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
            CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
            CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
            CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                                      frame.origin.y,
                                                      layoutWidth,
                                                      frame.size.height);
            // 判断 previousFrame 是否在 strecthedCurrentFrame 内部，如果不在说明需要换行，否则不换行
            BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
            // 除第一行中的其他行中的第一个item
            if (isFirstItemInRow) {
                frame.origin.x = sectionInset.left;
            } else {
                frame.origin.x = previousFrameRightPoint + minimumInteritemSpacing;
            }
        }
    }
    layoutAttributes.frame = frame;
    if (indexPath.section == self.collectionView.numberOfSections -1 && indexPath.row == [self.collectionView numberOfItemsInSection:self.collectionView.numberOfSections -1] - 1) {
        self.contentSize = [NSValue valueWithCGSize:CGSizeMake(self.collectionView.contentSize.width, CGRectGetMaxY(frame) + 50)];
    }
    return layoutAttributes;
}

// 获取列间距
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    id <MXCollectionViewFlowLayoutDelegate>delegate = (id<MXCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [delegate collectionView:self.collectionView
                                                    layout:self
                  minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}

// 获取行间距
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)index {
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    id <MXCollectionViewFlowLayoutDelegate>delegate = (id<MXCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [delegate collectionView:self.collectionView
                                               layout:self
                  minimumLineSpacingForSectionAtIndex:index];
    }
    return minimumLineSpacing;
}

// 获取组内部间距
- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index {
    id<MXCollectionViewFlowLayoutDelegate> delegate = (id<MXCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}

- (NSMutableDictionary *)cellFrameCache {
    if (!_cellFrameCache) {
        _cellFrameCache = [NSMutableDictionary dictionary];
    }
    return _cellFrameCache;
}
@end
