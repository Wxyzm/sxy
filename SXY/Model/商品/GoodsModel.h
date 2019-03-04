//
//  GoodsModel.h
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//   商品Model

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic,copy)NSString *theID;  //
@property (nonatomic,copy)NSString *addTime;  //
@property (nonatomic,copy)NSString *addUser;  //
@property (nonatomic,copy)NSString *delFlag;  //
@property (nonatomic,copy)NSString *deliveryStatus;  //
@property (nonatomic,copy)NSString *discount;  //
@property (nonatomic,copy)NSString *feature;  //
@property (nonatomic,copy)NSString *freight;  //
@property (nonatomic,copy)NSString *goodsBrand;  //
@property (nonatomic,copy)NSString *goodsBrandImg;  //
@property (nonatomic,copy)NSString *goodsCategory;  //
@property (nonatomic,copy)NSString *goodsCode;  //
@property (nonatomic,copy)NSString *goodsIds;  //
@property (nonatomic,copy)NSString *goodsLevel;  //
@property (nonatomic,copy)NSString *goodsModule;  //
@property (nonatomic,copy)NSString *goodsName;  //
@property (nonatomic,copy)NSString *goodsPoint;  //
@property (nonatomic,copy)NSString *goodsRemark;  //
@property (nonatomic,copy)NSString *ihot;  //
@property (nonatomic,copy)NSString *inew;  //
@property (nonatomic,copy)NSString *keyword;  //
@property (nonatomic,copy)NSString *linkUrl;  //
@property (nonatomic,copy)NSString *marketPrice;  //
@property (nonatomic,copy)NSString *maxPrice;  //
@property (nonatomic,copy)NSString *minPrice;  //
@property (nonatomic,strong)NSDictionary *page;  //
@property (nonatomic,copy)NSString *particularsChar;  //
@property (nonatomic,copy)NSString *particularsPicture;  //
@property (nonatomic,copy)NSString *paycnt;  //
@property (nonatomic,copy)NSString *pictureName;  //
@property (nonatomic,copy)NSString *remarks;  //
@property (nonatomic,copy)NSString *screeningCondition;  //
@property (nonatomic,copy)NSString *sortIndex;  //
@property (nonatomic,strong)NSArray *specDTOList;  //
@property (nonatomic,copy)NSString *status;  //
@property (nonatomic,copy)NSString *storeId;  //
@property (nonatomic,copy)NSString *updateTime;  //
@property (nonatomic,copy)NSString *updateUser;  //


@property (nonatomic,copy)NSString *logo;  //
@property (nonatomic,copy)NSString *storeName;  //

@property (nonatomic,copy)NSString *goodsCategoryNamePath; //花边/朵花>条码
@property (nonatomic,copy)NSString *goodsCategoryId;
@property (nonatomic,assign)BOOL isSelected;















@end
