//
//  UserHomeController.m
//  SXY
//
//  Created by yh f on 2019/1/8.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "UserHomeController.h"
#import "ProDetailController.h"
#import "RadioDetailController.h"
#import "UserHomeTopView.h"
#import "MineInfoModel.h"
#import "CircleCell.h"
#import "ProListCell.h"

@interface UserHomeController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UserHomeTopView *topView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation UserHomeController{
    
    MineInfoModel *_model;
    BOOL _isCollected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadUserInfo];
    [self loadGoodsList];
    [self judgeIsCollectUser];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=NO;
}
#pragma mark ====== 加载用户信息
- (void)loadUserInfo{
    
    NSDictionary *dic = @{@"id":_userId};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _model = [MineInfoModel mj_objectWithKeyValues:returnValue[@"result"]];
        _topView.model = _model;

    } andErrorBlock:^(NSString *msg) {
    }];
    
    
}

#pragma mark ====== 判断是否收藏
- (void)judgeIsCollectUser
{
    NSDictionary *dic = @{@"id":_userId};
    [CollectPL Collect_CollectFindUserCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _isCollected = [returnValue boolValue];
        if (_isCollected) {
            //已关注，去下关注
            [_topView.focBtn setTitle:@"已关注" forState:UIControlStateNormal];
            _topView.focBtn.backgroundColor = UIColorFromRGB(BTNColorValue);
            [_topView.focBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
        }else{
            //未关注，去关注
            [_topView.focBtn setTitle:@"关注" forState:UIControlStateNormal];
            _topView.focBtn.backgroundColor = UIColorFromRGB(WhiteColorValue);
            [_topView.focBtn setTitleColor:UIColorFromRGB(BTNColorValue) forState:UIControlStateNormal];
        }
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
    
}


- (void)focusUser{
    NSDictionary *dic = @{@"id":_userId};
    [CollectPL Collect_CollectSaveUserCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        [self judgeIsCollectUser];
        
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}

- (void)chatBtnClick{
    
    if (!_model) {
        return;
    }
    [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:_model.name targetId:_userId];
    
    


}




#pragma mark ======initUI

- (void)initUI{
    _selectedIndex = 0;
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _topView = [[UserHomeTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 197)];
    [_topView.focBtn addTarget:self action:@selector(focusUser) forControlEvents:UIControlEventTouchUpInside];
    [_topView.chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_topView];
    NSArray *nameArr = @[@"商品",@"广播",@"话题"];
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
    topView.frame = CGRectMake(0, 197, ScreenWidth, 49);
    WeakSelf(self);
    [topView setReturnBlock:^(NSInteger index) {
        weakself.selectedIndex = index;
        NSMutableArray *dataArr = weakself.dataArr[index];
        if (dataArr.count<=0) {
            self.nothingIma.hidden = NO;
            [self.view bringSubviewToFront:self.nothingIma];
        }else{
            self.nothingIma.hidden = YES;
        }
        if (index ==0) {
            [self.backView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }else{
            [self.backView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        }
        
        if (dataArr.count>0) {
            [self.ListTab reloadData];
            [self.collectionView reloadData];
            return ;
        }
        [self reloadListDatas];
        
    }];
    
    [self.view addSubview:topView];
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 246, ScreenWidth, ScreenHeight-NaviHeight64-246);
    self.backView.scrollEnabled = NO;
    self.backView.pagingEnabled = YES;
    self.backView.contentSize = CGSizeMake(ScreenWidth*2,  ScreenHeight-NaviHeight64-49);
    [self.backView addSubview:self.collectionView];
    [self.backView addSubview:self.ListTab];
    
    
}
- (void)reloadListDatas{
    self.loadWay = RELOAD_DADTAS ;
    [self.pageArr replaceObjectAtIndex:_selectedIndex withObject:@"1"];
    if (_selectedIndex ==0) {
        [self loadGoodsList];
    }else if (_selectedIndex ==1){
        [self loadBoardList];
    }else{
        [self loadTopicList];
    }
}


- (void)loadmoreData{
    self.loadWay = LOAD_MORE_DATAS ;
    if (_selectedIndex ==0) {
        [self loadGoodsList];
    }else if (_selectedIndex ==1){
        [self loadBoardList];
    }else{
        [self loadTopicList];
    }
}

#pragma mark ========= 商品
- (void)loadGoodsList{
    
    NSDictionary *   dic = @{@"goodsCategoryId":@"",
                             @"pageNo":self.pageArr[_selectedIndex],
                             @"pageSize":@"10",
                             @"userId":_userId
                             };

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


#pragma mark ========= 广播
- (void)loadBoardList{
    
    NSDictionary *dic = @{@"isExpiration":@"false",
                          @"id":@"",
                          @"title":@"",
                          @"userId":_userId,
                          @"pageNo":self.pageArr[_selectedIndex],
                          @"pageSize":@"10",
                          @"content":@""
                          };
    [HUD showLoading:nil];
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSMutableArray *reArr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
         [HUD cancel];
        [self setDataArrWithArr:reArr];
        [self loadSuccessWithArr:reArr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];

    }];
    
}


#pragma mark ========= 话题

- (void)loadTopicList{
    
    NSDictionary *dic = @{@"goodsModules":@[@"3"],
                          @"pageNo":self.pageArr[_selectedIndex],
                          @"pageSize":@"10",
                          @"userId":_userId
                          };
    [HUD showLoading:nil];
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSMutableArray *reArr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self setDataArrWithArr:reArr];
        [self loadSuccessWithArr:reArr];
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
    [self.ListTab reloadData];
    [self.collectionView reloadData];
}

- (void)endLoading{
    [self.ListTab.mj_header endRefreshing];
    [self.ListTab.mj_footer endRefreshing];
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



- (void)setDataArrWithArr:(NSMutableArray*)returnArr{
    
//    NSMutableArray *timeArr = [NSMutableArray arrayWithCapacity:0];
//    for (WantBuyModel *model in returnArr) {
//        // iOS 生成的时间戳是10位
//        NSString *dateString       = [GlobalMethod returnTimeStrWith:model.addTime];
//        model.addTime = dateString;
//        if (![timeArr containsObject:dateString]) {
//            [timeArr addObject:dateString];
//            [_dataArr addObject:[NSMutableArray arrayWithCapacity:0]];
//        }
//    }
//
//    for (int i = 0; i<timeArr.count; i++)
//    {
//        NSString *timeStr = timeArr[i];
//        NSMutableArray *dataArr = _dataArr[i];
//        for (WantBuyModel *model in returnArr)
//        {
//            if ([model.addTime isEqualToString:timeStr]) {
//                [dataArr addObject:model];
//            }
//
//        }
//
//
//    }
//    [self.ListTab reloadData];
//    [self.collectionView reloadData];

    
}

#pragma mark ====== tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedIndex==0) {
        return 0;
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
     if (_selectedIndex ==1){
         return [CircleCell cellHeightWithModel:dataArr[indexPath.row]];

    }else if (_selectedIndex ==2){
        return [CircleCell cellHeightWithModel:dataArr[indexPath.row]];

    }
    
    
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    CircleCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    cell.model = dataArr[indexPath.row];
    cell.returnBlock = ^(WantBuyModel *model, NSInteger tag,CircleCell *thecell) {
        if (tag == 0) {
            //收藏
            [self colloectCirWithModel:model];
        }else if (tag == 1){
            //回复
            [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:model.userName targetId:model.userId];

        }else if (tag == 2){
            //用户主页
            [self gotoUserStockWithID:model.userId];
            
        }
        else{
           //大图
            [self checkBigImageWithCell:thecell andtag:tag-1000 andModel:model];
        }
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    WantBuyModel *model = dataArr[indexPath.row];
    RadioDetailController *redDeVC = [[RadioDetailController alloc]init];
    redDeVC.radioId = model.theID;
    [self.navigationController pushViewController:redDeVC animated:YES];
    
}


- (void)colloectCirWithModel:(WantBuyModel *)model{
    
    NSDictionary *dic = @{@"id":model.theID};
    [CollectPL Collect_CollectSaveCircleCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        model.collected = !model.collected;
        [self.ListTab reloadData];
        [self.collectionView reloadData];

    } withErrorBlock:^(NSString *msg) {
        
    }];
}


#pragma mark ==== 查看大图
- (void)checkBigImageWithCell:(CircleCell *)cell andtag:(NSInteger)tag andModel:(WantBuyModel*)model{
    NSMutableArray *imageArr =[NSMutableArray arrayWithCapacity:0];
    NSArray *arr;
    if (model.pictureName.length>0) {
        arr = [model.pictureName componentsSeparatedByString:@","];
    }
    NSInteger a = arr.count;
    if (arr.count>3) {
        a = 3;
    }else if (arr.count<=0){
        return;
    }
    for (int i = 0; i<a; i++) {
        [imageArr addObject:[NSString stringWithFormat:@"%@",[GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES]]];
    }
    UIImageView *plaIma = cell.ImaArr[tag];
    [HUPhotoBrowser showFromImageView:plaIma withURLStrings:imageArr placeholderImage:plaIma.image atIndex:tag dismiss:^(UIImage *image, NSInteger index) {
        
    }];
    
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

#pragma mark ========== UICollectionViewdelegate
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


#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-NaviHeight64-246) style:UITableViewStylePlain];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64-246) collectionViewLayout:layout];
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
