//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"

#import "HomeController.h"
#import "TopicController.h"
#import "ReleaseController.h"
#import "MessageController.h"
#import "MineController.h"

#import "LBTabBar.h"
#import "UIImage+Image.h"
#import "ReleaseController.h"
#import "ReleaseTypeChoseController.h"


@interface LBTabBarController ()<LBTabBarDelegate,UITabBarControllerDelegate>

@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica"size:11.0f],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica"size:11.0f],NSFontAttributeName, nil] forState:UIControlStateSelected];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [self setUpAllChildVc];
    //设置标签栏的颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    self.delegate = self;
    _barIndex= 0;


}
- (void)viewWillLayoutSubviews{
    
//    CGRect tabFrame =self.tabBar.frame;
//    
//    tabFrame.size.height= TABBAR_HEIGHT;
//    
//    tabFrame.origin.y= self.view.frame.size.height- TABBAR_HEIGHT;
//    
//    self.tabBar.frame= tabFrame;
    
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{

    HomeController *HomeVC = [[HomeController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home" selectedImage:@"home_select" title:@"首页"];
    [HomeVC.navigationController setNavigationBarHidden:YES animated:YES];

    TopicController *FishVC = [[TopicController alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"community" selectedImage:@"community_select" title:@"话题"];

    MessageController *MessageVC = [[MessageController alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"message" selectedImage:@"message_select" title:@"消息"];

    MineController *MineVC = [[MineController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"mine" selectedImage:@"mine_select" title:@"我的"];


}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    
    
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:Vc];

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
//    [Vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [Vc.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;


    Vc.navigationItem.title = title;

    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{

    ReleaseTypeChoseController *reVc = [[ReleaseTypeChoseController alloc]init];
    LBNavigationController *navVc = [[LBNavigationController alloc] initWithRootViewController:reVc];
    [self presentViewController:navVc animated:YES completion:nil];
   

}


/**
 tabBar代理点击方法
 
 @param tabBar tabBar
 @param item item
 */
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray* arr=self.tabBar.items;
    
    for (int i=0; i<arr.count; i++)
    {
        
        if ([item isEqual:self.tabBar.items[i]])
        {
            _barIndex = i;
            
        }
    }
    if (_barIndex == 0) {
    }else if (_barIndex ==1){
    }else if (_barIndex ==3){
    }else if (_barIndex ==4){
    }
    
    
    
    
    
    
}
@end
