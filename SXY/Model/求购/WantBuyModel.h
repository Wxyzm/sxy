//
//  WantBuyModel.h
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WantBuyModel : NSObject

@property (nonatomic,copy)NSString *theID;      //
@property (nonatomic,strong)NSDictionary *page;      //
@property (nonatomic,copy)NSString *screeningCondition;      //
@property (nonatomic,copy)NSString *addTime;      //
@property (nonatomic,copy)NSString *updateTime;      //
@property (nonatomic,copy)NSString *addUser;      //
@property (nonatomic,copy)NSString *updateUser;      //
@property (nonatomic,copy)NSString *delFlag;      //
@property (nonatomic,copy)NSString *remarks;      //
@property (nonatomic,copy)NSString *circleIds;      //
@property (nonatomic,copy)NSString *goodsModules;      //
@property (nonatomic,assign)BOOL collected;      //
@property (nonatomic,assign)BOOL izan;  //
@property (nonatomic,assign)BOOL izannot;  //
@property (nonatomic,copy)NSString *goodsModule;      //
@property (nonatomic,copy)NSString *title;      //
@property (nonatomic,copy)NSString *content;      //
@property (nonatomic,copy)NSString *goodsId;      //
@property (nonatomic,copy)NSString *cover;      //
@property (nonatomic,copy)NSString *pictureName;      //
@property (nonatomic,copy)NSString *clickCount;      //
@property (nonatomic,copy)NSString *vailddays;      //
@property (nonatomic,copy)NSString *expirationdate;      //
@property (nonatomic,copy)NSString *status;      //
@property (nonatomic,copy)NSString *userId;      //
@property (nonatomic,copy)NSString *label;      //
@property (nonatomic,copy)NSString *expirationtime;      //
@property (nonatomic,copy)NSString *userName;      //
@property (nonatomic,copy)NSString *userPhoto;      //
@property (nonatomic,copy)NSString *expiration;      //

@property (nonatomic,copy)NSArray *commentDTOList;      //

@property (nonatomic,assign)CGFloat cellHeight;


@end
