//
//  HttpClient.m
//  ZhongFangTong
//
//  Created by apple on 2018/6/5.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

{
    NSOperationQueue *_queue;
    NSString         *_baseUrl;
}


#pragma mark   ========== init


+ (HttpClient *)sharedHttpClient
{
    static HttpClient *_sharedPHPHelper = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       _sharedPHPHelper = [[self alloc] initWithBaseUrl:kbaseUrl];
    });
    
    return _sharedPHPHelper;
}


- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        _baseUrl = baseUrl;
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}
//获取request
- (void)setRequestWithInfo:(NSDictionary *)info url:(NSString *)urlStr method:(NSString *)method requset:(NSMutableURLRequest *)request
{
   
    
    NSURL *url;
    if ([method isEqualToString:@"GET"]) {
        if (info) {
            NSArray *keyArray = [info allKeys];
            NSMutableString *str = [NSMutableString string];
            [str appendString:@"?"];
            NSString *key = keyArray[0];
            [str appendString:[NSString stringWithFormat:@"%@=%@",key,[info objectForKey:key]]];
            for (int i = 1;i < keyArray.count;i++) {
                key = keyArray[i];
                if (key.length)
                    [str appendString:[NSString stringWithFormat:@"&%@=%@",key,[info objectForKey:key]]];
                
            }
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",_baseUrl,urlStr?urlStr:@"",str] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,urlStr?urlStr:@""]];
        }
    } else
    {
        NSString *URLWithString = [NSString stringWithFormat:@"%@%@",_baseUrl,urlStr?urlStr:@""];
        NSString *encodedString = (NSString *)
        
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)URLWithString,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        url = [NSURL URLWithString:[encodedString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    }
    
    [request setURL:url];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:NET_TIME_OUT];
    [request setHTTPMethod:method];
    //设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    User *user = [[UserPL shareManager]getLoginUser];
    if (user.token.length>0) {
        [request addValue:user.token forHTTPHeaderField:@"token"];

    }else{
        [request addValue:@"" forHTTPHeaderField:@"token"];
    }
    

    if ([method isEqualToString:@"POST"]) {
        NSArray *keyArray = [info allKeys];
        if (keyArray.count >0) {
            NSString * sendStr= [GlobalMethod dictionaryToJson:info];
            NSData *data = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:data];
            NSLog(@"%@",sendStr);
        }else{
            NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
        }
    }
}



#pragma mark   ========== Config

//get方式获取
- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
    success:(void(^)(NSDictionary *))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dict url:url method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSDictionary *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
             successBlock(jsonDic);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}

//post方式获取
- (void)POST:(NSString *)url
        dict:(NSDictionary *)dict
     success:(void(^)(NSDictionary *))successBlock
     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dict url:url method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSDictionary *resultDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
             successBlock(resultDic);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}

//json解析
+ (id)valueWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    id value = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingMutableContainers
                                                 error:&err];
    if(err) {
        return nil;
    }
    
    return [GlobalMethod deleteEmpty:value];
}


#pragma mark   ========== 获取用户协议
-(void)UsergetFindAgreementWithReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/souxiu/agreement/base/findAgreement" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark   ========== 获取验证码（注册）
-(void)UsergetRegVerificationCodeDic:(NSDictionary *)dic
                     WithReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/getRegVerificationCode" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
    
}

#pragma mark   ========== 手机号登陆，没有注册，直接注册掉
-(void)UsergetLoginByPhoneDic:(NSDictionary *)dic
              WithReturnBlock:(ReturnBlock)returnBlock
                andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/loginByPhone" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}



//////////////////////////////////////首页/////////////////////////////////
#pragma mark   ========== 获取首页
-(void)HomegetHomeListWithDic:(NSDictionary *)dic
              WithReturnBlock:(ReturnBlock)returnBlock
                andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/index/base/getIndexList" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}


//////////////////////////////////////文件上传/////////////////////////////////
#pragma mark   ========== 文件上传
-(void)SystemBaseFileUpload:(NSDictionary *)dic
            WithReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/system/base/fileUpload" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
    
}

//////////////////////////////////////商品/////////////////////////////////

#pragma mark   ========== 发布/编辑商品
-(void)GoodsSaveGoodsWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/goods/saveGoods" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

#pragma mark   ========== 删除商品
-(void)GoodsDeleteGoodsWithDic:(NSDictionary *)dic
               WithReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/goods/deleteGoods" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

#pragma mark   ========== 获取商品列表
-(void)GoodsGetGoodsListWithDic:(NSDictionary *)dic
                WithReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/goods/base/getGoodsList" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

#pragma mark   ========== 获取商品详情
-(void)GoodsFindGoodsByIdWithDic:(NSDictionary *)dic
                 WithReturnBlock:(ReturnBlock)returnBlock
                   andErrorBlock:(ErrorBlock)errorBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/goods/base/findGoodsById" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

