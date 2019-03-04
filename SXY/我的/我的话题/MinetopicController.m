//
//  MinetopicController.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MinetopicController.h"
#import "TopicDetailController.h"
#import "TopicCell.h"
#import "WantBuyModel.h"

@interface MinetopicController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;

@end

@implementation MinetopicController{
    
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的话题";
    _dataArr = [NSMutableArray arrayWithCapacity:0];

    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadList];
}

- (void)loadList{
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"isExpiration":@"false",
                          @"goodsModules":@[@"3"],
                          @"userId":user.userId,
                          };
    
    /*
     NSDictionary *dic = @{@"goodsModules":@[@"3"],
     @"pageNo":self.pageArr[_selectedIndex],
     @"pageSize":@"10",
     @"userId":_userId
     };
     */
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSMutableArray *reArr = [WantBuyModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self setDataArrWithArr:reArr];
        if (_dataArr.count<=0) {
            self.nothingIma.hidden = NO;
            [self.view bringSubviewToFront:self.nothingIma];
        }else{
            self.nothingIma.hidden = YES;
        }
        NSLog(@"%@",returnValue);
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
}


- (void)setDataArrWithArr:(NSMutableArray*)returnArr{
    
    NSMutableArray *timeArr = [NSMutableArray arrayWithCapacity:0];
    for (WantBuyModel *model in returnArr) {
        // iOS 生成的时间戳是10位
        NSString *dateString       = [GlobalMethod returnTimeStrWith:model.addTime];
        model.addTime = dateString;
        if (![timeArr containsObject:dateString]) {
            [timeArr addObject:dateString];
            [_dataArr addObject:[NSMutableArray arrayWithCapacity:0]];
        }
    }
    
    for (int i = 0; i<timeArr.count; i++)
    {
        NSString *timeStr = timeArr[i];
        NSMutableArray *dataArr = _dataArr[i];
        for (WantBuyModel *model in returnArr)
        {
            if ([model.addTime isEqualToString:timeStr]) {
                [dataArr addObject:model];
            }
          
        }
        
        
    }
    [self.ListTab reloadData];
    
    
}




- (void)initUI{
    [self.view addSubview:self.ListTab];
 
}
#pragma mark ========= tabbleviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *arr = _dataArr[section];
    return  [self returnViewWithModel:arr[0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    NSMutableArray *arr = _dataArr[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TopicCellId = @"TopicCellId";
    TopicCell  *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellId];
    if (!cell) {
        cell = [[TopicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicCellId];
    }
    NSMutableArray *arr = _dataArr[indexPath.section];
    cell.model = arr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arr = _dataArr[indexPath.section];
    WantBuyModel *model = arr[indexPath.row];
    TopicDetailController *deVc = [[TopicDetailController alloc]init];
    deVc.topId = model.theID;
    deVc.userId = model.userId;
    deVc.title = model.userName;
    deVc.faceIma = nil;
    deVc.faceImaStr = model.userPhoto;
    [self.navigationController pushViewController:deVc animated:YES];
    
}



- (UIView *)returnViewWithModel:(WantBuyModel *)model{
    
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 50) color:UIColorFromRGB(WhiteColorValue)];
    
    UILabel *timeLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 0, ScreenWidth-40, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT18 textAligment:NSTextAlignmentLeft andtext:model.addTime];
    [view addSubview:timeLab];
   
    return view;
}





#pragma mark ==== get

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
