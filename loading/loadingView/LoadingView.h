//
//  LoadingView.h
//  loading
//
//  Created by liangqi on 15/12/7.
//  Copyright © 2015年 dailyios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

// 动画旋转方向
@property(nonatomic,assign) BOOL clockwise;

+ (instancetype) instance;

@end
