//
//  ViewController.m
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "ViewController.h"
#import "RootListViewController.h"
#import "Masonry.h"
@import Photos;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton new];
    [button setTitle:@"相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)showPhoto{
    RootListViewController *rootVC = [[RootListViewController alloc] init];
    UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


@end
