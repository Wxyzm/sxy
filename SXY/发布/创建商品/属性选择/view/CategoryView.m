//
//  CategoryView.m
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CategoryView.h"
#import "CategoryCell.h"
#import "CategoryModel.h"
#import "CategoryAddCell.h"
@interface CategoryView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic, strong) BaseTableView *secondTab;

@property (nonatomic, strong) BaseTableView *thirdTab;


@end
@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    [self addSubview:self.ListTab];
    [self addSubview:self.secondTab];
    [self addSubview:self.thirdTab];
    UIView *backView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth/3, 0, 1, ScreenHeight-NaviHeight64) color:UIColorFromRGB(BackColorValue)];
    [self addSubview:backView];
    UIView *backView1 = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth/3*2, 0, 1, ScreenHeight-NaviHeight64) color:UIColorFromRGB(BackColorValue)];
    [self addSubview:backView1];
}


-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.ListTab reloadData];
    [self.secondTab reloadData];
    [self.thirdTab reloadData];

}




#pragma mark ========= TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ListTab) {
        return _dataArr.count;

    }else if (tableView == self.secondTab){
        for (CategoryModel *model in _dataArr)
        {
            if (model.isSelected)
            {
                return model.CategoryArr.count;
            }
            
        }
    }
    CategoryModel *model = [self reTurnSecondModel];
    return model.CategoryArr.count + 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.thirdTab&&indexPath.row == 0) {
        static NSString *cellid = @"CategoryAddCell";
        CategoryAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[CategoryAddCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

        }
        [cell.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
       

        return cell;
    }
   
    
    static NSString *cellid = @"cellid";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    
    if (tableView == self.ListTab)
    {
        cell.model = _dataArr[indexPath.row];
        cell.deleteBtn.hidden = YES;
    }else if (tableView == self.secondTab){
        CategoryModel *model = [self reTurnOneModel];
        cell.model =model.CategoryArr[indexPath.row];
        cell.deleteBtn.hidden = YES;

    }else{
        CategoryModel *model = [self reTurnSecondModel];
        cell.model =model.CategoryArr[indexPath.row-1];
        cell.returnBlock = ^(CategoryModel *model) {
            //删除该类
            [self deleteCateWithmodel:model];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.ListTab ) {
        for (CategoryModel *model in _dataArr) {
            model.isSelected = NO;
        }
        //一级
        CategoryModel *model = _dataArr[indexPath.row];
        model.isSelected = YES;
        //设置二级
        [self setselectedTwoModel];
        //设置三级
        [self setselectedThreeModel];
        
        
        [self.ListTab reloadData];
        [self.secondTab reloadData];
        [self.thirdTab reloadData];

    }else if (tableView == self.secondTab){
        CategoryModel *tmodel = [self reTurnOneModel];
        for (CategoryModel *model in tmodel.CategoryArr) {
            model.isSelected = NO;
        }
        CategoryModel *model = tmodel.CategoryArr[indexPath.row];
        model.isSelected = YES;

        [self setselectedThreeModel];
        [self.secondTab reloadData];
        [self.thirdTab reloadData];
        
    }else{
        if (indexPath.row ==0) {
            
            
            return;
        }
        CategoryModel *onemodel = [self reTurnOneModel];
        CategoryModel *tmodel = [self reTurnSecondModel];
      

        for (CategoryModel *model in tmodel.CategoryArr) {
            model.isSelected = NO;
        }
        CategoryModel *model = tmodel.CategoryArr[indexPath.row-1];
        model.isSelected = YES;
        [self.thirdTab reloadData];

    }
    
   
}

#pragma mark ===== 删除该类
- (void)deleteCateWithmodel:(CategoryModel *)model{
    NSDictionary *dic = @{@"id":model.theId};
    [HUD showLoading:nil];
    [CategoryPL Category_CategorydeleteUserCategoryWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        CategoryModel *tmodel = [self reTurnSecondModel];
        if ([tmodel.CategoryArr containsObject:model]) {
            [tmodel.CategoryArr removeObject:model];
            [self.thirdTab reloadData];

        }
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
}




#pragma mark ===== 返回选中的Model
//一级
- (CategoryModel *)reTurnOneModel{
    CategoryModel *remodel;
    for (CategoryModel *model in _dataArr) {
        if (model.isSelected) {
            remodel =model;
        }
    }
    return remodel;
    
}

//二级
- (CategoryModel *)reTurnSecondModel{
    CategoryModel *remodel;
    CategoryModel *onemodel = [self reTurnOneModel];
    for (CategoryModel *model in onemodel.CategoryArr) {
        if (model.isSelected) {
            remodel =model;
        }
    }
    return remodel;
    
}
#pragma mark ===== 点击一级时设置二级选择未选中
- (void)setselectedTwoModel{
    CategoryModel *oneModel = [self reTurnOneModel];

    BOOL haveSelected = NO;
    for (CategoryModel *tmodel in oneModel.CategoryArr) {
        if (tmodel.isSelected) {
            haveSelected = YES;
        }
    }
    if (!haveSelected&&oneModel.CategoryArr.count>0) {
        CategoryModel *tmodel = oneModel.CategoryArr[0];
        tmodel.isSelected = YES;
    }
}


#pragma mark ===== 点击二级时设置三级选择未选中
- (void)setselectedThreeModel{
    BOOL haveThreeSelected = NO;
    CategoryModel *secmodel = [self reTurnSecondModel];
    for (CategoryModel *tmodel in secmodel.CategoryArr) {
        if (tmodel.isSelected) {
            haveThreeSelected = YES;
        }
    }
    if (!haveThreeSelected&& secmodel.CategoryArr.count>0) {
        CategoryModel *tmodel = secmodel.CategoryArr[0];
        tmodel.isSelected = YES;
    }
    
    
}

- (void)AllReloadDatas{
    [self.ListTab reloadData];
    [self.secondTab reloadData];
    [self.thirdTab reloadData];
}


#pragma mark ===== 添加删除

- (void)addBtnClick{
    CategoryModel *oneModel = [self reTurnOneModel];
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(oneModel);
    }
    
    
    
}


- (void)deleteBtnClick{
    
    
    
}




#pragma mark ========= get

-(BaseTableView *)ListTab{
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
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


-(BaseTableView *)secondTab{
    if (!_secondTab) {
        _secondTab = [[BaseTableView alloc] initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
        _secondTab.delegate = self;
        _secondTab.dataSource = self;
        _secondTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _secondTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _secondTab.estimatedRowHeight = 0;
        _secondTab.sectionHeaderHeight = 0.01;
        _secondTab.sectionFooterHeight = 0.01;
        if (@available(iOS 11.0, *)) {
            _secondTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _secondTab;
    
}

-(BaseTableView *)thirdTab{
    
    if (!_thirdTab) {
        _thirdTab = [[BaseTableView alloc] initWithFrame:CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, ScreenHeight-NaviHeight64) style:UITableViewStylePlain];
        _thirdTab.delegate = self;
        _thirdTab.dataSource = self;
        _thirdTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _thirdTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _thirdTab.estimatedRowHeight = 0;
        _thirdTab.sectionHeaderHeight = 0.01;
        _thirdTab.sectionFooterHeight = 0.01;
        if (@available(iOS 11.0, *)) {
            _thirdTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _thirdTab;
    
    
}

@end
