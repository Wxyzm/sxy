//
//  GoodsClassListController.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "GoodsClassListController.h"
#import "CategoryModel.h"
#import "CategoryView.h"

@interface GoodsClassListController ()

@end

@implementation GoodsClassListController{
    NSMutableArray *_dataArr;
    CategoryView *_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品类标签";
    [self setBarBackBtnWithImage:nil];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self setRightBtnWithTitle:@"确定" andColor:UIColorFromRGB(BTNColorValue)];
    [self loadList];

}

- (void)loadList{
    
    NSDictionary *dic = @{@"":@""};
    [CategoryPL Category_CategoryGetCategoryListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSArray *arr = [CategoryModel mj_objectArrayWithKeyValuesArray:returnValue];
        _dataArr = [self reTurnResultModelArrWithArr:arr];
        NSLog(@"%@======%@",returnValue,_dataArr);
        if (_dataArr.count<=0) {
            return ;
        }
        [self initUI];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}

- (void)initUI{
    
   _view = [[CategoryView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64)];
    [self.view addSubview:_view];
    _view.dataArr = _dataArr;
    
    WeakSelf(self);
    [_view setReturnBlock:^(CategoryModel *model) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"自定义分类"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"输入自定义分类名";
        }];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             UITextField *text = alert.textFields[0];

                                                             //响应事件
                                                             //得到文本信息
                                                             if (text.text.length<=0||text.text.length>5) {
                                                                 [HUD show:@"请输入一至五位分类名"];
                                                                 return ;
                                                             }
                                                             [weakself addNewModelWithModel:model andText:text.text];
                                                         }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                
                                                             }];
       
       
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [weakself presentViewController:alert animated:YES completion:nil];
        
        
    }];
}



- (void)addNewModelWithModel:(CategoryModel *)model andText:(NSString *)text
{
    CategoryModel *remodel;
    for (CategoryModel *allmodel in model.CategoryArr) {
        if (allmodel.isSelected) {
            remodel =allmodel;
        }
    }
    NSDictionary *dic = @{
                          //@"id":@"0",
                          @"kind":@"品类标签",
                          @"name":text,
                          @"name2":@"",
                          @"parentId":remodel.theId,
                          @"sortIndex":[NSString stringWithFormat:@"%ld",remodel.CategoryArr.count+1],
                          };
    [CategoryPL Category_CategorysaveUserCategoryWithDic:dic WithReturnBlock:^(id returnValue) {
        
        CategoryModel *model = [CategoryModel mj_objectWithKeyValues:returnValue];
        [remodel.CategoryArr addObject:model];
        if (remodel.CategoryArr.count ==1) {
            model.isSelected = YES;
        }
        [_view AllReloadDatas];
    } withErrorBlock:^(NSString *msg) {
        
    }];
   
}




#pragma mark ===== 确定


-(void)respondToRigheButtonClickEvent{
    
    CategoryModel *remodel;
    for (CategoryModel *model in _dataArr) {
        if (model.isSelected) {
            remodel =model;
        }
    }
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(remodel);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark ===== Model设置

- (NSMutableArray *)reTurnResultModelArrWithArr:(NSArray *)arr{
    
    //添加一级类目ID
    NSMutableArray *parentIdOneArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<arr.count; i++) {
        CategoryModel *model = arr[i];
        if ([model.parentId isEqualToString:@"2"]) {
            [parentIdOneArr addObject:model];
        }
    }
    //添加二级类目ID
    for (CategoryModel *model in parentIdOneArr) {
        for (CategoryModel *allmodel in arr) {
            //添加二级类目ID
            if ([model.theId isEqualToString:allmodel.parentId]) {
                [model.CategoryArr addObject:allmodel];
            }
            
        }
    }
    //添加三级类目ID
    for (int i = 0; i<parentIdOneArr.count; i++)
    {
        CategoryModel *onemodel = parentIdOneArr[i];
        for (CategoryModel *twomodel in onemodel.CategoryArr)
        {
            for (CategoryModel *allmodel in arr)
            {
                if ([twomodel.theId isEqualToString:allmodel.parentId])
                {
                    [twomodel.CategoryArr addObject:allmodel];
                }
            }
        }
    }
    //为空时添加空
    for (CategoryModel *model in parentIdOneArr) {
        if (model.CategoryArr.count<=0) {
            CategoryModel *tmodel = [[CategoryModel alloc]init];
            tmodel.parentId = model.theId;
            tmodel.theId = @"-1";
            tmodel.name = @"空";
            [model.CategoryArr addObject:tmodel];
        }
    }
//    for (CategoryModel *model in parentIdOneArr) {
//        for (CategoryModel *secondmodel in model.CategoryArr)
//        {
//            //三级类目默认第一个为空，可添加
//           // if (secondmodel.CategoryArr.count<=0) {
//                CategoryModel *tmodel = [[CategoryModel alloc]init];
//                tmodel.parentId = secondmodel.theId;
//                tmodel.theId = @"-2";
//                tmodel.name = @"空";
//                [secondmodel.CategoryArr insertObject:tmodel atIndex:0];
//        //    }
//        }
//    }
    //添加类目选中
    if (parentIdOneArr.count>0) {
        CategoryModel *model = parentIdOneArr[0];
        model.isSelected = YES;
        CategoryModel *semodel = model.CategoryArr[0];
        semodel.isSelected = YES;
        if (semodel.CategoryArr.count>0) {
            CategoryModel *threemodel = semodel.CategoryArr[0];
            threemodel.isSelected = YES;
        }
      
    }
    return parentIdOneArr;
}


@end
