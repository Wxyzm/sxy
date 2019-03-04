//
//  MineBoardCastController.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineBoardCastController.h"
#import "BroadCastCell.h"
#import "CollectCirModel.h"

@interface MineBoardCastController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;

@end

@implementation MineBoardCastController{
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的广播";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
    [self loadBoardList];
}


- (void)initUI{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.ListTab];

}



- (void)loadBoardList{
    
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"isExpiration":@"false",
                          @"status":@"",
                          @"id":@"",
                          @"title":@"",
                          @"userId":user.userId,
                          @"content":@""
                          };
    [CirclePL Circle_CircleGetCircleListWithDic:dic WithReturnBlock:^(id returnValue) {
       _dataArr = [CollectCirModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
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



#pragma mark ========= tabbleviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [BroadCastCell cellHeightWithModel:_dataArr[indexPath.row]];
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *BroadCastCellcellId = @"BroadCastCell";
    BroadCastCell  *cell = [tableView dequeueReusableCellWithIdentifier:BroadCastCellcellId];
    if (!cell) {
        cell = [[BroadCastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BroadCastCellcellId];
    }
    cell.model = _dataArr[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}





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
