//
//  NewProShowCell.m
//  SXY
//
//  Created by yh f on 2018/11/10.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "NewProShowCell.h"
#import "ProCollectionCell.h"
#import "GoodsModel.h"

@interface NewProShowCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;


@end

@implementation NewProShowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}

- (void)setUP{
    
    UILabel *newLab = [BaseViewFactory labelWithFrame:CGRectMake(MaginX, 0, 200, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(16) textAligment:NSTextAlignmentLeft andtext:@"新品发布"];
    [self.contentView addSubview:newLab];
    [self.contentView addSubview:self.collectionView];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(6)
    .bottomSpaceToView(self.contentView, 0);
}

#pragma mark ========== UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _proArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProCollectionCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.proModel = _proArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_proArr[indexPath.row]);
    }
    
    
}




-(void)setProArr:(NSArray *)proArr{
    _proArr = proArr;
    [self.collectionView reloadData];
    
}




#pragma mark ========== get


+(CGFloat)cellHeight{
    
    return  120*TimeScaleX+68+6+40;

}


-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat  _margin = 5;
        CGFloat _itemW = 210*TimeScaleX;
        CGFloat _itemH = 120*TimeScaleX+68;

        layout.itemSize = CGSizeMake(_itemW, _itemH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MaginX, 40, ScreenWidth-MaginX, _itemH) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[ProCollectionCell class] forCellWithReuseIdentifier:@"ProCollectionCell"];
        [_collectionView reloadData];
    }
    return _collectionView;
    
}



@end
