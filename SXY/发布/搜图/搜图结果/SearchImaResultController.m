//
//  SearchImaResultController.m
//  SXY
//
//  Created by yh f on 2019/1/10.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "SearchImaResultController.h"
#import "ReleaseWantBuyController.h"
#import "ProDetailController.h"
#import "ProListCell.h"

@interface SearchImaResultController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UIView *noView;


@end

@implementation SearchImaResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜图";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

- (void)initUI{
    
    UILabel *leftlab = [BaseViewFactory labelWithFrame:CGRectMake(20, 15, ScreenWidth-40, 22) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"搜图结果：%ld条",_dataArr.count]];
    [self.view addSubview:leftlab];
    [self.view addSubview:self.noView];
    if (_dataArr.count<=0) {
        self.noView.hidden = NO;
    }else{
        self.noView.hidden = YES;
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    UIView *line= [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64-80, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:line];
    
    YLButton *SearchBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(28, ScreenHeight-64-NaviHeight64, ScreenWidth-56, 44) font:APPFONT(16) title:@"发布求购" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:SearchBtn];
    [SearchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    SearchBtn.layer.cornerRadius = 22;
    
    [self.view bringSubviewToFront:_noView];

    
}



#pragma mark ========== collectionview
- (void)SearchBtnClick{
    
    ReleaseWantBuyController *wantVc = [[ReleaseWantBuyController alloc]init];
    wantVc.searchIma  = _searchIma;
    [self.navigationController pushViewController:wantVc animated:YES];
}


#pragma mark ========== UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProListCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.Gmodel = _dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsModel *model = _dataArr[indexPath.row];
    ProDetailController *deVc = [[ProDetailController alloc]init];
    deVc.goodsId = model.theID;
    [self.navigationController pushViewController:deVc animated:YES];
    
    
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth,ScreenHeight-NaviHeight64-43-80) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[ProListCell class] forCellWithReuseIdentifier:@"ProListCell"];
        [_collectionView reloadData];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
    
}

-(UIView *)noView{
    
    if (!_noView) {
        _noView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-53, 180, 106, 146)];
        _noView.hidden = YES;
        UIImageView *notIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty"]];
        [_noView addSubview:notIma];
        notIma.frame = CGRectMake(0, 0, 106, 106);
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(0, 106, 106, 120) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"啥都没有呢"];
        [_noView addSubview:lab];
        [self.view addSubview:_noView];
    }
    return _noView;
    
}


@end
