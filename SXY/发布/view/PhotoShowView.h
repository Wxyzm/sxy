//
//  PhotoShowView.h
//  SXY
//
//  Created by yh f on 2018/12/5.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoShowView : UIView



@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray  *urlPhotos;

@property (nonatomic,assign)NSInteger  maxNum;


@end
