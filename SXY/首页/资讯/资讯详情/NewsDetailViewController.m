//
//  NewsDetailViewController.m
//  SXY
//
//  Created by yh f on 2019/1/3.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "CommitListController.h"
#import "NewsModel.h"
#import "CommentModel.h"
#import "NewsCommView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>

@interface NewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *replyTab;

@property (nonatomic,strong)UIView *commView;

@property (nonatomic,strong)NewsCommView *NewsCommView;

@property (nonatomic,strong) AVPlayerViewController *moviePlayerView;


@end

@implementation NewsDetailViewController{
    
    UILabel *_titleLab;
    UILabel *_timeLab;
    YLButton *_seeNumBtn;
    YLButton *_shareNumBtn;
    YLButton *_replyNumBtn;
    UIImageView *_faceIma;
    UIImageView *_playIma;
    UITextField *_commTxt;
    
    UILabel *_contLab;
    YLButton *_shareBtn;
    NewsModel *_model;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    [self loadNewsDetail];
    

}

#pragma mark ====== 获取资讯、评论数据

- (void)loadNewsDetail{
    NSDictionary *dic = @{@"id":_newsId};
    [NewsPL News_NewsFindNewsByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NewsModel *model = [NewsModel mj_objectWithKeyValues:returnValue];
        _model = model;
        [self initNewsDetailWithNewsModel:model];
        [self loadComment];
    } andErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)loadComment{
    
    NSDictionary *dic = @{@"objectId":_newsId};
    [CommentPL Comment_CommentGetNewsCommentListWithDic:dic withReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSMutableArray *dataArr = [CommentModel mj_objectArrayWithKeyValuesArray:returnValue];
        self.NewsCommView.dataArr = dataArr;
        CGFloat ViewHeight = [NewsCommView ViewHeightWithArr:dataArr];
        self.NewsCommView.sd_layout
        .leftSpaceToView(self.backView, 0)
        .rightSpaceToView(self.backView, 0)
        .topSpaceToView(_shareBtn, 10)
        .heightIs(ViewHeight);
        CGFloat h = self.NewsCommView.top_sd+self.NewsCommView.height_sd;
        if (self.NewsCommView.top_sd+self.NewsCommView.height_sd<ScreenHeight - NaviHeight64-50) {
            NSLog(@"%f",h);
            self.backView.contentSize = CGSizeMake(10, ScreenHeight - NaviHeight64-50);
        }else{
            [self.backView setupAutoContentSizeWithBottomView:self.NewsCommView bottomMargin:20];

        }
       

    } andErrorBlock:^(NSString *msg) {
        
    }];
}






- (void)initNewsDetailWithNewsModel:(NewsModel *)model{
    
    [self createBackScrollView];
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NaviHeight64 -84);
    [self.view addSubview:self.commView];
    
    _titleLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:model.title];
    
    _timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:[GlobalMethod returndetailTimeStrWith:model.addTime]];
    
    _seeNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(seeNumBtnCLick) titleFont:APPFONT12 title:model.clickCount.length>0?model.clickCount:@"0"];
    [_seeNumBtn setImage:[UIImage imageNamed:@"information_view"] forState:UIControlStateNormal];
    [_seeNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_seeNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    
    _shareNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(shareNumBtnCLick) titleFont:APPFONT12 title:model.shareCount.length>0?model.shareCount:@"0"];
    [_shareNumBtn setImage:[UIImage imageNamed:@"information_share"] forState:UIControlStateNormal];
    [_shareNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_shareNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    _replyNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(replyNumBtnCLick) titleFont:APPFONT12 title:model.commentCount.length>0?model.commentCount:@"0"];
    [_replyNumBtn setImage:[UIImage imageNamed:@"information_comments"] forState:UIControlStateNormal];
    [_replyNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_replyNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    _faceIma = [[UIImageView alloc] init];
    _faceIma.backgroundColor = [UIColor lightGrayColor];
    _faceIma.contentMode = UIViewContentModeScaleToFill;
    _faceIma.clipsToBounds = YES;
    _faceIma.userInteractionEnabled = YES;
    _faceIma.layer.cornerRadius = 4;
    _faceIma.frame = CGRectZero;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    NSString *url = @"";
    if (arr>0) {
        url = arr[0];
    }
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"faceempty"]];
    
    _playIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play_big"]];
    _playIma.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [_playIma addGestureRecognizer:tapGesture];
    
    
    [_faceIma addSubview:_playIma];
    if (model.newsUrl.length>0) {
        _playIma.hidden = NO;
    }else{
        _playIma.hidden = YES;
    }
    
    
    _contLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:model.context];
    
    _shareBtn= [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(BlackColorValue) cornerRadius:0 andtarget:self action:@selector(rshareBtnCLick) titleFont:APPFONT14 title:@"分享"];
    [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_shareBtn setImageRect:CGRectMake(0, 1, 18, 18)];
    [_shareBtn setTitleRect:CGRectMake(28, 0, 30, 20)];

    
    [self.backView sd_addSubviews:@[_titleLab,_timeLab,_seeNumBtn,_shareNumBtn,_replyNumBtn,_faceIma,_contLab,_shareBtn,self.NewsCommView]];
    // scrollview自动contentsize
    
    [self refreshView];
    
}






