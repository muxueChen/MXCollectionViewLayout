//
//  MXTopicHeaderView.m
//  CollectionViewFlowLayoutDemo
//
//  Created by muxue on 2019/7/7.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXTopicHeaderView.h"

@implementation MXTopicHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = @"话题部分";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}
@end
