//
//  TopicDetailController.m
//  SXY
//
//  Created by yh f on 2019/1/16.
//  Copyright © 2019 XX. All rights reserved.
//

#import "TopicDetailController.h"
#import "LBNavigationController.h"
#import "TopicDeTopCell.h"
#import "HUPhotoBrowser.h"
#import "CommentCell.h"
#import <UShareUI/UShareUI.h>
#import "UIButton+WebCache.h"
#import "IQKeyboardManager.h"

@interface TopicDetailController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic,strong)BaseTableView *ListTab;
@property (nonatomic, strong) UIScrollView *inputScrollVie;
@property (nonatomic,strong)UIView *commView;

@end

@implementation TopicDetailController{
    
    WantBuyModel *_model;
    NSMutableArray *_imaArr;
    UITextField *_commTxt;

}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    _imaArr = [NSMutableArray arrayWithCapacity:0];
    [self initUI];

    [self loadDetail];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self loadDetail];
    
}


- (void)loadDetail{
    
    NSDictionary *dic = @{@"id":_topId};
    [CirclePL Circle_CircleFindCircleByIdDic:dic WithReturnBlock:^(id returnValue) {
        _model = [WantBuyModel mj_objectWithKeyValues:returnValue];
        if (!_model) {
            return;
        }
        [self.ListTab reloadData];

    } withErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)initUI{
    [self.view addSubview:self.ListTab];
    
   
    if (!_faceIma&&!_faceImaStr){
         return;
    }
    YLButton* button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    if (_faceIma) {
        [button setImage:_faceIma forState:UIControlStateNormal];

    }else if (_faceImaStr){
        [button sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:_faceImaStr andisThumb:YES] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"faceempty"]];
    }
    [button addTarget:self action:@selector(respondToRigheButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(0, 0, 32, 32)];
    button.layer.cornerRadius = 16;
    UIView *leftCustomView = [[UIView alloc] initWithFrame: button.frame];
    [leftCustomView addSubview: button];
    leftCustomView.layer.cornerRadius = 16;
    leftCustomView.clipsToBounds = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftCustomView];
    self.navigationItem.rightBarButtonItem = item;
    _inputScrollVie = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _inputScrollVie.delegate = self;
    //_inputScrollVie.scrollEnabled = NO;
    _inputScrollVie.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+200);
    [self.view addSubview:_inputScrollVie];
    [_inputScrollVie addSubview:self.commView];
    _inputScrollVie.hidden = YES;
    _inputScrollVie.backgroundColor = [UIColor clearColor];
}
    
    
- (void)faceClick{
    
    [self gotoUserStockWithID:_userId];
}



#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _model.commentDTOList.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return [TopicDeTopCell cellHeightWithModel:_model];
    }
    
    CommentModel *model =  _model.commentDTOList[indexPath.row-1];
    return [CommentCell cellHeightWithModel:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *topCellId= @"topCellId";
        TopicDeTopCell  *cell = [tableView dequeueReusableCellWithIdentifier:topCellId];
        if (!cell) {
            cell = [[TopicDeTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellId];
        }
        cell.detailModel = _model;
        cell.returnBlock = ^(WantBuyModel * _Nonnull model, NSInteger btnTag, TopicDeTopCell * _Nonnull thecell) {
            if (btnTag == 0) {
                [self zanBtnCLickWithModel:model];
            }else if (btnTag == 1){
                [self shareBtnCLickWithModel:model];
                
            }else if (btnTag == 2){
                [_commTxt becomeFirstResponder];
                
            }else{
                [self checkBigImageWithCell:thecell andtag:btnTag - 1000 andModel:model];
                
            }
        };
       
        return cell;
    }
    
    static NSString *HomeMenueCellId= @"HomeMenueCellID";
    CommentCell  *cell = [tableView dequeueReusableCellWithIdentifier:HomeMenueCellId];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeMenueCellId];
    }
    cell.agreeBtn.hidden = YES;
    CommentModel *model =  _model.commentDTOList[indexPath.row-1];
    cell.model = model;
    cell.returnBlock = ^(CommentModel *model) {
        [self gotoUserStockWithID:model.userId];
    };
    return cell;
}

#pragma mark ======= 点赞、分享、回复

/**
 点赞
 */
