//
//  ChoseStockController.m
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "ChoseStockController.h"
#import "ChoseStockCell.h"
#import "ChoseTopView.h"
@interface ChoseStockController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;


@end

@implementation ChoseStockController{
    
    NSInteger _selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择现货";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
    [self loadList];

}



- (void)initUI{
    
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _selectedIndex = 0;
    
    
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
    ChoseTopView *topView = [[ChoseTopView alloc]initWithArr:topArr];
    topView.frame = CGRectMake(0, 0, ScreenWidth, 49);
    [self.view addSubview:topView];
    [self.view addSubview:self.ListTab];
    
    [topView setReturnBlock:^(NSInteger index) {
        _selectedIndex = index;
        self.nothingIma.hidden = YES;

        NSMutableArray *dataArr = _dataArr[index];
        if (dataArr.count<=0) {
           [self loadList];
        }else{
            [self.ListTab reloadData];
        }
       
    }];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64-80, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:line];
    
    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"确认" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setAllInfo) forControlEvents:UIControlEventTouchUpInside];
    setBtn.layer.cornerRadius = 22;
}

- (void)reloadListDatas{
    self.loadWay = RELOAD_DADTAS ;
    [self loadList];
}

#pragma mark ========= 获取数据
- (void)loadList{
    NSDictionary *dic;
    User *user = [[UserPL shareManager] getLoginUser];
    if (_selectedIndex == 0) {
        dic = @{@"status":@"3",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId
                };
    }else if (_selectedIndex == 1){
        dic = @{@"goodsCategoryId":@"3",
                @"status":@"3",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId
                };
    }else if (_selectedIndex ==2){
        dic = @{@"goodsCategoryId":@"4",
                @"status":@"3",
                @"goodsModule":[NSString stringWithFormat:@"%ld",_releaseType],
                @"userId":user.userId
                };
    }else if (_selectedIndex == 3){
        dic = @{@"goodsCategoryId":@"6",
                @"status":@"3",
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
}

- (void)endLoading{
    [self.ListTab.mj_header endRefreshing];
    [self.ListTab.mj_footer endRefreshing];
    
}


/**
 确认
 */
- (void)setAllInfo{
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    GoodsModel *semodel;
    for (GoodsModel *model in dataArr) {
        if (model.isSelected) {
            semodel = model;
        }
    }
    
    if (!semodel) {
        [HUD show:@"请选择现货"];
        return;
    }
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(semodel);
        [weakself.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
    
}


#pragma mark ========= tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    ChoseStockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ChoseStockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    cell.model = dataArr[indexPath.row];
    cell.returnBlock = ^(GoodsModel *model) {
        NSMutableArray *dataArr = _dataArr[_selectedIndex];
        for (GoodsModel *tmodel in dataArr) {
            tmodel.isSelected = NO;
        }
        model.isSelected = YES;
        [self.ListTab reloadData];
    };
    return cell;
}




#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, ScreenHeight-49-NaviHeight64-80) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
                _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        //        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}


@end
