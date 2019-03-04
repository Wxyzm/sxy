//
//  RadioController.m
//  SXY
//
//  Created by yh f on 2019/1/2.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "RadioController.h"
#import "ReleaseTypeChoseController.h"
#import "RadioDetailController.h"
#import "LBNavigationController.h"
#import "ChoseTopView.h"
#import "CircleCell.h"
@interface RadioController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic , strong) NSMutableArray *pageArr;     //列表页数
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation RadioController{
    
    NSInteger _selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广播";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self setRightBtnWithTitle:@"发布" andColor:UIColorFromRGB(BTNColorValue)];
    [self initUI];
    [self loadList];

}

- (void)initUI{
    
    _pageArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _selectedIndex = 0;
    
    
    NSArray *nameArr = @[@"全部",@"现货",@"供应",@"求购"];
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
        NSMutableArray *dataArr = _dataArr[index];
        self.nothingIma.hidden = YES;

        if (dataArr.count<=0) {
            [self loadList];
        }else{
            [self.ListTab reloadData];
        }
        
    }];
    
   
   
}

- (void)reloadListDatas{
    self.loadWay = RELOAD_DADTAS ;
    [self loadList];
}


- (void)respondToRigheButtonClickEvent{
    
    ReleaseTypeChoseController *reVC = [[ReleaseTypeChoseController alloc]init];
    reVC.isHiddenSoutu = YES;
    LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:reVC];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark ========= 获取数据
// "goodsModules": "0：求购 1：现货  2：供应链   3：话题",

- (void)loadList{
    NSDictionary *dic;
    if (_selectedIndex == 0) {
        dic = @{@"status":@"3",
                @"goodsModules":@[@"0",@"1",@"2"],
                };
    }else if (_selectedIndex == 1){
        dic = @{
                @"goodsModules":@[@"1"],
                @"status":@"3",
                };
    }else if (_selectedIndex ==2){
        dic = @{
                @"goodsModules":@[@"2"],
                @"status":@"3",
                };
    }else if (_selectedIndex == 3){
        dic = @{
                @"goodsModules":@[@"0"],
                @"status":@"3",
                };
    }
    [HUD showLoading:nil];
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSMutableArray *arr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
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
//    [dataArr removeAllObjects];
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

#pragma mark ====== tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *dataArr = _dataArr[_selectedIndex];
    return [CircleCell cellHeightWithModel:dataArr[indexPath.row]];
    
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

#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 52, ScreenWidth, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
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
