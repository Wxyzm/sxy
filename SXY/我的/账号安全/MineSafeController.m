//
//  MineSafeController.m
//  SXY
//
//  Created by yh f on 2018/11/22.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineSafeController.h"
#import "SafeCell.h"
#import "ShowModel.h"

#import "TureNameController.h"
#import "ComTureNameController.h"
#import "PhoneBindController.h"

@interface MineSafeController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;

@end

@implementation MineSafeController{
    
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号安全";
    [self setBarBackBtnWithImage:nil];
    [self initDatas];
    [self loadUserInfo];
  
}


- (void)initUI{
    [self.view addSubview:self.ListTab];
    
}

- (void)initDatas{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
  
}


#pragma mark ======= tabbleviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001;
    }
    
    return 6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 6) color:UIColorFromRGB(0xF4F4F4)];
    
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *SafeCellId = @"SafeCellId";
    SafeCell  *cell = [tableView dequeueReusableCellWithIdentifier:SafeCellId];
    if (!cell) {
        cell = [[SafeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SafeCellId];
    }
    NSArray *titleArr;
    if (indexPath.section ==0) {
        titleArr = @[@"实名认证",@"企业认证"];
        NSMutableArray *dataArr1 = _dataArr[0];
        ShowModel *model = dataArr1[indexPath.row];
        if ([model.actueValue intValue]==2) {
            cell.statusLab.text = @"审核中";
        }else if ([model.actueValue intValue]==3){
            cell.statusLab.text = @"已认证";
        }else{
            cell.statusLab.text = @"未绑定";
        }
        
    }else{
        titleArr = @[@"手机绑定",@"微信",@"QQ"];

    }
    cell.nameLab.text = titleArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSMutableArray *dataArr1 = _dataArr[0];
        ShowModel *model = dataArr1[indexPath.row];
        if ([model.actueValue intValue]==2) {
            [HUD show:@"您的认证正在审核中"];
            return;
        }else if ([model.actueValue intValue]==3){
             [HUD show:@"您的认证已通过"];
             return;
        }
        switch (indexPath.row) {
            case 0:{
                TureNameController *tnamevc = [[TureNameController alloc]init];
                [self.navigationController pushViewController:tnamevc animated:YES];
                break;
            }
            case 1:{
                ComTureNameController *tnamevc = [[ComTureNameController alloc]init];
                [self.navigationController pushViewController:tnamevc animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        
        switch (indexPath.row) {
            case 0:{
                PhoneBindController *tnamevc = [[PhoneBindController alloc]init];
                [self.navigationController pushViewController:tnamevc animated:YES];
                break;
            }
            case 1:{
             
                break;
            }
            default:
                break;
        }
        
    }
    
    
    
}






#pragma mark ======= 加载数据

- (void)loadUserInfo{
    
    [HUD showLoading:nil];
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"id":user.userId};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        NSDictionary *dic = returnValue[@"result"];
        NSMutableArray *dataArr1 = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *dataArr2 = [NSMutableArray arrayWithCapacity:0];
        NSArray *valueArr = @[[dic objectForKey:@"realNameAuth"],[dic objectForKey:@"companyAuth"]];
        for (int i = 0; i<2; i++) {
            ShowModel *model = [[ShowModel alloc]init];
            model.actueValue = valueArr[i];
            [dataArr1 addObject:model];
        }
        [_dataArr addObject: dataArr1];
        [_dataArr addObject: dataArr2];
        [self initUI];
    } andErrorBlock:^(NSString *msg) {
          [HUD cancel];
    }];
    
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