- (void)zanBtnCLickWithModel:(WantBuyModel *)model{
    NSDictionary *dic = @{@"id":model.theID};
    [CollectPL Collect_CollectSaveTopicZanWithDic:dic WithReturnBlock:^(id returnValue) {
        model.izan = !model.izan;
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
}


/**
 分享
 */
- (void)shareBtnCLickWithModel:(WantBuyModel *)model{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
   
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
        
    }];
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
   
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = @"http://cdn.fyh88.com/upload_development/1-fb36c92d90b87da62e20db9ba1457264.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"搜绣云.绣花供应链服务平台" descr:@"了解绣花上下游行业相关的时尚资讯，为企业“去库存，找工厂，找订单，找辅料，找设备，找花型 ”，提升行业竞争力" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        // [self alertWithError:error];
    }];
}



#pragma mark ==== 前往用户店铺
- (void)gotoUserStockWithID:(NSString *)userId{
    if (!userId) {
        return;
    }
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = userId;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (void)respondToRigheButtonClickEvent{
    [self gotoUserStockWithID:_userId];
}

//查看大图

- (void)checkBigImageWithCell:(TopicDeTopCell *)cell andtag:(NSInteger)tag andModel:(WantBuyModel*)model{
    NSMutableArray *imageArr =[NSMutableArray arrayWithCapacity:0];
    NSArray *arr;
    if (model.pictureName.length>0) {
        arr = [model.pictureName componentsSeparatedByString:@","];
    }
    NSInteger a = arr.count;
    if (arr.count>3) {
        a = 3;
    }else if (arr.count<=0){
        return;
    }
    for (int i = 0; i<a; i++) {
        [imageArr addObject:[NSString stringWithFormat:@"%@",[GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES]]];
    }
    UIImageView *plaIma = cell.ImaArr[tag];
    [HUPhotoBrowser showFromImageView:plaIma withURLStrings:imageArr placeholderImage:plaIma.image atIndex:tag dismiss:^(UIImage *image, NSInteger index) {
        
    }];
    
}



#pragma mark ==== 发布评论

- (void)sentReply{
    [HUD showLoading:nil];
    NSDictionary *dic = @{@"content":_commTxt.text,
                          @"objectId":_model.theID
                          };
    [CommentPL Comment_CommentSaveCircleCommentWithDic:dic withReturnBlock:^(id returnValue) {
        [self loadTopicCommitsWithID:_model.theID];
    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
}
#pragma mark ==== 获取单个话题的评论
- (void)loadTopicCommitsWithID:(NSString *)topId{
    NSDictionary *dic = @{@"objectId":topId};
    [CommentPL Comment_CommentGetCircleCommentListWithDic:dic withReturnBlock:^(id returnValue) {
        NSArray *comArr = [CommentModel mj_objectArrayWithKeyValuesArray:returnValue];
        _model.commentDTOList = comArr;
        [self.ListTab reloadData];
        [HUD show:@"回复成功"];
        [HUD cancel];
        
    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];
        
    }];
    
    
    
}

#pragma mark ========= teftField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _inputScrollVie.hidden = NO;
    textField.text = @"";
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _inputScrollVie.hidden = YES;
    _inputScrollVie.scrollEnabled = YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_commTxt.text.length<=0) {
        [HUD show:@"请输入您评论内容"];
        return NO;
    }
    [_commTxt resignFirstResponder];
    [self sentReply];
    
    return YES;
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _inputScrollVie) {
        [_commTxt resignFirstResponder];
        _inputScrollVie.hidden = YES;
    }
    
}



#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NaviHeight64) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}

-(UIView *)commView{
    if (!_commView) {
        _commView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64 - 84, ScreenWidth, 84) color:UIColorFromRGB(WhiteColorValue)];
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
        [_commView addSubview:line];
        
        _commTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(16, 20, ScreenWidth-32, 44) font:APPFONT14 placeholder:@"写回复" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
        _commTxt.backgroundColor = UIColorFromRGB(BackColorValue);
        [_commView addSubview:_commTxt];
        _commTxt.layer.cornerRadius = 22;
        _commTxt.leftViewMode = UITextFieldViewModeAlways;
        _commTxt.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        _commTxt.returnKeyType = UIReturnKeySend;
    }
    
    return _commView;
    
}
@end
