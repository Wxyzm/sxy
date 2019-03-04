//
//  MuneCollectController.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MuneCollectController.h"
#import "ProDetailController.h"
#import "RadioDetailController.h"
#import "ProListCell.h"
#import "BroadCastCell.h"
#import "UserCollectCell.h"

#import "GoodsModel.h"
#import "CollectCirModel.h"
#import "MineInfoModel.h"

@interface MuneCollectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) BaseTableView *ListTab;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation MuneCollectController{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
}

- (void)initUI{
    _selectedIndex = 0;
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    
    
    
    NSArray *nameArr = @[@"商品",@"广播",@"用户"];
    NSMutableArray *topArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<3; i++) {
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

        NSMutableArray *dataArr = weakself.dataArr[index];
        if (index ==0) {
            [self.backView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }else{
            [self.backView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        }
        if (dataArr.count<=0) {
            [self reloadListDatas];
           
        }else{
            [self.collectionView reloadData];
            [self.ListTab reloadData];
        }
        
    }];
    
    [self.view addSubview:topView];
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 49, ScreenWidth, ScreenHeight-NaviHeight64-49);
    self.backView.scrollEnabled = NO;
    self.backView.pagingEnabled = YES;
    self.backView.contentSize = CGSizeMake(ScreenWidth*2,  ScreenHeight-NaviHeight64-49);
    [self.backView addSubview:self.collectionView];
    [self.backView addSubview:self.ListTab];
    
    
    [self loadGoodsList];
}




#pragma mark ========= 网络请求

#pragma mark ========= 商品收藏
- (void)loadGoodsList{
    NSDictionary *dic = @{@"pageNo":self.pageArr[0],
                          @"ordering":@[],
                          @"pageSize":@"10"
                          };
    [HUD showLoading:nil];
    [CollectPL Collect_CollectFindGoodsCollectListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        NSMutableArray *arr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
     //   [self loadCircleList];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];
  
}

#pragma mark ========= 广播收藏
- (void)loadCircleList{

    NSDictionary *dic = @{@"pageNo":self.pageArr[1],
                          @"ordering":@[],
                          @"pageSize":@"10"
                          };
     [HUD showLoading:nil];
    [CollectPL Collect_CollectFindCircleCollectListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        NSMutableArray *arr = [CollectCirModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];
}

#pragma mark ========= 关注用户
- (void)loaduserList{
    
    NSDictionary *dic = @{@"pageNo":self.pageArr[2],
                          @"ordering":@[],
                          @"pageSize":@"10"
                          };
    [HUD showLoading:nil];

    [CollectPL Collect_CollectFndUserCollectListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        NSMutableArray *arr = [MineInfoModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];
    
}
#pragma mark ========= 上拉加载下拉刷新

- (void)loadDataList{
    
    if (_selectedIndex == 0) {
        [self loadGoodsList];
    }else if (_selectedIndex == 1){
        [self loadCircleList];
    }else{
        [self loaduserList];
    }
    
}


- (void)reloadListDatas{
    [_pageArr replaceObjectAtIndex:_selectedIndex withObject:@"1"];
    self.loadWay = RELOAD_DADTAS ;
    [self loadDataList];
}

- (void)loadmoreData{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadDataList];

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
    [self.ListTab reloadData];
    [self.collectionView reloadData];
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




- (void)endLoading{
    [self.ListTab.mj_header endRefreshing];
    [self.ListTab.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


#pragma mark ========= collectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *dataArr = _dataArr[0];
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProListCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    NSMutableArray *dataArr = _dataArr[0];

    cell.Gmodel = dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *dataArr = _dataArr[0];
    GoodsModel *model = dataArr[indexPath.row];
    ProDetailController *deVc = [[ProDetailController alloc]init];
    deVc.goodsId = model.theID;
    [self.navigationController pushViewController:deVc animated:YES];
}


#pragma mark ========= tabbleviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedIndex ==0) {
        return 0;
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedIndex == 1) {
        NSMutableArray *dataArr = _dataArr[1];
        return   [BroadCastCell cellHeightWithModel:dataArr[indexPath.row]];
    }
    
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedIndex == 1) {
        static NSString *BroadCastCellcellId = @"BroadCastCell";
        BroadCastCell  *cell = [tableView dequeueReusableCellWithIdentifier:BroadCastCellcellId];
        if (!cell) {
            cell = [[BroadCastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BroadCastCellcellId];
        }
         NSMutableArray *dataArr = _dataArr[1];
        cell.model = dataArr[indexPath.row];
        cell.returnBlock = ^(CollectCirModel *model) {
             [self gotoUserStockWithID:model.userId];
        };
        return cell;
        
    }
    
    static NSString *UserCollectCellId = @"UserCollectCellId";
    UserCollectCell  *cell = [tableView dequeueReusableCellWithIdentifier:UserCollectCellId];
    if (!cell) {
        cell = [[UserCollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserCollectCellId];
    }
    NSMutableArray *dataArr = _dataArr[2];
    cell.model = dataArr[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 1) {
        NSMutableArray *dataArr = _dataArr[_selectedIndex];
        WantBuyModel *model = dataArr[indexPath.row];
        RadioDetailController *redDeVC = [[RadioDetailController alloc]init];
        redDeVC.radioId = model.theID;
        [self.navigationController pushViewController:redDeVC animated:YES];
        
    }else if (_selectedIndex == 2){
        
        NSMutableArray *dataArr = _dataArr[2];
        MineInfoModel *model= dataArr[indexPath.row];
        UserHomeController *homeVc = [[UserHomeController alloc]init];
        homeVc.userId = model.theId;
        [self.navigationController pushViewController:homeVc animated:YES];
    }
   
    
    
}


#pragma mark ==== 前往用户店铺
- (void)gotoUserStockWithID:(NSString *)userId{
    if (!userId) {
        return;
    }
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = userId;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:homeVc animated:YES];
}


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-NaviHeight64-49) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64-49) collectionViewLayout:layout];
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
        } else {
            
        }
    }
    return _collectionView;
    
}


@end
