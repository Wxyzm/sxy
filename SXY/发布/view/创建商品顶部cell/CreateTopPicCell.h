//
//  CreateTopPicCell.h
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^CreateTopPicCellReturnBlock)(UIImage *image,NSString *title);

@interface CreateTopPicCell : BaseTableViewCell

@property (nonatomic,copy)CreateTopPicCellReturnBlock returnBlock;
@property (nonatomic,strong)UIImageView *faceIma;
@property (nonatomic,strong)UITextField *titleTxt;
@property (nonatomic,strong)UILabel *titleNumLab;

//    _titleNumLab.text = [NSString stringWithFormat:@"%ld/30",_titleTxt.text.length];

@end
