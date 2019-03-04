//
//  ProParaMView.m
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ProParaMView.h"
#import "ParaMCell.h"
#import "GoodsModel.h"
#import "SpecListModel.h"
@interface ProParaMView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) BaseTableView *ListTab;


@end
@implementation ProParaMView{
    NSMutableArray *_dataArr;
    UIImageView *_logoIma;
    UILabel *_nameLab;
    
    
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        [self setUP];
    }
    
    return self;
}

- (void)setUP{
    
    
    UIView *logoView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 66) color:UIColorFromRGB(0xFAFAFA)];
    [self addSubview:logoView];
    
    _logoIma =  [[UIImageView alloc]init];
    _logoIma.contentMode = UIViewContentModeScaleAspectFill;
    _logoIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _logoIma.clipsToBounds = YES;
    [logoView addSubview:_logoIma];
    _logoIma.frame = CGRectMake(22, 14, 32, 32);
    _logoIma.layer.cornerRadius = 16;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(68, 0, ScreenWidth-93, 60) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"CLIO柯莱欧"];
    [logoView addSubview:_nameLab];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoView addSubview:logBtn];
    logBtn.frame = CGRectMake(0, 0, ScreenWidth, 66);
    [logBtn addTarget:self action:@selector(logBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *paramLab =  [BaseViewFactory labelWithFrame:CGRectMake(25, 66, ScreenWidth-93, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"商品参数"];
    [self addSubview:paramLab];
    [self addSubview:self.ListTab];

}

#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArr.count-1) {
        NSString *memo = _dataArr[indexPath.row];
        CGFloat weight = [GlobalMethod widthForString:@"备注：" andFont:APPFONT(14)] +35;
        CGFloat height = [GlobalMethod heightForString:memo andWidth:ScreenWidth- weight-60 andFont:APPFONT(14)] +20;
        if (height<48) {
            height =48;
        }
        return height;
    }
    return 48;
    
    //return [ParaMCell cellHeightWithtitleStr:@"颜色：" andmemoStr:@"多彩"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == _dataArr.count-1) {
        static NSString *downCellId= @"downCellId";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downCellId];
        if (!cell) {
            cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downCellId];
            
            CGFloat weight = [GlobalMethod widthForString:@"备注：" andFont:APPFONT(14)] +35;
            CGFloat height = [GlobalMethod heightForString:_dataArr[indexPath.row] andWidth:ScreenWidth- weight-60 andFont:APPFONT(14)];
            
            UILabel  *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(25, 0, weight, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"备注："];
            [cell.contentView addSubview:nameLab];
            
            UILabel  *memoLab = [BaseViewFactory labelWithFrame:CGRectMake(weight +35, 17, ScreenWidth- weight-60, height) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:_dataArr[indexPath.row]];
            memoLab.numberOfLines = 0;
            [cell.contentView addSubview:memoLab];
   
        }
        
        return cell;
    }
    
    
    static NSString *ParaMCellId= @"ParaMCellId";
    ParaMCell  *cell = [tableView dequeueReusableCellWithIdentifier:ParaMCellId];
    if (!cell) {
        cell = [[ParaMCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ParaMCellId];
    }
    NSArray *nameArr = @[@"花型号：",@"幅宽：",@"颜色：",@"克重：",@"数量：",@"单位：",@"成份：",@"备注："];
    cell.nameLab.text = nameArr[indexPath.row];
    cell.valueLab.text = _dataArr[indexPath.row];
    return cell;


}


-(void)setModel:(GoodsModel *)model{
    _model = model;
    [_logoIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.logo andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.storeName;
    
    if (model.specDTOList.count<=0) {
        return;
    }
    SpecListModel *speModel = model.specDTOList[0];
    [_dataArr removeAllObjects];
    NSArray *arr = @[speModel.pattern,speModel.width,speModel.color,speModel.goodsWeight,speModel.inv,speModel.goodsUnit,speModel.component,speModel.remarks.length>0?speModel.remarks:@""];
    [_dataArr addObjectsFromArray:arr];
    [self .ListTab reloadData];
    NSString *memo = _dataArr[_dataArr.count-1];
    CGFloat weight = [GlobalMethod widthForString:@"备注：" andFont:APPFONT(14)] +35;
    CGFloat height = [GlobalMethod heightForString:memo andWidth:ScreenWidth- weight-60 andFont:APPFONT(14)] +20;
    if (height<48) {
        height =48;
    }
    _ListTab.frame = CGRectMake(0, 114, ScreenWidth, height +48 *7);

    
    
    
    
}


- (void)logBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 0);
    }
    
}



#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 114, ScreenWidth, 48 *8) style:UITableViewStylePlain];
        _ListTab.bounces = NO;
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
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
