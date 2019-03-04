//
//  BaseViewController.h
//  DaMinEPC
//
//  Created by yh f on 2017/12/5.
//  Copyright © 2017年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
//加载的方式
typedef NS_ENUM(NSInteger, LoadWayType) {
    START_LOAD_FIRST         = 1,
    RELOAD_DADTAS            = 2,
    LOAD_MORE_DATAS          = 3
};

//加载的方式
typedef NS_ENUM(NSInteger, ReleaseType) {
    ReleaseType_WantBuy           = 0,    //求购
    ReleaseType_GoodsInStock      = 1,    //现货
    ReleaseType_Supply            = 2,     //供应
    ReleaseType_SearchIma         = 3    //搜图
    
    
};


@interface BaseViewController : UIViewController

@property (nonatomic,strong)UIView *nothingIma;

@property (nonatomic, assign) BOOL    hideboomLine;   //导航栏隐藏

@property (nonatomic, assign) BOOL    needHideNavBar;   //导航栏隐藏
@property (nonatomic, assign) BOOL    isBlackStatusBar;  //statusbar是否显示黑色
@property (nonatomic, strong) BaseScrollView    *backView;

@property (nonatomic, assign) NSInteger         page;
@property (nonatomic, strong) NSArray           *loadArray;
@property (nonatomic, assign) LoadWayType       loadWay;    //加载的方式


- (void)hideBarbackBtn;
- (void)setBarBackBtnWithImage:(UIImage *)image;
- (void)createRightNavigationItemWithImage:(NSString *)imageName;
- (void)setRightBtnWithTitle:(NSString *)title andColor:(UIColor*)color;
- (void)setLeftBtnWithTitle:(NSString *)title andColor:(UIColor*)color;


#pragma mark -是否只包含数字，小数点，负号

-(BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string;

/**
 用scrollView 替换 self.view
 */
- (void)createBackScrollView;
/**
 键盘隐藏
 */
- (void)hideKeyBoard;

/**
 返回按钮事件
 */
- (void)respondToLeftButtonClickEvent;
/**
 右侧按钮事件
 */
- (void)respondToRigheButtonClickEvent;

/**
 获取当前时间

 @return return value description
 */
- (NSString*)getCurrentTimes;

/**
 比较时间大小
  1 oneDay比 anotherDay时间晚
 -1 oneDay比 anotherDay时间早
  0 两者时间是同一个时间
 @return return value description
 */
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//删除字典里的null值
- (NSDictionary *)deleteEmpty:(NSDictionary *)dic;
//删除字典数组里的null值
- (NSArray *)deleteEmptyArr:(NSArray *)arr;
//导航栏下划线
- (UIImageView *)findNavBarBottomLine:(UIView *)view;
//前往聊天页面
- (void)gotochatVcWithconversationType:(RCConversationType)type andTitle:(NSString *)title targetId:(NSString *)taggetid;

@end
