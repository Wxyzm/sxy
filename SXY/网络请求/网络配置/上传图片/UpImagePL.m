//
//  UpImagePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UpImagePL.h"

@implementation UpImagePL

- (void)updateImg:(UIImage*)image WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock {

    NSData * imageData = [self scaleImage:image toKb:1024];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    NSDictionary *dataDict = @{@"file":imageData};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/souxiu/system/base/fileUpload",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *returnArr = jsonDic[@"data"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *jsDic = [HttpClient valueWithJsonString:jsonStr];
        
        returnBlock(jsDic);
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            errorBlock(@"图片上传失败");
      
    }];
    

    
}

- (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock andImageType:(NSString *)ImageTyoe{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"imageType":ImageTyoe};
    User *user = [[UserPL shareManager]getLoginUser];
    if (user.token.length>0) {
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    }else{
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    }
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/souxiu/system/filesUpload",kbaseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        

        for (NSInteger i = 0; i < imageArr.count; i ++) {
            UIImage *images = imageArr[i];
            NSData *picData = [self scaleImage:images toKb:500];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
            [formData appendPartWithFileData:picData name:@"file" fileName:fileName mimeType:@"image/png"];
        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        if ([jsonDic[@"state"] boolValue]==NO) {
            [HUD show:jsonDic[@"message"]];
            errorBlock(jsonDic[@"message"]);
            return ;
        }
        NSArray *returnArr = jsonDic[@"data"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *jsDic = [HttpClient valueWithJsonString:jsonStr];
        returnBlock(jsDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        errorBlock(@"上传失败");

    }];

    
    

}

/**
 上传多图
 
 @param imageArr 图片数组
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock andImageType:(NSString *)ImageTyoe{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"imageType":ImageTyoe};
    User *user = [[UserPL shareManager]getLoginUser];
    if (user.token.length>0) {
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    }else{
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    }
    
    [manager POST:[NSString stringWithFormat:@"%@/souxiu/system/filesUpload",kbaseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        for (NSInteger i = 0; i < imageArr.count; i ++) {
            UIImage *images = imageArr[i];
            NSData *picData = [self zzscaleImage:images toKb:500];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
            [formData appendPartWithFileData:picData name:@"file" fileName:fileName mimeType:@"image/png"];
        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        if ([jsonDic[@"state"] boolValue]==NO) {
            [HUD show:jsonDic[@"message"]];
            errorBlock(jsonDic[@"message"]);
            return ;
        }
        NSArray *returnArr = jsonDic[@"data"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *jsDic = [HttpClient valueWithJsonString:jsonStr];
        returnBlock(jsDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        errorBlock(@"上传失败");
        
    }];
}



/**
 搜图
 
 @param searchImage  图片
 @param returnBlock returnBlock 成功
 @param errorBlock errorBlock 失败
 */
+ (void)SearchImg:(UIImage*)searchImage andTag:(NSString*)tagStr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic= @{@"tags":tagStr,
                         @"count":@"20"
                         };
    
    User *user = [[UserPL shareManager]getLoginUser];
    if (user.token.length>0) {
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    }else{
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];

    NSData * imageData = [self zzscaleImage:searchImage toKb:1024];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    [manager POST:[NSString stringWithFormat:@"%@/souxiu/goods/base/goodsImageSearch",kbaseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
           [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        if ([jsonDic[@"state"] boolValue]==NO) {
            [HUD show:jsonDic[@"message"]];
            errorBlock(jsonDic[@"message"]);
            return ;
        }
        NSArray *returnArr = jsonDic[@"data"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *jsDic = [HttpClient valueWithJsonString:jsonStr];
        returnBlock(jsDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        errorBlock(@"上传失败");
        
    }];
}







#pragma mark ===== 图片压缩至1m


/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=400;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}
/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
+ (NSData *)zzscaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=400;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}
@end