//////////////////////////////////////广播/////////////////////////////////

#pragma mark   ========== 获取广播详情
- (void)CircleFindCircleByIdDic:(NSDictionary *)dic
                WithReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/circle/base/findCircleById" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 获取广播列表
- (void)CircleGetCircleListWithDic:(NSDictionary *)dic
                   WithReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/circle/base/getCircleList" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 删除广播
- (void)CircleDeleteCircleWithDic:(NSDictionary *)dic
                  WithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/circle/deleteCircle" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 发布/编辑广播
- (void)CircleSaveCircleCircleWithDic:(NSDictionary *)dic
                      WithReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/circle/saveCircle" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

//////////////////////////////////////类别/////////////////////////////////

#pragma mark   ========== 获取类别详情
-(void)CategoryFindCategoryByIdWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/findCategoryById" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 获取类别列表
-(void)CategoryGetCategoryListWithDic:(NSDictionary *)dic
                      WithReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getCategoryList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 获取类别列表(根据parentId)
-(void)CategoryGetCategoryListByParentIdWithDic:(NSDictionary *)dic
                                WithReturnBlock:(ReturnBlock)returnBlock
                                  andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getCategoryListByParentId" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 获取幅宽
-(void)CategoryGetClothWidthListWithDic:(NSDictionary *)dic
                        WithReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getClothWidthList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 获取成分
-(void)CategoryGetComponentListWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getComponentList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 获取品类标签
-(void)CategoryGetGoodsClassListWithDic:(NSDictionary *)dic
                        WithReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getGoodsClassList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== 获取单位
-(void)CategoryGetUnitListWithDic:(NSDictionary *)dic
                  WithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getUnitList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== 获取供应链类目列表
-(void)CategoryGetUserKindListWithDic:(NSDictionary *)dic
                      WithReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getUserKindList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ==========  获取有效时间
-(void)CategoryGetVailddaysListWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/base/getVailddaysList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 删除类别
-(void)CategorydeleteCategoryWithDic:(NSDictionary *)dic
                     WithReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/deleteCategory" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 删除个人自定义的类别
-(void)CategorydeleteUserCategoryWithDic:(NSDictionary *)dic
                         WithReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/deleteUserCategory" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 发布/编辑类别(后台)
#pragma mark   ========== 发布/编辑个人的自定义标签
-(void)CategorysaveUserCategoryWithDic:(NSDictionary *)dic
                       WithReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/category/saveUserCategory" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== //////////////////////////////////////用户////////////////////////////////////////

#pragma mark   ========== 获取验证码(找回密码)
- (void)UserGetBackVerificationCodeWithDic:(NSDictionary *)dic
                           WithReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/getBackVerificationCode" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
  
}

#pragma mark   ========== 获取验证码（注册）
- (void)UserGetRegVerificationCodeWithDic:(NSDictionary *)dic
                          WithReturnBlock:(ReturnBlock)returnBlock
                            andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/getRegVerificationCode" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}



#pragma mark   ========== 用户登录
- (void)UserLoginWithDic:(NSDictionary *)dic
         WithReturnBlock:(ReturnBlock)returnBlock
           andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/login" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}



#pragma mark   ========== 微信登陆
- (void)UserLoginByWxWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/loginByWeichat" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== QQ登陆
- (void)UserLoginByQQWithDic:(NSDictionary *)dic
             WithReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/loginByQQ" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 用户登录退出
- (void)UserLogOutWithReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/souxiu/user/base/logout" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 密码找回
- (void)UserPwdBackWithWithDic:(NSDictionary *)dic
                   ReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/pwdBack" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 手机号注册用户
- (void)UserRegisterUserByPhoneWithWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/base/registerUserByPhone" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 绑定新手机号
- (void)UserBindPhoneWithDic:(NSDictionary *)dic
                 ReturnBlock:(ReturnBlock)returnBlock
               andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/bindPhone" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 根据id查找用户信息
- (void)UserfindUserByIdWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/findUserById" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 用户信息筛选
- (void)UserfindUserWithDic:(NSDictionary *)dic
                ReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/findUsers" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 根据角色，筛选用户列表
- (void)UserfindUsersByRoleWithDic:(NSDictionary *)dic
                       ReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/findUsersByRole" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 获取验证码(绑定手机)
- (void)UserGetBindVerificationCodeWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/getBindVerificationCode" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 融云token
- (void)UserGetRongTokenWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/getRongToken" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}



#pragma mark   ========== 用户保存个人信息
- (void)UserSaveUserInfoWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/saveUserInfo" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 修改账号
- (void)UserSaveUserNameAndPwdWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/saveUserNameAndPwd" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 提交公司认证
- (void)UserSubmitCompanyAuthWithDic:(NSDictionary *)dic
                         ReturnBlock:(ReturnBlock)returnBlock
                       andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/submitCompanyAuth" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 用户提交实名认证
- (void)UserSubmitRealNameAuthWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/user/submitRealNameAuth" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== //////////////////////////////////////收藏////////////////////////////////////////

#pragma mark   ========== 判断广播是否被收藏
- (void)CollectFindCircleCollectWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findCircleCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 用户的广播收藏列表
- (void)CollectFindCircleCollectListWithDic:(NSDictionary *)dic
                                ReturnBlock:(ReturnBlock)returnBlock
                              andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findCircleCollectList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 判断商品是否被收藏
- (void)CollectFindGoodsCollectWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findGoodsCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 用户的商品收藏列表
- (void)CollectFindGoodsCollectListWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findGoodsCollectList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 判断用户是否被关注
- (void)CollectFindUserCollectWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findUserCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 用户的关注列表
- (void)CollectFndUserCollectListWithDic:(NSDictionary *)dic
                             ReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/findUserCollectList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 添加/删除广播收藏
- (void)CollectSaveCircleCollectWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/saveCircleCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 添加/删除商品收藏
- (void)CollectSaveGoodsCollectWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/saveGoodsCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== 话题点赞和取消赞
- (void)CollectSaveTopicZanWithDic:(NSDictionary *)dic
                       ReturnBlock:(ReturnBlock)returnBlock
                     andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/saveTopicZan" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}
#pragma mark   ========== 关注/取消关注用户
- (void)CollectSaveUserCollectWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/collect/saveUserCollect" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== //////////////////////////////////////评论////////////////////////////////////////

#pragma mark   ========== 删除评论
- (void)CommentDeleteMyCommentWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/deleteMyComment" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}



#pragma mark   ========== 获取广播评论
- (void)CommentGetCircleCommentListWithDic:(NSDictionary *)dic
                               ReturnBlock:(ReturnBlock)returnBlock
                             andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/getCircleCommentList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 获取商品评论
- (void)CommentGetGoodsCommentListWithDic:(NSDictionary *)dic
                              ReturnBlock:(ReturnBlock)returnBlock
                            andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/getGoodsCommentList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 获取资讯评论
- (void)CommentGetNewsCommentListWithDic:(NSDictionary *)dic
                             ReturnBlock:(ReturnBlock)returnBlock
                           andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/getNewsCommentList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 发布广播评论
- (void)CommentSaveCircleCommentWithDic:(NSDictionary *)dic
                            ReturnBlock:(ReturnBlock)returnBlock
                          andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/saveCircleComment" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 发布商品评论
- (void)CommentSaveGoodsCommentWithDic:(NSDictionary *)dic
                           ReturnBlock:(ReturnBlock)returnBlock
                         andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/saveGoodsComment" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 发布资讯评论
- (void)CommentSaveNewsCommentWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/saveNewsComment" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}

#pragma mark   ========== 添加/删除评论点倒赞
- (void)CommentUnzanWithDic:(NSDictionary *)dic
                ReturnBlock:(ReturnBlock)returnBlock
              andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/unzan" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== 添加/删除评论点赞
- (void)CommentZanWithDic:(NSDictionary *)dic
              ReturnBlock:(ReturnBlock)returnBlock
            andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/comment/zan" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
}


#pragma mark   ========== //////////////////////////////////////资讯////////////////////////////////////////
#pragma mark   ========== 获取资讯详情
- (void)NewsFindNewsByIdWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/news/base/findNewsById" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
    
}

#pragma mark   ========== 获取资讯列表
- (void)NewsGetNewsListWithDic:(NSDictionary *)dic
                   ReturnBlock:(ReturnBlock)returnBlock
                 andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/news/base/getNewsList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
    
}

#pragma mark   ========== 删除资讯
- (void)NewsDeleteNewsListWithDic:(NSDictionary *)dic
                      ReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/news/deleteNews" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
    
}

#pragma mark   ========== 发布/编辑资讯
- (void)NewsSaveNewsListWithDic:(NSDictionary *)dic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/news/saveNews" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
    
    
}
#pragma mark   ========== //////////////////////////////////////店铺////////////////////////////////////////

#pragma mark   ========== 获取商铺信息
- (void)StoreFindStoreByIdWithDic:(NSDictionary *)dic
                      ReturnBlock:(ReturnBlock)returnBlock
                    andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/store/base/findStoreById" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

#pragma mark   ========== 获取商铺列表 /souxiu/store/base/getStoreList
- (void)StoreGetStoreListWithDic:(NSDictionary *)dic
                     ReturnBlock:(ReturnBlock)returnBlock
                   andErrorBlock:(ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/store/base/getStoreList" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}

#pragma mark   ========== 获取我的商铺信息 /souxiu/store/findMyStoreDetail
- (void)StoreFindMyStoreDetailWithDic:(NSDictionary *)dic
                          ReturnBlock:(ReturnBlock)returnBlock
                        andErrorBlock:(ErrorBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/souxiu/store/findMyStoreDetail" method:@"POST" requset:request];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    [_queue addOperation:operation];
}


@end
