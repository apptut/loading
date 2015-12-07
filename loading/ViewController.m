//
//  ViewController.m
//  loading
//
//  Created by liangqi on 15/12/3.
//  Copyright © 2015年 dailyios. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"

@interface ViewController ()
@property(nonatomic,strong) LoadingView* loading;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loading = [LoadingView instance];
    _loading.center = self.view.center;
    [self.view addSubview:_loading];
}

- (IBAction)animGo:(UIButton *)sender {
    if (sender.tag == 0) {
        _loading.clockwise = YES;
        [sender setTitle:@"逆时针" forState:UIControlStateNormal];
        sender.tag = 1;
    } else if(sender.tag == 1) {
        _loading.clockwise = NO;
        [sender setTitle:@"顺时针" forState:UIControlStateNormal];
        sender.tag = 0;
    } else {
        CGFloat r = arc4random_uniform(200) / 255.0;
        CGFloat g = arc4random_uniform(200) / 255.0;
        CGFloat b = arc4random_uniform(200) / 255.0;
        _loading.tintColor = [UIColor colorWithRed: r green:g blue: b alpha:1];
    }
}


@end
