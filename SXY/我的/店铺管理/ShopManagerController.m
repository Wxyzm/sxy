//
//  ShopManagerController.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ShopManagerController.h"
#import "ShopAllProController.h"
#import "FourPalacesCell.h"
#import "ShopManangeTopCell.h"
#import "ProDetailController.h"
#import "MineInfoModel.h"
#import "GoodsEditController.h"
@interface ShopManagerController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;

@end

@implementation ShopManagerController{
    
    MineInfoModel *_model;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺管理";
    [self setBarBackBtnWithImage:nil];
    _dataArr1 = [NSMutableArray arrayWithCapacity:0];
    _dataArr2 = [NSMutableArray arrayWithCapacity:0];

    [self initUI];
    [self loadMineInfo];
    [self loadxianProList];
    [self loadgongProList];
    
}


- (void)initUI{
    [self.view addSubview:self.ListTab];
    
}



- (void)loadStoreInfo{
    
    [StockPL Store_StoreFindMyStoreDetailWithDic:nil withReturnBlock:^(id returnValue) {
        
//        NSLog(@"%@",returnValue);
//        _model = [StockModel mj_objectWithKeyValues:returnValue];
//        [self.ListTab reloadData];
        
    } andErrorBlock:^(NSString *msg) {
        
    }];
   
}

#pragma mark ========= 加载个人信息

- (void)loadMineInfo{
    User *user = [[UserPL shareManager]getLoginUser];
    NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",user.userId]};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _model = [MineInfoModel mj_objectWithKeyValues:returnValue[@"result"]];
        [self.ListTab reloadData];
    } andErrorBlock:^(NSString *msg) {
        [self.ListTab.mj_header endRefreshing];
    }];
    
    
    
    
}




- (void)loadxianProList{
    
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"goodsModule":@"1",
                          @"pageNo":@"1",
                          @"status":@"3",
                          @"pageSize":@"10",
                          @"userId":user.userId
                          };
    [GEditPL Goods_GoodsGetGoodsListWithDic:dic WithReturnBlock:^(id returnValue) {
        _dataArr1 = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)loadgongProList{
    
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"goodsModule":@"2",
                          @"pageNo":@"1",
                          @"status":@"3",
                          @"pageSize":@"10",
                          @"userId":user.userId
                          };
    [GEditPL Goods_GoodsGetGoodsListWithDic:dic WithReturnBlock:^(id returnValue) {
        _dataArr2 = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
}



#pragma mark ======= tabbleviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 126;
    }else if (indexPath.row == 1){
         return [FourPalacesCell cellHeightWithArr:_dataArr1];
    }
    return [FourPalacesCell cellHeightWithArr:_dataArr2];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        static NSString *TopicCellId = @"ShopManangeTopCell";
        ShopManangeTopCell  *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellId];
        if (!cell) {
            cell = [[ShopManangeTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicCellId];
        }
        if (_model) {
            cell.model = _model;

        }
        return cell;
    }
    
    static NSString *ShopManangeCellId = @"ShopManangeCell";
    FourPalacesCell  *cell = [tableView dequeueReusableCellWithIdentifier:ShopManangeCellId];
    if (!cell) {
        cell = [[FourPalacesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShopManangeCellId];
    }
    if (indexPath.row ==1) {
        cell.FourPalacesArr = _dataArr1;
        cell.nameLab.text = @"现货管理";
    }else if (indexPath.row ==2){
        cell.FourPalacesArr = _dataArr2;
        cell.nameLab.text = @"供应管理";
    }
    
    [cell setReturnBlock:^(FourPalacesCell *cell, GoodsModel *model) {
        if (model) {
            [self gotoDetailVCWithId:model];
        }else{
            //更多
            [self gotoAllProvcWithIndex:indexPath.row];
        }
    }];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}

#pragma mark ==== 前往详情页面

- (void)gotoDetailVCWithId:(GoodsModel *)tmodel{
    
    GoodsEditController *edVc = [[GoodsEditController alloc]init];
    edVc.nowModel = tmodel;
    [edVc setReturnBlock:^(GoodsModel * _Nonnull model) {
        [_dataArr1 removeAllObjects];
        [_dataArr2 removeAllObjects];
        [self.ListTab reloadData];
        [self loadgongProList];
        [self loadxianProList];
    }];
    [self.navigationController pushViewController:edVc animated:YES];
}


- (void)gotoAllProvcWithIndex:(NSInteger)row{
    
    ShopAllProController *allVc = [[ShopAllProController alloc]init];
    if (row == 1) {
         //现货
        allVc.releaseType = ReleaseType_GoodsInStock;
        allVc.title = @"现货管理";
    }else{
         //供应
        allVc.releaseType = ReleaseType_Supply;
        allVc.title = @"供应管理";

    }
    [self.navigationController pushViewController:allVc animated:YES];
}


#pragma mark ======= get

-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
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
