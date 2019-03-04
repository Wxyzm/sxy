//
//  MineWantController.m
//  SXY
//
//  Created by yh f on 2018/11/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineWantController.h"
#import "WantDetailController.h"
#import "MineWantCell.h"
#import "WantBuyModel.h"
@interface MineWantController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;


@end

@implementation MineWantController{
    
    NSInteger _selectedIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的求购";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadDataList];
}

- (void)initUI{
    
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _selectedIndex = 0;
    
    NSArray *nameArr = @[@"求购中",@"已关闭"];
    NSMutableArray *topArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<2; i++) {
        TopModel *model = [[TopModel alloc]init];
        model.title = nameArr[i];
        model.selectedId = [NSString stringWithFormat:@"%d",i];
        [topArr addObject:model];
        [self.dataArr addObject:[NSMutableArray arrayWithCapacity:0]];
        [self.pageArr  addObject:@"1"];
        
    }
    TopView *topView = [[TopView alloc]initWithArr:topArr];
    topView.frame = CGRectMake(0, 0, ScreenWidth, 49);
    [self.view addSubview:topView];
    [self.view addSubview:self.ListTab];
    
    [topView setReturnBlock:^(NSInteger index) {
        _selectedIndex = index;
        [self reloadList];
    }];
    
    
}


- (void)loadDataList{

    NSString *isExpiration;
    if (_selectedIndex == 0) {
        isExpiration = @"false";
    }else{
        isExpiration = @"true";
    }
    User *user = [[UserPL shareManager] getLoginUser];
    
    NSDictionary *dic = @{@"expiration":isExpiration,
                          @"userId":user.userId,
                          @"goodsModules":@[@"0"]
                          };
     [HUD showLoading:nil];
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
         [HUD cancel];
        NSMutableArray *arr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
         [self endLoading];
    }];
    
    

}

#pragma mark ======== 上拉加载下拉刷新

- (void)reloadList{
    [_pageArr replaceObjectAtIndex:_selectedIndex withObject:@"1"];
    self.loadWay = RELOAD_DADTAS ;
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
    
}

#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return [MineWantCell cellheightWithModel:dataArr[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *wantCellId= @"MIneTopCellID";
    MineWantCell  *cell = [tableView dequeueReusableCellWithIdentifier:wantCellId];
    if (!cell) {
        cell = [[MineWantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wantCellId];
    }
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    cell.model = dataArr[indexPath.row];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    WantBuyModel *model  = dataArr[indexPath.row];
    WantDetailController *deVC = [[WantDetailController alloc]init];
    deVC.wantID = model.theID;
    [self.navigationController pushViewController:deVC animated:YES];
    
}





#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, ScreenHeight-49-NaviHeight64) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        //        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        //        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}


@end
