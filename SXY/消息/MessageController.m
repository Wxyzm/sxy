//
//  MessageController.m
//  SXY
//
//  Created by yh f on 2018/11/8.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MessageController.h"

#import "MineInfoModel.h"
@interface MessageController ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,RCIMGroupInfoDataSource>

@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
//        [GlobalMethod connectRongCloudWithToken:returnValue];
//    } andErrorBlock:^(NSString *msg) {
//
//    }];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.translucent = NO;
    //设置要显示的会话 return completion(nil);
    [self setDisplayConversationTypes:@[ @(ConversationType_PRIVATE),
                                         @(ConversationType_DISCUSSION),
                                         @(ConversationType_GROUP),
                                         @(ConversationType_SYSTEM)]];
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                           @(ConversationType_GROUP)]];
    [self cteatenavigationBar];
    //设置代理跟监听
    [self setDelegateAndNot];
    [self initUI];
    
    
    
}


- (void)setDelegateAndNot{
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChatListShouldRefresh)
     name:RCChatListShouldRefresh
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChatListUserShouldRefresh:)
     name:RCChatListUserShouldRefresh
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChatListGroupShouldRefresh:)
     name:RCChatListGroupShouldRefresh
     object:nil];
    
}

- (void)initUI{
    
    self.conversationListTableView.backgroundColor = UIColorFromRGB(BackColorValue);
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //当网络断开时，是否在Tabel View Header中显示网络连接不可用的提示。
    self.isShowNetworkIndicatorView = YES;
    
    
}


#pragma MARK ===== NAVIGATIONBAR

- (void)cteatenavigationBar{
    
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"聊天"];
    self.navigationItem.titleView = titlelab;
   
}


#pragma mark ======= 融云代理

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    [self refreshConversationTableViewIfNeeded];
}

//获取用户数据,设置头像昵称等
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    if (![[UserPL shareManager] userIsLogin]) {
        return;
    }
    if ([userId length] == 0) return;
   // User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"id":userId};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        MineInfoModel *model = [MineInfoModel mj_objectWithKeyValues:returnValue[@"result"]];
        RCUserInfo *user = [[RCUserInfo alloc] init];
        user.userId = userId;
        user.name = model.name;
        user.portraitUri =[NSString stringWithFormat:@"%@",[GlobalMethod returnUrlStrWithImageName:model.photo andisThumb:YES]];
        return completion(user);
        
    } andErrorBlock:^(NSString *msg) {
        return completion(nil);
        
    }];
}

-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
   
    
}



/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        User *user = [[UserPL shareManager] getLoginUser];
        if ( [user.userId isEqualToString:[NSString stringWithFormat:@"%@",model.targetId]]   ) {
            [HUD show:@"您不能跟自己聊天对话哦"];
            
            return ;
        }

        ChatViewController *_conversationVC = [[ChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
}



#pragma mark =============    通知

- (void)ChatListShouldRefresh{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self refreshConversationTableViewIfNeeded];
}


/*
 dic= @{@"name":@""
 @"userId":@""
 }
 */
- (void)ChatListUserShouldRefresh:(NSNotification*)notificaition{
    NSDictionary *dic = notificaition.userInfo;
    //    RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:dic[@"userId"]];
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.name = dic[@"name"];
    user.userId = dic[@"userId"];
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
    [self.conversationListTableView reloadData];
}

/*
 dic= @{@"groupName":@""
 @"groupId":@""
 }
 */
- (void)ChatListGroupShouldRefresh:(NSNotification*)notificaition{
    NSDictionary *dic = notificaition.userInfo;
    //    RCGroup *group = [[RCIM sharedRCIM]getGroupInfoCache:dic[@"groupId"]];
    RCGroup *group = [[RCGroup alloc]init];
    
    group.groupName = dic[@"groupName"];
    group.groupId = dic[@"groupId"];
    [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:group.groupId];
    [self.conversationListTableView reloadData];
}


@end
