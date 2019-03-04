//
//  LBNavigationController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBNavigationController.h"
#import "LBTabBarController.h"
//黄色导航栏
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]
@interface LBNavigationController ()

@end

@implementation LBNavigationController

+ (void)load
{



}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.barTintColor =UIColorFromRGB(WhiteColorValue);
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18]
       ,NSForegroundColorAttributeName:UIColorFromRGB(BlackColorValue)
       }];
    self.navigationBar.translucent = NO;
}


-(void)viewWillAppear:(BOOL)animated
{

    [self.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18]
       ,NSForegroundColorAttributeName:UIColorFromRGB(BlackColorValue)
       }];
    self.navigationBar.translucent = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }

    return [super pushViewController:viewController animated:animated];
}








@end
