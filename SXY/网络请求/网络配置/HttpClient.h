//
//  HttpClient.h
//  ZhongFangTong
//
//  Created by apple on 2018/6/5.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


// NetWorkReturn
typedef void (^PLReturnValueBlock) (id returnValue);
typedef void (^PLErrorCodeBlock) (NSString *msg);

typedef void (^ReturnBlock) (id returnValue);      //网络请求成功
typedef void (^ErrorBlock) (NSString *msg);

@interface HttpClient : NSObject

+ (HttpClient *)sharedHttpClient;




#pragma mark   ========== Config

//get方式获取
- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
    success:(void(^)(NSDictionary *resultDic))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

//post方式获取
- (void)POST:(NSString *)url
        dict:(NSDictionary *)dict
     success:(void(^)(NSDictionary *resultDic))successBlock
     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

//json解析
+ (id)valueWithJsonString:(NSString *)jsonString;

///souxiu/agreement/base/findAgreement
#pragma mark   ========== 获取用户协议
-(void)UsergetFindAgreementWithReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock;
//////////////////////////////////////用户/////////////////////////////////
#pragma mark   ========== 获取验证码（注册）
-(void)UsergetRegVerificationCodeDic:(NSDictionary *)dic
                     WithReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 手机号登陆，没有注册，直接注册掉
-(void)UsergetLoginByPhoneDic:(NSDictionary *)dic
                    WithReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock;


//////////////////////////////////////首页/////////////////////////////////
#pragma mark   ========== 获取首页
-(void)HomegetHomeListWithDic:(NSDictionary *)dic
              WithReturnBlock:(ReturnBlock)returnBlock
                andErrorBlock:(ErrorBlock)errorBlock;

//////////////////////////////////////文件上传/////////////////////////////////
#pragma mark   ========== 文件上传
-(void)SystemBaseFileUpload:(NSDictionary *)dic
            WithReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock;


//////////////////////////////////////商品/////////////////////////////////

#pragma mark   ========== 发布/编辑商品
-(void)GoodsSaveGoodsWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 删除商品
-(void)GoodsDeleteGoodsWithDic:(NSDictionary *)dic
               WithReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取商品列表
-(void)GoodsGetGoodsListWithDic:(NSDictionary *)dic
                WithReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取商品详情
-(void)GoodsFindGoodsByIdWithDic:(NSDictionary *)dic
                WithReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== //////////////////////////////////////类别////////////////////////////////////////

#pragma mark   ========== 获取类别详情
-(void)CategoryFindCategoryByIdWithDic:(NSDictionary *)dic
                 WithReturnBlock:(ReturnBlock)returnBlock
                   andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 获取类别列表
-(void)CategoryGetCategoryListWithDic:(NSDictionary *)dic
                      WithReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取类别列表(根据parentId)
-(void)CategoryGetCategoryListByParentIdWithDic:(NSDictionary *)dic
                                WithReturnBlock:(ReturnBlock)returnBlock
                                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取幅宽
-(void)CategoryGetClothWidthListWithDic:(NSDictionary *)dic
                        WithReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取成分
-(void)CategoryGetComponentListWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取品类标签
-(void)CategoryGetGoodsClassListWithDic:(NSDictionary *)dic
                        WithReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ==========  获取单位
-(void)CategoryGetUnitListWithDic:(NSDictionary *)dic
                  WithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 获取供应链类目列表
-(void)CategoryGetUserKindListWithDic:(NSDictionary *)dic
                      WithReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ==========获取有效时间
-(void)CategoryGetVailddaysListWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 删除类别
-(void)CategorydeleteCategoryWithDic:(NSDictionary *)dic
                     WithReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 删除个人自定义的类别
-(void)CategorydeleteUserCategoryWithDic:(NSDictionary *)dic
                         WithReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 发布/编辑类别(后台)
#pragma mark   ========== 发布/编辑个人的自定义标签
-(void)CategorysaveUserCategoryWithDic:(NSDictionary *)dic
                         WithReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock;


//////////////////////////////////////广播/////////////////////////////////

#pragma mark   ========== 获取广播详情
- (void)CircleFindCircleByIdDic:(NSDictionary *)dic
                WithReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 获取广播列表
- (void)CircleGetCircleListWithDic:(NSDictionary *)dic
                   WithReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 删除广播
- (void)CircleDeleteCircleWithDic:(NSDictionary *)dic
                   WithReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 发布/编辑广播
- (void)CircleSaveCircleCircleWithDic:(NSDictionary *)dic
                  WithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;



#pragma mark   ========== //////////////////////////////////////用户////////////////////////////////////////

#pragma mark   ========== 获取验证码(找回密码)
- (void)UserGetBackVerificationCodeWithDic:(NSDictionary *)dic
                           WithReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取验证码（注册）
