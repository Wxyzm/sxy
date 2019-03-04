//
//  TopicDetailController.h
//  SXY
//
//  Created by yh f on 2019/1/16.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicDetailController : BaseViewController

@property (nonatomic , copy) NSString *topId;
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , strong) UIImage *faceIma;

@property (nonatomic , strong) NSString *faceImaStr;






@end

NS_ASSUME_NONNULL_END
