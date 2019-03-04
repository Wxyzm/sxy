//
//  HomeMenueCell.m
//  SXY
//
//  Created by yh f on 2018/11/9.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "HomeMenueCell.h"
#import "SDCycleScrollView.h"
#import "HomePageControl.h"
#define BtnW (ScreenWidth-2*MaginX)/2-MaginX/4

@interface HomeMenueCell ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *bannerView;
@property (nonatomic,strong)HomePageControl *pageControl;


@end


@implementation HomeMenueCell{
    CGFloat _originY;
    UIImageView *_bgIma;
    UIImageView *_logoIma;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self setUP];
    }
    return self;
}



- (void)setUP{
    
    _bgIma= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STATUSBAR_HEIGHT +260)];
    [self.contentView addSubview:_bgIma];
    _bgIma.contentMode = UIViewContentModeScaleAspectFill;
    _bgIma.clipsToBounds = YES;
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, 280);
    visualEffectView.alpha = 0.7;
    [self.contentView addSubview:visualEffectView];
    _originY = STATUSBAR_HEIGHT+40;
    [self.contentView addSubview:self.bannerView];
    _originY += 170+20;

    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, 228+STATUSBAR_HEIGHT, ScreenWidth, 104) color:UIColorFromRGB(WhiteColorValue)];
    boomView.layer.cornerRadius = 12;
    [self.contentView addSubview:boomView];

    _logoIma = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, ScreenWidth-40, 64)];
    _logoIma.contentMode = UIViewContentModeScaleAspectFill;
    _logoIma.layer.cornerRadius = 5;
    _logoIma.clipsToBounds = YES;
    [boomView addSubview:_logoIma];
    
    UIButton *advBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [boomView addSubview:advBtn];
    [advBtn addTarget:self action:@selector(advBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    advBtn.frame = CGRectMake(20, 20, ScreenWidth-40, 64);
    
    UIButton *searchBtn = [BaseViewFactory buttonWithWidth:20 imagePath:@"home_search"];
    [self.contentView addSubview:searchBtn];
    searchBtn.frame = CGRectMake(ScreenWidth-44, STATUSBAR_HEIGHT+10, 20, 20);
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];


}

-(void)setCarouseArr:(NSArray *)CarouseArr{
    
    _CarouseArr = CarouseArr;
    if (CarouseArr.count<=0) {
        return;
    }
    NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:0];
    CarouseModel *smodel = CarouseArr[0];
    [_bgIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:smodel.pictureName andisThumb:YES] placeholderImage:nil];
    for (CarouseModel *model in CarouseArr) {
        NSURL *url = [GlobalMethod returnUrlStrWithImageName:model.pictureName andisThumb:YES];
        if ([model.ctype isEqualToString:@"1"]) {
            [urlArr addObject:[NSString stringWithFormat:@"%@",url]];
        }else{
            [_logoIma sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"adv"]];
        }
        
    }
    self.bannerView.imageURLStringsGroup = urlArr;
    self.pageControl.numberOfPages = urlArr.count;

    NSLog(@"%@",urlArr);
    
    
}

-(void)layoutSubviews{
    _pageControl.frame = CGRectMake(ScreenWidth/2-100, 214+STATUSBAR_HEIGHT, 200, 20);
}


- (void)searchBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(2001);
    }
    
}

- (void)advBtnCLick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(2000);
    }
    
}


//http://souxiu.emb-fashion.com/181121111955178000.jpg

+(CGFloat)cellHeight{
    return STATUSBAR_HEIGHT +350;
}


#pragma mark ===== SDCycleScrollViewdelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
        WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(1000+index);
    }
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectedCurrentImage:(UIImage *)image{
    _bgIma.image = image;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView starScrollWIthIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}


#pragma mark ===== get
-(SDCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(MaginX, _originY, ScreenWidth-2*MaginX, 170 ) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _bannerView.pageDotColor = UIColorFromRGB(BackColorValue);
        _bannerView.currentPageDotColor = UIColorFromRGB(RedColorValue);
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.delegate = self;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.showPageControl = NO;
    }
    return _bannerView;
}

-(HomePageControl *)pageControl{
    if (!_pageControl) {
        HomePageControl *pageControl = [[HomePageControl alloc] init];
        pageControl.pageIndicatorTintColor = UIColorFromRGB(WhiteColorValue);
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self.contentView addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

@end
