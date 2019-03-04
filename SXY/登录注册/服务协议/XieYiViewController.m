//
//  XieYiViewController.m
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "XieYiViewController.h"

@interface XieYiViewController ()

@end

@implementation XieYiViewController{
    UIWebView *_webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务协议";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadXieYi];
}

- (void)initUI{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64)];
    [self.view addSubview:_webView];
    
}


- (void)loadXieYi{
    [[UserPL shareManager] userUsergetFindAgreementWithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *resultDic = returnValue[@"result"];
        [_webView loadHTMLString:resultDic[@"context"] baseURL:nil];
    } andErrorBlock:^(NSString *msg) {
        
    }];
    
}



@end
