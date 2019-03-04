//
//  GoodsEditController.m
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "GoodsEditController.h"
#import "GoodsClassListController.h"
#import "OtherCategoryController.h"
#import "ShowModel.h"
#import "SelectedCell.h"
#import "InputCell.h"
#import "PhotoShowView.h"
#import "CreateTopPicCell.h"
#import "CategoryModel.h"
#import "UpImagePL.h"
#import "PicModel.h"

@interface GoodsEditController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) BaseTableView *ListTab;

@property (nonatomic, strong) UIView *memoView;   //备注显示

@property (nonatomic, strong) UIView *downView;   //底部图片显示

@property (nonatomic, strong) UIView *setView;   //预览、提交

@property (nonatomic, strong) UIImage *faceImage;  //预览、提交
@end

@implementation GoodsEditController{
    
    NSMutableArray *_dataArr;
    NSString *_name;
    PhotoShowView *_photoShowView;
    UITextView  *_memoTextView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑商品";
    [self setBarBackBtnWithImage:nil];
    [self initDatas];
    [self initUI];
    
}

- (void)initDatas{
    
    
    
    
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<4; i++) {
        [_dataArr addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    
    _name = @"";
    NSArray *titleArr1 = @[@"品类标签",@"价格"];
    NSArray *upstr1 = @[@"keyword",@"marketPrice"];
    NSArray *cellTYpe1 = @[@"1",@"2"];
    
    NSArray *showArr = @[_nowModel.goodsCategory?_nowModel.goodsCategory:@"",_nowModel.minPrice];

    NSMutableArray *dataArr1 = _dataArr[1];
    for (int i = 0; i<titleArr1.count; i++) {
        ShowModel *model = [[ShowModel alloc]init];
        model.title = titleArr1[i];
        model.actueValue = showArr[i];
        model.upStr = upstr1[i];
        model.cellType = [cellTYpe1[i] integerValue];
        model.KeyboardType = UIKeyboardTypeDecimalPad;
        if (i==0) {
            model.actueID = _nowModel.goodsCategoryId;
        }
        [dataArr1 addObject:model];
    }
    SpecListModel *Specmodel;
    if (_nowModel.specDTOList.count<=0) {
        [HUD showLoading:@"参数获取错误"];
        return;
    }
    Specmodel = _nowModel.specDTOList[0];
    
    NSArray *titleArr2 = @[@"花型号",@"幅宽",@"颜色",@"克重",@"数量",@"单位",@"成份"];
    NSArray *upstr2 = @[@"pattern",@"width",@"color",@"goodsWeight",@"inv",@"goodsUnit",@"component"];
    NSArray *cellTYpe2 = @[@"2",@"1",@"2",@"2",@"2",@"1",@"1"];
    NSArray *showArr2 = @[Specmodel.pattern,Specmodel.width,Specmodel.color,Specmodel.goodsWeight,Specmodel.inv,Specmodel.goodsUnit,Specmodel.component];

    
    NSMutableArray *dataArr2 = _dataArr[2];
    for (int i = 0; i<titleArr2.count; i++) {
        ShowModel *model = [[ShowModel alloc]init];
        model.actueValue = showArr2[i];
        model.title = titleArr2[i];
        model.upStr = upstr2[i];
        model.cellType = [cellTYpe2[i] integerValue];
        if (i == 3||i == 4) {
            model.KeyboardType = UIKeyboardTypeDecimalPad;
        }else{
            model.KeyboardType = UIKeyboardTypeDefault;
        }
        [dataArr2 addObject:model];
    }
    if (_nowModel.goodsName.length>0) {
        _name =_nowModel.goodsName;
    }else{
        _name = @"";
    }
    
}
- (void)initUI{
    _photoShowView = [[PhotoShowView alloc]initWithFrame:CGRectMake(0, 62, ScreenWidth, 136)];
    [self.view addSubview:self.setView];
    [self.view addSubview:self.ListTab];
    [self.ListTab reloadData];
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
//    dispatch_async(queue, ^{
//        NSURL *url = [GlobalMethod returnUrlStrWithImageName:_nowModel.pictureName andisThumb:YES];
//        NSData *data1 = [NSData dataWithContentsOfURL:url];
//        image1 = [UIImage imageWithData:data1];
//        if (!image1) {
//            image1 = [UIImage imageNamed:@"proempty"];
//        }
//        _faceImage = image1;
//    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.ListTab reloadData];
//
//    });
    NSArray *imageArr = [_nowModel.particularsPicture componentsSeparatedByString:@","];
    NSMutableArray *allImaArr = [NSMutableArray arrayWithArray:imageArr];
    [allImaArr insertObject:_nowModel.pictureName atIndex:0];
    if (_nowModel.particularsPicture.length>0) {
        [self loadImageWithArr:allImaArr];
    }
    
}

#pragma mark ========= 按钮点击

/**
 创建
 */
- (void)createBtnClick{
    
    if (_name.length>30) {
        [HUD show:@"标题不能超过30字"];
        return;
    }
    if (!_faceImage) {
        [HUD show:@"请添加商品封片"];
        return;
    }
    NSArray *titlleArr = @[@"品类标签",@"花型号",@"成份"];
    for (NSMutableArray *arr in _dataArr)
    {
        for (ShowModel *model in arr)
        {
            if (model.actueValue.length<=0&&[titlleArr containsObject:model.title])
            {
                [HUD show:[NSString stringWithFormat:@"商品%@不能为空",model.title]];
                return;
            }
        }
    }
    //价格跟单位判断  有价格需有单位  没有价格没有单位
    NSMutableArray *priceArr = _dataArr[1];
    ShowModel *pricemodel = priceArr[1];
    NSMutableArray *unitArr = _dataArr[2];
    ShowModel *unitmodel = unitArr[5];
    if (pricemodel.actueValue.length>0) {
        //价格跟单位判断  有价格需有单位
        if (unitmodel.actueValue.length<=0) {
            [HUD show:@"设置价格后单位不能为空"];
            return;
        }
        
    }else{
        if (unitmodel.actueValue.length>0) {
            [HUD show:@"设置单位后价格不能为空"];
            return;
        }
    }
    
    
    
    UpImagePL *upPl = [[UpImagePL alloc]init];
    NSMutableArray *photoArr = [NSMutableArray arrayWithCapacity:0];
    [photoArr addObject:_faceImage];
    for (PicModel *mdoel in  _photoShowView.urlPhotos) {
        [photoArr addObject:mdoel.Image];
    }
    
    [HUD showLoading:nil];
    [upPl updateToByGoodsImgArr:photoArr WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSString *ImaStr = returnValue[@"result"];
        if (ImaStr.length<=0) {
            [HUD cancel];
            [HUD show:@"上传出错了，请稍后再试"];
            return;
        }
        NSArray *arr = [ImaStr componentsSeparatedByString:@","];
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
        [muArr removeObjectAtIndex:0];
        NSString *deImaStr = [muArr componentsJoinedByString:@","];
        [self UPALLinfoWithFaceImageUrl:arr[0] andDetailImageStr:deImaStr.length>0?deImaStr:@""];
        
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [HUD show:msg];
        
    } andImageType:@"3"];
    
}


