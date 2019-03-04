//
//  BaseViewController.m
//  DaMinEPC
//
//  Created by yh f on 2017/12/5.
//  Copyright © 2017年 XX. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController{
    
    CGPoint  _beginPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(BackColorValue);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.isBlackStatusBar = YES;
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addGestureRecognizer:tapGr];
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    _nothingIma = [[UIView alloc]init];
    UIImageView *imaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty"]];
    [_nothingIma addSubview:imaView];
    UILabel *noLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 106, 106, 20) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentCenter andtext:@"什么都没有"];
    [_nothingIma addSubview:noLab];
    [self.view addSubview:_nothingIma];
    _nothingIma.hidden = YES;
    _nothingIma.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(106)
    .heightIs(126);
}

// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    if (_beginPoint.x>50) {
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    _beginPoint= point;
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(BlackColorValue), NSFontAttributeName:APPFONT18}];
    if (_isBlackStatusBar) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    
    if (!self.needHideNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}


- (void)hideBarbackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(hideBackBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    left.title = @"";
    self.navigationItem.leftBarButtonItem = left;
}



- (void)hideBackBtnPress {
}

- (void)setBarBackBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"nav_icon_back_btn"];
    } else {
        backImg = image;
    }
    CGFloat height = 17;
    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    YLButton* button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(0, 11, width, height)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = left;
}


#pragma mark -是否只包含数字，小数点，负号

-(BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string{
    
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filter=[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filter];
    
}

- (void)createRightNavigationItemWithImage:(NSString *)imageName
{
    UIBarButtonItem *item = [BaseViewFactory barItemWithImagePath:imageName height:18 target:self action:@selector(respondToRigheButtonClickEvent)];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)setRightBtnWithTitle:(NSString *)title andColor:(UIColor*)color{
    
    UIButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(respondToRigheButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
    
}

- (void)setLeftBtnWithTitle:(NSString *)title andColor:(UIColor*)color{
    UIButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = choiceCityBtn;
    
}



//用scrollView 替换 self.view
- (void)createBackScrollView
{
    _backView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64)];
    _backView.backgroundColor = UIColorFromRGB(BackColorValue);
    _backView.bounces = YES;
    [self.view addSubview: _backView];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    [_backView addGestureRecognizer:tapGr];
}

- (void)hideKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//返回按钮  如需其他操作  重写即可
- (void)respondToLeftButtonClickEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondToRigheButtonClickEvent{
    
    
    
}


- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}


-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
    
}

//删除字典里的null值
- (NSDictionary *)deleteEmpty:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    for (id obj in mdic.allKeys)
    {
        id value = mdic[obj];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:value];
            [dicSet setObject:changeDic forKey:obj];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:value];
            [arrSet setObject:changeArr forKey:obj];
        }
        else
        {
            if ([value isKindOfClass:[NSNull class]]) {
                [set addObject:obj];
            }
        }
    }
    for (id obj in set)
    {
        mdic[obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        mdic[obj] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        mdic[obj] = arrSet[obj];
    }
    
    return mdic;
}

//删除数组中的null值
- (NSArray *)deleteEmptyArr:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    
    for (id obj in marr)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:obj];
            NSInteger index = [marr indexOfObject:obj];
            [dicSet setObject:changeDic forKey:@(index)];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:obj];
            NSInteger index = [marr indexOfObject:obj];
            [arrSet setObject:changeArr forKey:@(index)];
        }
        else
        {
            if ([obj isKindOfClass:[NSNull class]]) {
                NSInteger index = [marr indexOfObject:obj];
                [set addObject:@(index)];
            }
        }
    }
    for (id obj in set)
    {
        marr[(int)obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = arrSet[obj];
    }
    return marr;
}


//导航栏下划线
- (UIImageView *)findNavBarBottomLine:(UIView *)view{
    if ([view isKindOfClass:[UIImageView class]]&&view.bounds.size.height<1) {
        return (UIImageView *)view;
    }
    for (UIView *subView in view.subviews) {
        UIImageView *imageView=[self findNavBarBottomLine:subView];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//前往聊天页面
- (void)gotochatVcWithconversationType:(RCConversationType)type andTitle:(NSString *)title targetId:(NSString *)taggetid{
    
    User *user = [[UserPL shareManager] getLoginUser];
    if ( [user.userId isEqualToString:taggetid]) {
        [HUD show:@"您不能跟自己聊天对话哦"];
        
        return ;
    }
    
    ChatViewController *_conversationVC = [[ChatViewController alloc]init];
    _conversationVC.conversationType =type;
    _conversationVC.targetId = taggetid;
    _conversationVC.title = title;
    _conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_conversationVC animated:YES];
}
@end
