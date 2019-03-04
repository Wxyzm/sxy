//
//  FourPalacesCell.m
//  SXY
//
//  Created by yh f on 2018/11/14.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "FourPalacesCell.h"
#import "ProListCell.h"

@interface FourPalacesCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation FourPalacesCell{
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{

    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 0, 200, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(16) textAligment:NSTextAlignmentLeft andtext:@"现货"];
    [self.contentView addSubview:_nameLab];
    
    YLButton *rightBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(ScreenWidth-57, 0, 37, 40) font:APPFONT17 title:@"更多" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = APPFONT12;
    [self.contentView addSubview:rightBtn];
    [rightBtn setTitleRect:CGRectMake(0, 0, 26, 40)];
    [rightBtn setImageRect:CGRectMake(31, 15, 6, 10)];
    [rightBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView addSubview:self.collectionView];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(6)
    .bottomSpaceToView(self.contentView, 0);


}

#pragma mark ========== 更多

- (void)moreBtnClick{
    
    if (self.returnBlock) {
        self.returnBlock(self,nil);
    }
    
}


-(void)setFourPalacesArr:(NSArray *)FourPalacesArr{
    
    _FourPalacesArr = FourPalacesArr;
    
    if (!FourPalacesArr) {
        [self.collectionView reloadData];

        return;
    }
    
    CGFloat _itemW = (ScreenWidth - 50)/2;;
    CGFloat _itemH =  _itemW + 67+14;
    if (FourPalacesArr.count<=0) {
        self.collectionView.frame =  CGRectZero;
    }else if (FourPalacesArr.count<=2){
        self.collectionView.frame =  CGRectMake(0, 40, ScreenWidth, _itemH+20+6);
    }else{
        self.collectionView.frame =  CGRectMake(0, 40, ScreenWidth, _itemH*2+20+6);

    }
    [self.collectionView reloadData];

}


#pragma mark ========== UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = _FourPalacesArr.count;
    if (count>4) {
        count = 4;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProListCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.Gmodel = _FourPalacesArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsModel *model = _FourPalacesArr[indexPath.row];
    if (self.returnBlock) {
        self.returnBlock(self,model);
    }
    
}

+(CGFloat)cellHeightWithArr:(NSArray *)arr{
    
    CGFloat _itemW = (ScreenWidth - 50)/2;;
    CGFloat _itemH =  _itemW + 67+14;
    if (arr.count<=0) {
        return 40;
    }else if (arr.count<=2){
        return 40 + _itemH+20+6;
    }
    
    return 40 + _itemH*2+20+6;
}


#pragma mark ========== get


-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat  _margin = 10;
        CGFloat _itemW = (ScreenWidth - 50)/2;;
        CGFloat _itemH =  _itemW + 67+14;
        
        layout.itemSize = CGSizeMake(_itemW, _itemH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[ProListCell class] forCellWithReuseIdentifier:@"ProListCell"];
        [_collectionView reloadData];
    }
    return _collectionView;
    
}


@end
