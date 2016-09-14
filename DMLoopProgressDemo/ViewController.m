//
//  ViewController.m
//  DMLoopProgressDemo
//
//  Created by wangdemin on 16/9/14.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import "ViewController.h"
#import "LoopProgressView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LoopProgressView *custom = [[LoopProgressView alloc] initWithFrame:CGRectMake((ScreenWidth - 200) / 2, 120, 200, 200)];
    custom.progress = 3;
    [self.view addSubview:custom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
