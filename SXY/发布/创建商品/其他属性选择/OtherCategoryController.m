//
//  OtherCategoryController.m
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "OtherCategoryController.h"
#import "CategoryModel.h"
#import "ShowModel.h"
@interface OtherCategoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *ListTab;


@end

@implementation OtherCategoryController{
    
    NSMutableArray *_dataArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self loadDatas];
     [self initUI];
}

- (void)initUI{
    
    [self.view addSubview:self.ListTab];
}

- (void)loadDatas{
    
    switch (_type) {
        case CategorType_Width:
        {
            //幅宽
            self.title = @"选择幅宽";
            [self getClothWidthList];
            break;
        }
        case CategorType_Comp:
        {
            //成分
            self.title = @"选择成份";
            [self getComponentList];
            break;
        }
        case CategorType_time:
        {
            //时间
            self.title = @"选择时间";
            [self getVailddaysList];
            break;
        }
        case CategorType_vail:
        {
            //单位
            self.title = @"选择单位";
            [self getUnitList];
            break;
        }
        default:
            break;
    }
    
}


- (void)getClothWidthList{
    NSDictionary *dic = @{@"":@""};
    [CategoryPL Category_CategoryGetClothWidthListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _dataArr = [CategoryModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}
- (void)getComponentList{
    NSDictionary *dic = @{@"":@""};
    [CategoryPL Category_CategoryGetComponentListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _dataArr = [CategoryModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}
- (void)getVailddaysList{
    NSDictionary *dic = @{@"":@""};
    [CategoryPL Category_CategoryGetVailddaysListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _dataArr = [CategoryModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}


- (void)getUnitList{
    NSDictionary *dic = @{@"":@""};
    [CategoryPL Category_CategoryGetUnitListWithDic:dic WithReturnBlock:^(id returnValue) {
         NSLog(@"%@",returnValue);
        _dataArr = [CategoryModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.ListTab reloadData];
    } withErrorBlock:^(NSString *msg) {
        
    }];
 
}

#pragma mark ========= tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid =@"cellid";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellid] ;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.frame = CGRectMake(0, 0, ScreenWidth, 62);
        cell.textLabel.font = APPFONT14;
        cell.textLabel.textColor = UIColorFromRGB(BlackColorValue);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    CategoryModel *model = _dataArr[indexPath.row];
    if (model.name2.length>0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@",model.name,model.name2];
    }else{
        cell.textLabel.text = model.name;
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryModel *model = _dataArr[indexPath.row];
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ========= get
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
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
}



@end
