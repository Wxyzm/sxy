//
//  PeopleNeedsView.m
//  ZhongFangTong
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "PeopleNeedsView.h"

@interface PeopleNeedsView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong) BaseTableView       *ListTab;

@end

@implementation PeopleNeedsView{
    
    BOOL        _isShow;
    
}

#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];
    [self addSubview:self.ListTab];
}

-(void)setDataArr:(NSArray *)dataArr{
    
    _dataArr = dataArr;
    [self.ListTab reloadData];
}


#pragma mark ===== tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001;
    }
    return 10;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [UIView new];
    }
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) color:[UIColor clearColor]];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _dataArr.count;
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 43, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
        [cell.contentView addSubview:view];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.frame = CGRectMake(0, 0, ScreenWidth, 44);
    cell.textLabel.font = APPFONT15;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, ScreenWidth, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT15 textAligment:NSTextAlignmentCenter andtext:@""];
//    [cell.contentView addSubview:lab];
    if (indexPath.section == 0) {
        cell.textLabel.text = _dataArr[indexPath.row];

    }else{
        cell.textLabel.text = @"取消";
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
            if (self.returnBlock) {
                self.returnBlock(_dataArr[indexPath.row]);
                [self dismiss];
            }
        }
    }else{
        [self dismiss];
    }
    
}



#pragma - mark public method
- (void)showinView:(UIView *)view
{
    [view addSubview:self];
    _ListTab.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (_dataArr.count +1) *44+10);
    
     _isShow = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _ListTab.frame = CGRectMake(0, ScreenHeight-((_dataArr.count +1) *44+10), ScreenWidth, (_dataArr.count +1)*44+10);
       
        
    }];
    
    
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _ListTab.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (_dataArr.count +1) *44+10);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

#pragma mark ========= get

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
        //        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 1) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = [UIColor clearColor];
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        _ListTab.bounces = NO;
        
    }
    return _ListTab;
    
}

@end
