//
//  ChatViewController.m
//  SXY
//
//  Created by yh f on 2019/1/10.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "ChatViewController.h"
#import "MineInfoModel.h"

@interface ChatViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
}

#pragma mark ======= 融云代理
//获取用户数据,设置头像昵称等
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    if (![[UserPL shareManager] userIsLogin]) {
        return;
    }
    if ([userId length] == 0) return;
  //  User *user = [[UserPL shareManager] getLoginUser];
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
    
    NSLog(@"groupId ==== %@",groupId);
    
    
}
@end