- (void)UPALLinfoWithFaceImageUrl:(NSString *)faceImaStr andDetailImageStr:(NSString *)deImaStr{
    
    NSArray *arr = _dataArr[1];
    ShowModel *categorymodel = arr[0];
    ShowModel *pricemodel = arr[1];
    
    NSArray *Dicarr = _dataArr[2];
    SpecListModel *Specmodel;
    if (_nowModel.specDTOList.count<=0) {
        [HUD showLoading:@"参数获取错误"];
        return;
    }
    Specmodel = _nowModel.specDTOList[0];
    
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
    for (ShowModel *model in Dicarr) {
        [muDic setValue:model.actueValue forKey:model.upStr];
    }
    [muDic setValue:pricemodel.actueValue forKey:@"price"];
    [muDic setValue:Specmodel.theID forKey:@"id"];

    
    NSDictionary *dic = @{@"id":_nowModel.theID,
                          @"particularsPicture":deImaStr,
                          @"goodsModule":_nowModel.goodsModule,
                          @"goodsRemark":_memoTextView.text,
                          @"particularsChar":@"",
                          @"inew":@"true",
                          @"imageType":@"3",
                          @"goodsName":_name,
                          @"feature":@"",
                          @"goodsCategoryId":categorymodel.actueID,
                          @"goodsBrandImg":@"",
                          @"goodsBrand":@"",
                          @"pictureName":faceImaStr,
                          @"goodsCategory":categorymodel.actueValue,
                          @"sortIndex":@"1",
                          @"marketPrice":pricemodel.actueValue,
                          @"addSpec":@[muDic]
                          };
    
    [GEditPL Goods_GoodsSaveGoodsWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        GoodsModel *model = [GoodsModel mj_objectWithKeyValues:returnValue];
        WeakSelf(self);
        if (weakself.returnBlock) {
            weakself.returnBlock(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
    
    
}




#pragma mark ========= tableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.0001;
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 5) color:UIColorFromRGB(BackColorValue)];
    return view;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 3) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 8;
        
    }
    return 0;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 188;
    }else if (indexPath.section == 1){
        return 62;
    }else if (indexPath.section == 2){
        if (indexPath.row == 7) {
            return 120;
        }
        return 62;
    }else{
        return 200;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *dataArr = _dataArr[indexPath.section];
    if (indexPath.section == 0) {
        static NSString *cellId = @"topcellid";
        CreateTopPicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CreateTopPicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_faceImage) {
            cell.faceIma.image = _faceImage;
        }
        if (_name) {
            cell.titleTxt.text = _name;
            cell.titleNumLab.text = [NSString stringWithFormat:@"%ld/30",cell.titleTxt.text.length];
        }
        cell.returnBlock = ^(UIImage *image, NSString *title) {
            if (image) {
                _faceImage = image;
            }
            if (title) {
                _name = title;
            }
            
        };
        return cell;
    }else if (indexPath.section == 1||indexPath.section == 2){
        if (indexPath.row == 7) {
            static NSString *memocellId = @"memocellId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:memocellId];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memocellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            [cell addSubview:self.memoView];
            return cell;
        }
        ShowModel *model = dataArr[indexPath.row];
        if (model.cellType == CellType_Selected) {
            static NSString *SelectedCellId = @"SelectedCell";
            SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectedCellId];
            if (!cell) {
                cell = [[SelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectedCellId];
            }
            cell.model = model;
            return cell;
        }else{
            static NSString *InputCellId = @"InputCell";
            InputCell *cell = [tableView dequeueReusableCellWithIdentifier:InputCellId];
            if (!cell) {
                cell = [[InputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InputCellId];
            }
            cell.model = model;
            return cell;
        }
        
    }else{
        static NSString *cellId = @"downcellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        [cell.contentView addSubview:self.downView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSMutableArray *dataArr = _dataArr[1];
            ShowModel *showModel = dataArr[indexPath.row];
            GoodsClassListController *classVc = [[GoodsClassListController alloc]init];
            [classVc setReturnBlock:^(CategoryModel *model) {
                CategoryModel *twoSelectedModel;
                CategoryModel *ThreeSelectedModel;
                NSString *nameStr =model.name;
                
                for (CategoryModel *twoModel in model.CategoryArr) {
                    if (twoModel.isSelected) {
                        twoSelectedModel = twoModel;
                        showModel.actueID = twoModel.theId;
                        nameStr = [NSString stringWithFormat:@"%@-%@",nameStr,twoModel.name];
                    }
                }
                if (twoSelectedModel) {
                    for (CategoryModel *threeModel in twoSelectedModel.CategoryArr)
                    {
                        if (threeModel.isSelected)
                        {
                            ThreeSelectedModel = threeModel;
                            showModel.actueID = threeModel.theId;
                            nameStr = [NSString stringWithFormat:@"%@-%@",nameStr,threeModel.name];
                        }
                    }
                }
                showModel.actueValue = nameStr;
                [self.ListTab reloadData];
            }];
            [self.navigationController pushViewController:classVc animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        NSMutableArray *dataArr = _dataArr[2];
        ShowModel *showModel = dataArr[indexPath.row];
        if (showModel.cellType == CellType_Input) {
            return;
        }
        
        OtherCategoryController *othVc = [[OtherCategoryController alloc]init];
        WeakSelf(self);
        [othVc setReturnBlock:^(CategoryModel *selectedModel) {
            if (selectedModel.name2.length>0) {
                showModel.actueValue = [NSString stringWithFormat:@"%@ ~ %@",selectedModel.name,selectedModel.name2];
            }else{
                showModel.actueValue = selectedModel.name;
            }
            [weakself.ListTab reloadData];
        }];
        switch (indexPath.row)
        {
            case 1:{
                othVc.type = CategorType_Width;
                break;
            }
            case 5:{
                othVc.type = CategorType_vail;
                break;
            }
            case 6:{
                othVc.type = CategorType_Comp;
                break;
            }
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:othVc animated:YES];
        
    }
    
    
    
    
}


#pragma mark ====== 获取图片

- (void)loadImageWithArr:(NSArray *)arr{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray  *imageArr = [NSMutableArray arrayWithCapacity:0];
    [imageArr addObjectsFromArray:arr];
    for (int i = 0; i<arr.count; i++) {
        __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
        dispatch_group_async(group, queue, ^{
            NSString *url = arr[i];
            NSURL *url1 = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
            if (!image1) {
                image1 = [UIImage imageNamed:@"proempty"];
            }
            [imageArr replaceObjectAtIndex:i withObject:image1];
        });
    }
    dispatch_group_notify(group, queue, ^{
        // 5.回到主线程显示图片
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i<imageArr.count; i++) {
                if (i== 0) {
                    _faceImage =imageArr[0];
                }else{
                    PicModel *mdoel = [[PicModel alloc]init];
                    mdoel.Image = imageArr[i];
                    [_photoShowView.urlPhotos addObject:mdoel];
                }
            }
            [_photoShowView.collectionView reloadData];
            [self.ListTab reloadData];
        });
    });
    
    
    
}


