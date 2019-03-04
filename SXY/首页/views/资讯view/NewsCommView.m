//
//  NewsCommView.m
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsCommView.h"
#import "CommentCell.h"
#import "CommentModel.h"
@interface NewsCommView ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)BaseTableView *ListTab;



@end


@implementation NewsCommView{
    
    UILabel *_titleLab;
    
    
}



-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 6) color:UIColorFromRGB(BackColorValue)];
    [self addSubview:topLine];
    
    UILabel * titleLab = [BaseViewFactory labelWithFrame:CGRectMake(17, 6, 200, 44 ) textColor:UIColorFromRGB(0x3e3d3e) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@"热门跟贴"];
    [self addSubview:titleLab];

    
    _moreBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(ScreenWidth-58, 10, 48, 36) font:APPFONT12 title:@"更多" titleColor:UIColorFromRGB(BackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [_moreBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self addSubview:_moreBtn];
    [_moreBtn setTitleRect:CGRectMake(0, 0, 24, 36)];
    [_moreBtn setImageRect:CGRectMake(24, 4, 24, 36)];
    
    [self addSubview:self.ListTab];
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    NSInteger a = dataArr.count;
    if (a>2) {
        a = 2;
    }
    CGFloat height =0;

    for (int i = 0; i<a; i++) {
        CommentModel *model = dataArr[i];
        CGFloat modelheight = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -106 andFont:APPFONT12];
        height += modelheight +93;
    }
    self.ListTab.frame = CGRectMake(0, 50, ScreenWidth, height);
    [self.ListTab reloadData];
}

+(CGFloat)ViewHeightWithArr:(NSMutableArray *)dataArr{
    
    CGFloat height =50;
    NSInteger a = dataArr.count;
    if (a>2) {
        a = 2;
    }
    for (int i = 0; i<a; i++) {
        CommentModel *model = dataArr[i];
        CGFloat modelheight = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -106 andFont:APPFONT12];
        height += modelheight +93;
    }
    
    return height;
}


#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArr.count>2) {
        return 2;
    }
    
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
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.scrollEnabled = NO;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
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
