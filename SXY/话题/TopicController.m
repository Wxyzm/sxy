//
//  TopicController.m
//  SXY
//
//  Created by yh f on 2018/11/8.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "TopicController.h"
#import "TopicDetailController.h"
#import "IssueTopicController.h"
#import "WantBuyModel.h"
#import "CircleComCell.h"
#import <UShareUI/UShareUI.h>
#import "TopicDeTopCell.h"
#import "LBNavigationController.h"
#import "IQKeyboardManager.h"
@interface TopicController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>


@property (nonatomic, strong) BaseTableView *ListTab;

@property (nonatomic, strong) UIScrollView *inputScrollVie;


@property (nonatomic,strong)UIView *commView;


@end

@implementation TopicController{
    
    NSMutableArray *_dataArr;
   // UITextView *_memoTxt;
    CGFloat _Lastheight;
    UITextField *_commTxt;
    WantBuyModel *_commModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadList];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self reloadListDatas];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    
}

- (void)initUI{
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    UIImageView *issueIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topic_compile_yellow"]];
    [self.view addSubview:issueIma];
    issueIma.frame = CGRectMake(28, 17, 18, 18);
    
    [self createRightNavigationItemWithImage:@"topic_compile"];
    [self.view addSubview:self.ListTab];
    
    
    _inputScrollVie = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _inputScrollVie.delegate = self;
    //_inputScrollVie.scrollEnabled = NO;
    _inputScrollVie.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+200);
    [self.view addSubview:_inputScrollVie];
    [_inputScrollVie addSubview:self.commView];
    _inputScrollVie.hidden = YES;
    _inputScrollVie.backgroundColor = [UIColor clearColor];

    
}
#pragma mark ====== 发布话题
-(void)respondToRigheButtonClickEvent{
    IssueTopicController *issVC = [[IssueTopicController alloc]init];
    [self.navigationController pushViewController:issVC animated:YES];
}

- (void)reloadListDatas{
    
    [self loadList];
}

/*
 "isExpiration": "false:非过期广播 true:已过期广播",
 "id": "id",
 "title": "标题（模糊）",
 "userId": "用户id",
 "content": "内容（模糊）",
 "goodsModules": "0：求购 1：现货  2：供应链   3：话题",
 "status": "审核 0：未审核，1：审核中 2：审核不通过 3：审核通过"
 */

- (void)loadList{
    
    NSDictionary *dic = @{@"isExpiration":@"false",
                          @"goodsModules":@[@"3"],
                          @"status":@"3",
                          @"id":@"",
                          @"title":@"",
                          @"userId":@"",
                          @"content":@""
                          
                          };
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _dataArr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self .ListTab reloadData];
        [self .ListTab.mj_header endRefreshing];
    } withErrorBlock:^(NSString *msg) {
        [self .ListTab.mj_header endRefreshing];

    }];
  
}




#pragma mark ====== tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [CircleComCell cellHeightWithModel:_dataArr[indexPath.row]];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    CircleComCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CircleComCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _dataArr[indexPath.row];
    cell.returnBlock = ^(WantBuyModel *model, NSInteger tag, CircleComCell *thecell) {
        if (tag == 0) {
            //点赞
            [self zanBtnCLickWithModel:model];
        }else if (tag == 1){
            //分享
            [self shareBtnCLickWithModel:model];
        }else if (tag == 2){
            //回复
            [_commTxt becomeFirstResponder];
            NSInteger row = [_dataArr indexOfObject:model];
            _commModel = model;
            [self.ListTab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if (tag == 3){
            //头像
            [self gotoUserStockWithID:model.userId];
        }else if (tag == 4){
            //查看更多
            TopicDetailController *deVc = [[TopicDetailController alloc]init];
            deVc.topId = model.theID;
            deVc.userId = model.userId;
            deVc.title = model.userName;
            deVc.faceIma = thecell.faceIma.image;
            [self.navigationController pushViewController:deVc animated:YES];
        }
        else{
            [self checkBigImageWithCell:thecell andtag:tag-1000 andModel:model];
        }
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
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


#pragma mark ==== 查看大图
- (void)checkBigImageWithCell:(CircleComCell *)cell andtag:(NSInteger)tag andModel:(WantBuyModel*)model{
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





#pragma mark ==== 前往用户店铺
- (void)gotoUserStockWithID:(NSString *)userId{
    
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = userId;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:homeVc animated:YES];
}
#pragma mark ==== 联系
- (void)gotochatVcWithWantBuyModel:(WantBuyModel *)model{
    if ([GlobalMethod userIdifSelfId:model.userId]) {
        [HUD show:@"您不能跟自己通话"];
        return;
    }
    [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:model.userName targetId:model.userId];

  

}

#pragma mark ==== 发布评论

- (void)sentReply{
    [HUD showLoading:nil];
    NSDictionary *dic = @{@"content":_commTxt.text,
                          @"objectId":_commModel.theID
                          };
    [CommentPL Comment_CommentSaveCircleCommentWithDic:dic withReturnBlock:^(id returnValue) {
        [self loadTopicCommitsWithID:_commModel.theID];
    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
}
#pragma mark ==== 获取单个话题的评论
- (void)loadTopicCommitsWithID:(NSString *)topId{
    NSDictionary *dic = @{@"objectId":topId};
    [CommentPL Comment_CommentGetCircleCommentListWithDic:dic withReturnBlock:^(id returnValue) {
        NSArray *comArr = [CommentModel mj_objectArrayWithKeyValuesArray:returnValue];
        _commModel.commentDTOList = comArr;
        [self.ListTab reloadData];
        [HUD show:@"回复成功"];
        [HUD cancel];

    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];

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


#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64-TABBAR_HEIGHT) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        //        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}

//-(void)textViewDidChange:(UITextView *)textView{
//
//    float textViewHeight =  [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
//    if (_Lastheight ==0) {
//        _Lastheight = textViewHeight;
//        return;
//    }
//    CGRect frame = textView.frame;
//    frame.size.height = textViewHeight;
//    CGFloat offY = textViewHeight - _Lastheight;
//    frame.origin.y -=offY;
//
//    _Lastheight = textViewHeight;
//
//
//    textView.frame = frame;
//}
//
//
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    [manager setKeyboardDistanceFromTextField:10];
//    return YES;
//}
//
//-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
//
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    [manager setKeyboardDistanceFromTextField:20];
//    return YES;
//}


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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
    
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _inputScrollVie) {
        [_commTxt resignFirstResponder];
        _inputScrollVie.hidden = YES;
    }
    
}


@end

