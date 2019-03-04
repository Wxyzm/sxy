//
//  HomeController.m
//  SXY
//
//  Created by yh f on 2018/11/8.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "HomeController.h"
#import "HomeViewHeader.h"
#import "ProDetailController.h"
#import "MineWantController.h" //我的求购
#import "AllProListController.h"//全部商品
#import "HomeSearchController.h"//搜索
#import "RadioDetailController.h"

@interface HomeController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;


@end

@implementation HomeController{
    
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self initUI];
    [self loadHomeList];

    
}

- (void)initUI{
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.ListTab];
}


- (void)loadHomeList{
    NSDictionary *dic = @{
                          @"allCount":@"10",
                          @"carouseCount":@"10",
                          @"gouCount": @"10",
                          @"newCount": @"10",
                          @"xianCount": @"10"
                          };
    [HomePL Home_HomegetHomeListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [_dataArr removeAllObjects];

        NSArray *carousArr = [CarouseModel mj_objectArrayWithKeyValuesArray:returnValue[@"carouselDTOList"]];
        NSArray *newCountArr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue[@"newGoodsList"]];
        NSArray *xianCountArr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue[@"xianGoodsList"]];
        NSArray *gouCountArr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue[@"qiuGoodsList"]];
        NSArray *allCountArr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue[@"allGoodsList"]];
        [_dataArr addObject:carousArr];
        [_dataArr addObject:newCountArr];
        [_dataArr addObject:gouCountArr];
        [_dataArr addObject:xianCountArr];
        [_dataArr addObject:allCountArr];
        [self.ListTab reloadData];
        [self.ListTab.mj_header endRefreshing];
        
    } withErrorBlock:^(NSString *msg) {
        [self.ListTab.mj_header endRefreshing];

    }];
   
}

- (void)reloadListDatas{
    [self loadHomeList];
    
}

#pragma mark ==== 前往用户店铺
- (void)gotoUserStockWithID:(NSString *)userId{
    if (!userId) {
        return;
    }
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = userId;
    [self.navigationController pushViewController:homeVc animated:YES];
}


#pragma mark ==== 前往详情页面

- (void)gotoDetailVCWithId:(NSString *)proID{
    
    ProDetailController *deVc = [[ProDetailController alloc]init];
    deVc.goodsId = proID;
    [self.navigationController pushViewController:deVc animated:YES];
}

#pragma mark ========= 求购收藏