- (void)UserGetRegVerificationCodeWithDic:(NSDictionary *)dic
                          WithReturnBlock:(ReturnBlock)returnBlock
                            andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户登录
- (void)UserLoginWithDic:(NSDictionary *)dic
         WithReturnBlock:(ReturnBlock)returnBlock
           andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 微信登陆
- (void)UserLoginByWxWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== QQ登陆
- (void)UserLoginByQQWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock;



#pragma mark   ========== 用户登录退出
- (void)UserLogOutWithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 密码找回
- (void)UserPwdBackWithWithDic:(NSDictionary *)dic
                   ReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 手机号注册用户
- (void)UserRegisterUserByPhoneWithWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 绑定新手机号
- (void)UserBindPhoneWithDic:(NSDictionary *)dic
                 ReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 根据id查找用户信息
- (void)UserfindUserByIdWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户信息筛选
- (void)UserfindUserWithDic:(NSDictionary *)dic
                ReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 根据角色，筛选用户列表
- (void)UserfindUsersByRoleWithDic:(NSDictionary *)dic
                       ReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取验证码(绑定手机)
- (void)UserGetBindVerificationCodeWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 融云token
- (void)UserGetRongTokenWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;



#pragma mark   ========== 用户保存个人信息
- (void)UserSaveUserInfoWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 修改账号
- (void)UserSaveUserNameAndPwdWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 提交公司认证
- (void)UserSubmitCompanyAuthWithDic:(NSDictionary *)dic
                         ReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户提交实名认证
- (void)UserSubmitRealNameAuthWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== //////////////////////////////////////收藏////////////////////////////////////////

#pragma mark   ========== 判断广播是否被收藏
- (void)CollectFindCircleCollectWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户的广播收藏列表
- (void)CollectFindCircleCollectListWithDic:(NSDictionary *)dic
                                ReturnBlock:(ReturnBlock)returnBlock
                              andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 判断商品是否被收藏
- (void)CollectFindGoodsCollectWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户的商品收藏列表
- (void)CollectFindGoodsCollectListWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 判断用户是否被关注
- (void)CollectFindUserCollectWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户的关注列表
- (void)CollectFndUserCollectListWithDic:(NSDictionary *)dic
                             ReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 添加/删除广播收藏
- (void)CollectSaveCircleCollectWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 添加/删除商品收藏
- (void)CollectSaveGoodsCollectWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 话题点赞和取消赞
- (void)CollectSaveTopicZanWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 关注/取消关注用户
- (void)CollectSaveUserCollectWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== //////////////////////////////////////评论////////////////////////////////////////

#pragma mark   ========== 删除评论
- (void)CommentDeleteMyCommentWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 获取广播评论
- (void)CommentGetCircleCommentListWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取商品评论
- (void)CommentGetGoodsCommentListWithDic:(NSDictionary *)dic
                              ReturnBlock:(ReturnBlock)returnBlock
                            andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== 获取资讯评论
- (void)CommentGetNewsCommentListWithDic:(NSDictionary *)dic
                              ReturnBlock:(ReturnBlock)returnBlock
                            andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 发布广播评论
- (void)CommentSaveCircleCommentWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 发布商品评论
- (void)CommentSaveGoodsCommentWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 发布资讯评论
- (void)CommentSaveNewsCommentWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 添加/删除评论点倒赞
- (void)CommentUnzanWithDic:(NSDictionary *)dic
                ReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 添加/删除评论点赞
- (void)CommentZanWithDic:(NSDictionary *)dic
              ReturnBlock:(ReturnBlock)returnBlock
            andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== //////////////////////////////////////资讯////////////////////////////////////////
#pragma mark   ========== 获取资讯详情
- (void)NewsFindNewsByIdWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取资讯列表
- (void)NewsGetNewsListWithDic:(NSDictionary *)dic
                   ReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 删除资讯
- (void)NewsDeleteNewsListWithDic:(NSDictionary *)dic
                      ReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 发布/编辑资讯
- (void)NewsSaveNewsListWithDic:(NSDictionary *)dic
                      ReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;


#pragma mark   ========== //////////////////////////////////////店铺////////////////////////////////////////

#pragma mark   ========== 获取商铺信息
- (void)StoreFindStoreByIdWithDic:(NSDictionary *)dic
                      ReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 获取商铺列表 /souxiu/store/base/getStoreList
- (void)StoreGetStoreListWithDic:(NSDictionary *)dic
                     ReturnBlock:(ReturnBlock)returnBlock
                   andErrorBlock:(ErrorBlock)errorBlock;
#pragma mark   ========== 获取我的商铺信息 /souxiu/store/findMyStoreDetail
- (void)StoreFindMyStoreDetailWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock;


@end