#pragma mark ====== 布局
- (void)refreshView{
    
    _titleLab.sd_layout
    .leftSpaceToView(self.backView, 20)
    .topSpaceToView(self.backView, 20)
    .rightSpaceToView(self.backView, 20)
    .autoHeightRatio(0);
    
    _timeLab.sd_layout
    .leftSpaceToView(self.backView, 23)
    .topSpaceToView(_titleLab, 14)
    .rightSpaceToView(self.backView, 20)
    .heightIs(17);
    
    _replyNumBtn.sd_layout
    .rightSpaceToView(self.backView, 16)
    .topEqualToView(_timeLab)
    .widthIs(52)
    .heightIs(20);
    
    
    _shareNumBtn.sd_layout
    .rightSpaceToView(_replyNumBtn, 20)
    .topEqualToView(_timeLab)
    .widthIs(52)
    .heightIs(20);
    
    _seeNumBtn.sd_layout
    .rightSpaceToView(_shareNumBtn, 20)
    .topEqualToView(_timeLab)
    .widthIs(52)
    .heightIs(20);
    
    _faceIma.sd_layout
    .leftSpaceToView(self.backView, 16)
    .topSpaceToView(_timeLab, 26)
    .rightSpaceToView(self.backView, 16)
    .heightIs(120);
    
    _playIma.sd_layout
    .centerXEqualToView(_faceIma)
    .centerYEqualToView(_faceIma)
    .widthIs(30)
    .heightIs(30);
    
    _contLab.sd_layout
    .leftSpaceToView(self.backView, 16)
    .topSpaceToView(_faceIma, 20)
    .rightSpaceToView(self.backView, 20)
    .autoHeightRatio(0);

    _shareBtn.sd_layout
    .topSpaceToView(_contLab, 10)
    .rightSpaceToView(self.backView, 20)
    .heightIs(20)
    .widthIs(58);
    
    
    

    
}




#pragma mark ====== 点击分享回复数量

- (void)seeNumBtnCLick{
    
    
}

- (void)shareNumBtnCLick{
    
    
}

- (void)replyNumBtnCLick{
    
    
    
}

/**
 分享
 */
- (void)rshareBtnCLick{
    
    
    
}

#pragma mark ====== 评论
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length<=0) {
        return NO;
    }
    [textField resignFirstResponder];
    [self sendNewsComment];
    return YES;
}


- (void)sendNewsComment{
  
    NSDictionary *comDic = @{@"content":_commTxt.text,
                             @"objectId":_newsId
                             };
    [CommentPL Comment_CommentSaveNewsCommentWithDic:comDic withReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _commTxt.text = @"";
        [self loadComment];
    } andErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
}

- (void)moreBtnClick{
    
    CommitListController *comVc = [[CommitListController alloc]init];
    comVc.newsId = _newsId;
    [self.navigationController pushViewController:comVc animated:YES];
}


//图片点击
- (void)singleTapAction:(UITapGestureRecognizer *)gest{
   
    NSURL *url= [NSURL URLWithString:_model.newsUrl];
    if (!_moviePlayerView) {
        self.moviePlayerView = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        self.moviePlayerView.player = player;
        //设置界面缩放比例
        self.moviePlayerView.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    [self presentViewController:self.moviePlayerView animated:YES completion:NULL];
    [self.moviePlayerView.player play];
}





#pragma mark ====== get
-(UITableView *)replyTab{
    
    if (!_replyTab) {
        _replyTab = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _replyTab.scrollEnabled = NO;
        _replyTab.delegate = self;
        _replyTab.dataSource = self;
        _replyTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _replyTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _replyTab.estimatedRowHeight = 0;
        _replyTab.sectionHeaderHeight = 0.01;
        _replyTab.sectionFooterHeight = 0.01;
//        _replyTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
//        _replyTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _replyTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _replyTab;
    
    
}


-(UIView *)commView{
    if (!_commView) {
        _commView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64 - 84, ScreenWidth, 84) color:UIColorFromRGB(WhiteColorValue)];
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
        [_commView addSubview:line];
        
        _commTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(16, 20, ScreenWidth-32, 44) font:APPFONT14 placeholder:@"写跟帖" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
        _commTxt.backgroundColor = UIColorFromRGB(BackColorValue);
        [_commView addSubview:_commTxt];
        _commTxt.layer.cornerRadius = 22;
        _commTxt.leftViewMode = UITextFieldViewModeAlways;
        _commTxt.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        _commTxt.returnKeyType = UIReturnKeySend;
        
    }
    
    return _commView;
    
}


-(NewsCommView *)NewsCommView{
    
    if (!_NewsCommView) {
        _NewsCommView = [[NewsCommView alloc]init];
        [_NewsCommView.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _NewsCommView;
    
}


@end
