//
//  ViewController.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/7/17.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    [button2 setTitle:@"Push WKWebView" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(pushWK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    button2.center = self.view.center;
}

- (void)pushWK {
    WKWebViewController *wv = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:wv animated:YES];
}

@end
