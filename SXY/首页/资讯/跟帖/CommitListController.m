//
//  CommitListController.m
//  SXY
//
//  Created by yh f on 2019/1/5.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "CommitListController.h"
#import "CommentModel.h"
#import "CommentCell.h"
@interface CommitListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)BaseTableView *ListTab;

@end

@implementation CommitListController{
    
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"跟帖";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadComment];
}


- (void)initUI{
    self.page = 1;
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.ListTab];
    
}

- (void)loadComment{
    
    NSDictionary *dic = @{@"pageNo":[NSString stringWithFormat:@"%ld",self.page],
                          @"pageSize":@"10",
                          @"objectId":_newsId
                          
                          };
      [HUD showLoading:nil];
    [CommentPL Comment_CommentGetNewsCommentListWithDic:dic withReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
         [HUD cancel];
        NSMutableArray *dataArr = [CommentModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:dataArr];
        [self.ListTab reloadData];
        [self endLoading];

    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];
}

- (void)loadSuccessWithArr:(NSMutableArray *)suArr{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    [_dataArr addObjectsFromArray:suArr];
    if (_dataArr.count<=0) {
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
- (void)setPageCount{
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        self.page = 1;
    }
    self.page ++;
}

//上拉加载下拉刷新
- (void)reloadListDatas{
    self.page = 1;
    self.loadWay = RELOAD_DADTAS ;
    [self loadComment];
}

- (void)loadmoreData{
    self.loadWay = LOAD_MORE_DATAS ;
    [self loadComment];
    
}
#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = _dataArr[indexPath.row];
    
    return [CommentCell cellHeightWithModel:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *HomeMenueCellId= @"HomeMenueCellID";
    CommentCell  *cell = [tableView dequeueReusableCellWithIdentifier:HomeMenueCellId];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeMenueCellId];
    }
    CommentModel *model = _dataArr[indexPath.row];
    cell.model = model;
    cell.returnBlock = ^(CommentModel *model) {
        [self gotoUserStockWithID:model.userId];
    };
    return cell;
}


#pragma mark ==== 前往用户店铺
- (void)gotoUserStockWithID:(NSString *)userId{
    
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = userId;
    [self.navigationController pushViewController:homeVc animated:YES];
}



#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.scrollEnabled = NO;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
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

@end