#pragma mark ========= get
-(BaseTableView *)ListTab{
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64 - 70) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
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




-(UIView *)downView{
    if (!_downView) {
        _downView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 162) color:UIColorFromRGB(WhiteColorValue)];
        UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(18, 0, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"详情图"];
        [_downView addSubview:showLab];
        if (!_photoShowView) {
            _photoShowView = [[PhotoShowView alloc]initWithFrame:CGRectMake(0, 62, ScreenWidth, 136)];

        }
        _photoShowView.frame = CGRectMake(0, 62, ScreenWidth, 136);
//        [self.backView addSubview:_photoShowView];
        [_downView addSubview:_photoShowView];
        
    }
    
    return _downView;
}

-(UIView *)setView{
    if (!_setView) {
        _setView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight -NaviHeight64-70, ScreenWidth, 70) color:UIColorFromRGB(WhiteColorValue)];
        UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
        [_setView addSubview:lineview];
        
        
        
        UIButton *addBtn = [BaseViewFactory buttonWithFrame:CGRectMake(34, 13, ScreenWidth-68, 44) font:APPFONT16 title:@"立即添加" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
        [addBtn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_setView addSubview:addBtn];
        addBtn.layer.cornerRadius = 22;
        
    }
    
    return _setView;
}



-(UIView *)memoView{
    
    if (!_memoView) {
        _memoView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 120) color:UIColorFromRGB(WhiteColorValue)];
        UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(18, 0, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"备注"];
        [_memoView addSubview:showLab];
        _memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(56, 16,ScreenWidth-56-18 , 89)];
        _memoTextView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _memoTextView.text = @"请输入备注信息";
        _memoTextView.font =APPFONT(15);
        _memoTextView.textColor = UIColorFromRGB(0x939393);
        _memoTextView.delegate = self;
        [_memoView addSubview:_memoTextView];
        if (_nowModel.goodsRemark.length>0) {
            _memoTextView.text = _nowModel.goodsRemark;

        }

        
    }
    
    return _memoView;
    
}

#pragma mark - text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_memoTextView.text isEqualToString: @"请输入备注信息"]) {
        _memoTextView.text = @"";
        _memoTextView.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_memoTextView.text.length<=0) {
        _memoTextView.text =@"请输入备注信息";
        _memoTextView.textColor = UIColorFromRGB(0x939393);
        
    }
    
    return YES;
}

@end
