//
//  ShopAllProController.m
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ShopAllProController.h"
#import "ProListCell.h"
#import "ProDetailController.h"
#import "CreateGoodsController.h"
@interface ShopAllProController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;
@end

@implementation ShopAllProController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    [self setRightBtnWithTitle:@"发布" andColor:UIColorFromRGB(BTNColorValue)];

    [self initUI];
    [self loadList];

}


- (void)initUI{
    _selectedIndex = 0;
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *nameArr = @[@"全部",@"花朵/花边",@"满幅",@"3D重手工"];
    NSMutableArray *topArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<nameArr.count; i++) {
        TopModel *model = [[TopModel alloc]init];
        model.title = nameArr[i];
        model.selectedId = [NSString stringWithFormat:@"%d",i];
        [topArr addObject:model];
        [self.dataArr addObject:[NSMutableArray arrayWithCapacity:0]];
        [self.pageArr  addObject:@"1"];
    }
    TopView *topView = [[TopView alloc]initWithArr:topArr];
    topView.frame = CGRectMake(0, 0, ScreenWidth, 49);
    WeakSelf(self);
    [topView setReturnBlock:^(NSInteger index) {
        weakself.selectedIndex = index;
        self.nothingIma.hidden = YES;

        NSMutableArray *dataArr = _dataArr[index];
        if (dataArr.count<=0) {
            [self loadList];
        }else{
            [self.collectionView reloadData];
        }
    }];
    
    [self.view addSubview:topView];
    [self.view addSubview:self.collectionView];
    
    
}

- (void)reloadListDatas{
    self.loadWay = RELOAD_DADTAS;
    [self.pageArr replaceObjectAtIndex:_selectedIndex withObject:@"1"];
    [self loadList];
}

- (void)loadmoreData{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadList];
}

#pragma mark ========= 获取数据
- (void)loadList{
    NSDictionary *dic;
    User *user = [[UserPL shareManager] getLoginUser];
    if (_selectedIndex == 0) {
        dic = @{@"status":@"3",
                @"pageNo":self.pageArr[_selectedIndex],
                @"pageSize":@"10",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId

                };
    }else if (_selectedIndex == 1){
        dic = @{@"goodsCategoryId":@"3",
                @"status":@"3",
                @"pageNo":self.pageArr[_selectedIndex],
                @"pageSize":@"10",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId

                };
    }else if (_selectedIndex ==2){
        dic = @{@"goodsCategoryId":@"4",
                @"status":@"3",
                @"pageNo":self.pageArr[_selectedIndex],
                @"pageSize":@"10",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId

                };
    }else if (_selectedIndex == 3){
        dic = @{@"goodsCategoryId":@"6",
                @"status":@"3",
                @"pageNo":self.pageArr[_selectedIndex],
                @"pageSize":@"10",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId

                };
    }
    [HUD showLoading:nil];
    [GEditPL Goods_GoodsGetGoodsListWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSMutableArray *arr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];
    
}


- (void)loadSuccessWithArr:(NSMutableArray *)suArr{
    [self setPageCount];
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [dataArr  removeAllObjects];
    }
    [dataArr addObjectsFromArray:suArr];
    if (dataArr.count<=0) {
        self.nothingIma.hidden = NO;
        [self.view bringSubviewToFront:self.nothingIma];
    }else{
        self.nothingIma.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)endLoading{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
}

- (void)setPageCount{
    NSInteger page = [_pageArr[_selectedIndex] integerValue];
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        page = 1;
    }
    page ++;
    [_pageArr replaceObjectAtIndex:_selectedIndex withObject:[NSString stringWithFormat:@"%ld",page]];
}
#pragma mark ========== UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProListCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    cell.Gmodel = dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    GoodsModel *model = dataArr[indexPath.row];
    ProDetailController *deVc = [[ProDetailController alloc]init];
    deVc.goodsId = model.theID;
    [self.navigationController pushViewController:deVc animated:YES];
    
    
}


-(void)respondToRigheButtonClickEvent{
    //发布
    CreateGoodsController *crVc = [[CreateGoodsController alloc]init];
    crVc.releaseType = _releaseType;
    [self.navigationController pushViewController:crVc animated:YES];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth,ScreenHeight-NaviHeight64-49) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[ProListCell class] forCellWithReuseIdentifier:@"ProListCell"];
        [_collectionView reloadData];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        _collectionView.mj_header.ignoredScrollViewContentInsetTop = 10;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
    
}









@end
