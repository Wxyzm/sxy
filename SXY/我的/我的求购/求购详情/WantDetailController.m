//
//  WantDetailController.m
//  SXY
//
//  Created by yh f on 2018/12/25.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "WantDetailController.h"
#import "WantBuyModel.h"
#import "HUPhotoBrowser.h"

@interface WantDetailController ()

@end

@implementation WantDetailController{
    
    WantBuyModel *_model;
    NSMutableArray *_imaArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求购详情";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _imaArr = [NSMutableArray arrayWithCapacity:0];
    [self loadDetail];
}



- (void)loadDetail{
    NSDictionary *dic = @{@"id":_wantID};
    [CirclePL Circle_CircleFindCircleByIdDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _model = [WantBuyModel mj_objectWithKeyValues:returnValue];
        [self initUIWithWantBuyModel:_model];
    } withErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)initUIWithWantBuyModel:(WantBuyModel *)model{
    
    UILabel * titleLab= [BaseViewFactory labelWithFrame:CGRectMake(33, 30, ScreenWidth- 66, 23) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:model.title];
    [self.view addSubview:titleLab];
    
    UILabel *timeLab= [BaseViewFactory labelWithFrame:CGRectMake(90, 57, ScreenWidth- 32-90, 14) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:model.expirationtime];
    [self.view addSubview:timeLab];
    
   UIImageView * markIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lable_jinzhichixianhuo"]];
    [self.view addSubview:markIma];
    markIma.frame = CGRectMake(32, 57, 60, 14);
    if (model.label.length<=0) {
        markIma.hidden = YES;
    }
    
    UILabel *detailLab=[BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:model.content];
    [self.view addSubview:detailLab];
    
    detailLab.sd_layout
    .leftSpaceToView(self.view , 32)
    .rightSpaceToView(self.view , 32)
    .topSpaceToView(timeLab, 23)
    .autoHeightRatio(0);
    
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];

    CGFloat _ImaW = (ScreenWidth - 64  -20)/3;
    CGFloat _ImaH = _ImaW;
    
    for (int i = 0; i<arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = UIColorFromRGB(BackColorValue);
        imageView.clipsToBounds = YES;
        [self.view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        [_imaArr addObject:imageView];
        int a = i/3;
        int b = i%3;
        
        imageView.sd_layout
        .leftSpaceToView(self.view, 21+(_ImaW +10)*b)
        .topSpaceToView(detailLab, 28+(_ImaH +10)*a)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
        
        NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES];
        [imageView sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"empty"]];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addSubview:touchBtn];
        [touchBtn addTarget:self action:@selector(touchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        touchBtn.tag = 2000 + i;
        touchBtn.frame = CGRectMake(0, 0, _ImaW, _ImaH);
        
        
    }
 
    
}


- (void)touchBtnClick:(UIButton *)btn{
    
    NSArray *arr = [_model.pictureName componentsSeparatedByString:@","];
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<arr.count; i++) {
        NSString *urlStr =[NSString stringWithFormat:@"%@", [GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES]];
        [imageUrlArr addObject:urlStr];
    }
    UIImageView *imageview = _imaArr[btn.tag - 2000];
    [HUPhotoBrowser showFromImageView:imageview withURLStrings:imageUrlArr placeholderImage:imageview.image atIndex:btn.tag - 2000 dismiss:^(UIImage *image, NSInteger index) {
    }];
    
}


@end