- (void)collectWantBuyWithModel:(WantBuyModel *)model{
    NSDictionary *dic = @{@"id":model.theID};
    [CollectPL Collect_CollectSaveCircleCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        model.collected = !model.collected;
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}

#pragma mark ========= 全部商品
- (void)gotoAllProvc{
    AllProListController *AllVc = [[AllProListController alloc]init];
    [self.navigationController pushViewController:AllVc animated:YES];
}



#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return [HomeMenueCell cellHeight];
    }else if (indexPath.row == 1){
        return [NewProShowCell cellHeight];
    }else if (indexPath.row == 2){
        return [WantBuyViewCell cellHeight];
    }else if (indexPath.row == 3){
        return [FourPalacesCell cellHeightWithArr:_dataArr[3]];
    }else if (indexPath.row == 4){
        return [FourPalacesCell cellHeightWithArr:_dataArr[4]];
    }
    
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *HomeMenueCellId= @"HomeMenueCellID";
        HomeMenueCell  *cell = [tableView dequeueReusableCellWithIdentifier:HomeMenueCellId];
        if (!cell) {
            cell = [[HomeMenueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeMenueCellId];
        }
        cell.returnBlock = ^(NSInteger tag) {
            if (tag == 1000) {
                //广播
                RadioController *radVc = [[RadioController alloc]init];
                [self.navigationController pushViewController:radVc  animated:YES];
            }else if (tag == 1001){
               //资讯
                NewsController *newsVc = [[NewsController alloc]init];
                [self.navigationController pushViewController:newsVc  animated:YES];
            }else if (tag == 2000){
               
                
            }else if (tag == 2001){
                HomeSearchController *seVc = [[HomeSearchController alloc]init];
                [self.navigationController pushViewController:seVc  animated:YES];
                
            }else{
                
                
            }
            
            
        };
        cell.CarouseArr = _dataArr[0];
        return cell;
    }else if (indexPath.row == 1){
        static NSString *NewProShowCellId= @"NewProShowCellID";
        NewProShowCell  *cell = [tableView dequeueReusableCellWithIdentifier:NewProShowCellId];
        if (!cell) {
            cell = [[NewProShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewProShowCellId];
        }
        cell.proArr = _dataArr[1];
        cell.returnBlock = ^(GoodsModel *model) {
            [self gotoDetailVCWithId:model.theID];
        };
        
        return cell;
    }else if (indexPath.row == 2){
        static NSString *WantBuyViewCellId= @"WantBuyViewCellID";
        WantBuyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WantBuyViewCellId];
        if (!cell) {
            cell = [[WantBuyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WantBuyViewCellId];
        }
        NSArray *arr =  _dataArr[2];
        if (arr.count>0) {
            cell.buyModel = arr[0];

        }
        cell.returnBlock = ^(WantBuyModel *buyModel, NSInteger btntag,WantBuyViewCell *theCell) {
            if (btntag == 0) {
                //更多
                RadioController *radVc = [[RadioController alloc]init];
                [self.navigationController pushViewController:radVc  animated:YES];
            }else if (btntag == 1){
                //收藏
                [self collectWantBuyWithModel:buyModel];
            }else if (btntag == 2){
                [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:buyModel.userName targetId:buyModel.userId];
                //聊天

            }else if (btntag == 3){
                //点头像
               [self gotoUserStockWithID:buyModel.userId];
               
            }else{
                //查看大图
                [self checkBigImageWithCell:theCell andtag:btntag-1000 andModel:buyModel];
            }
        };
        
        return cell;
    }else if (indexPath.row == 3){
        static NSString *FourPalacesCellId= @"FourPalacesCellID";
        FourPalacesCell *cell = [tableView dequeueReusableCellWithIdentifier:FourPalacesCellId];
        if (!cell) {
            cell = [[FourPalacesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FourPalacesCellId];
        }
        cell.FourPalacesArr =  _dataArr[3];
        [cell setReturnBlock:^(FourPalacesCell *cell, GoodsModel *model) {
            if (model) {
                [self gotoDetailVCWithId:model.theID];
            }else{
                //更多
                [self gotoAllProvc];
            }
        }];
        return cell;
    }else if (indexPath.row == 4){
        static NSString *ALLFourPalacesCellId= @"ALLFourPalacesCellID";
        FourPalacesCell *cell = [tableView dequeueReusableCellWithIdentifier:ALLFourPalacesCellId];
        if (!cell) {
            cell = [[FourPalacesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ALLFourPalacesCellId];
        }
        cell.nameLab.text = @"全部";
        cell.FourPalacesArr =  _dataArr[4];
        [cell setReturnBlock:^(FourPalacesCell *cell, GoodsModel *model) {
            if (model) {
                [self gotoDetailVCWithId:model.theID];
            }else{
                //更多
                [self gotoAllProvc];
            }
        }];
        return cell;
    }
    else{
        static NSString *NewProShowCellId= @"NewProShowCellID";
        NewProShowCell  *cell = [tableView dequeueReusableCellWithIdentifier:NewProShowCellId];
        if (!cell) {
            cell = [[NewProShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewProShowCellId];
        }
        return cell;
        
    }
    
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        //最新求购
        NSArray *arr =  _dataArr[2];
        WantBuyModel *model;
        if (arr.count>0) {
            model = arr[0];
            
        }
        RadioDetailController *redDeVC = [[RadioDetailController alloc]init];
        redDeVC.radioId = model.theID;
        [self.navigationController pushViewController:redDeVC animated:YES];
    }
    
    
}




#pragma mark ==== 查看大图
- (void)checkBigImageWithCell:(WantBuyViewCell *)cell andtag:(NSInteger)tag andModel:(WantBuyModel*)model{
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

#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
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
