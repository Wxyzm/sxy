//
//  HomeSearchController.m
//  SXY
//
//  Created by yh f on 2019/1/12.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "HomeSearchController.h"
#import "SearchHistoryView.h"
#import "ProDetailController.h"
#import "ProListCell.h"
@interface HomeSearchController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIView *topsearchView;
@property (nonatomic,strong)SearchHistoryView *searchView;           //全部
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITextField *searchTextField;


@end

@implementation HomeSearchController{
    
    NSString *_searchTxt;
    NSUserDefaults *_userDefaults;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}


- (void)initUI{
    [self.view addSubview:self.topsearchView];
    [self.view addSubview:self.collectionView];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.page = 1;
    WeakSelf(self);
    [self.searchView setReturnValueBlock:^(NSString *title) {
        [weakself.dataArr removeAllObjects];
        [weakself.collectionView reloadData];
        _searchTxt = title;
        weakself.searchTextField.text = title;
        [weakself.searchTextField resignFirstResponder];
        [weakself loadData];
    }];
}

#pragma mark ======  保存搜索历史

/**
 保存搜索历史
 
 @param txt 搜索历史
 */
- (void)saveHisToryWithTxt:(NSString *)txt{
    
    NSArray *hisArr = [_userDefaults objectForKey:[NSString stringWithFormat:@"%@%@",SearchHistory,[GlobalMethod getUserid]]];
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:hisArr];
    if (![dataArr containsObject:txt]) {
        [dataArr addObject:txt];
        [_userDefaults setObject:dataArr forKey:[NSString stringWithFormat:@"%@%@",SearchHistory,[GlobalMethod getUserid]]];
        [_userDefaults synchronize];
    }
}

#pragma mark ====== 加载数据

- (void)loadData{
    NSDictionary *dic= @{@"status":@"3",
                         @"keyword":_searchTxt,
                         @"pageNo": [NSString stringWithFormat:@"%ld",self.page],
                         @"pageSize":@"10"
                         };
    [HUD showLoading:nil];
    [GEditPL Goods_GoodsGetGoodsListWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSMutableArray *arr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self loadSuccessWithArr:arr];
        [self endLoading];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];
    }];


}
- (void)loadSuccessWithArr:(NSMutableArray *)suArr{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    [_dataArr addObjectsFromArray:suArr];
    if (_dataArr.count<=0) {
        self.nothingIma.hidden = NO;
        [self.view bringSubviewToFront:self.nothingIma];
    }else{
        self.nothingIma.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)endLoading{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
}

- (void)setPageCount{
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        self.page = 1;
    }
    self.page ++;
}
#pragma mark ========== UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProListCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.Gmodel = _dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsModel *model = _dataArr[indexPath.row];
    ProDetailController *deVc = [[ProDetailController alloc]init];
    deVc.goodsId = model.theID;
    [self.navigationController pushViewController:deVc animated:YES];
    
    
}


#pragma mark ====== textfielddelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.searchView showInView:self.view];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [self.searchView cancelPicker];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_dataArr removeAllObjects];
    [self.collectionView reloadData];
    _searchTxt = textField.text;
    if (textField.text.length>0) {
        self.collectionView.mj_header.hidden = NO;
        self.collectionView.mj_footer.hidden = NO;
        
        //保存搜索历史
        [self.searchView cancelPicker];
        [self saveHisToryWithTxt:textField.text];
        
        [self reloadListDatas];
        
        
    }else{
        self.collectionView.mj_header.hidden = YES;
        self.collectionView.mj_footer.hidden = YES;
        [HUD show:@"请输入搜索内容"];
    }
    
    
    return YES;
}

- (void)reloadListDatas
{
    self.page = 1;
    self.loadWay = RELOAD_DADTAS;
    [self loadData];
    
}

- (void)loadmoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadData];
    
}



#pragma mark ====== get

-(UIView *)topsearchView{
    
    if (!_topsearchView) {
        _topsearchView = [BaseViewFactory viewWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, ScreenWidth, 58) color:UIColorFromRGB(WhiteColorValue)];
        _searchTextField = [BaseViewFactory textFieldWithFrame:CGRectMake(56, 0, ScreenWidth-56-64, 58) font:APPFONT(16) placeholder:@"输入搜索内容" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:nil delegate:self];
        [_topsearchView addSubview:_searchTextField];
        _searchTextField.returnKeyType = UIReturnKeyDone;
        UIImageView *searchIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search"]];
        [_topsearchView addSubview:searchIma];
        searchIma.frame = CGRectMake(16, 18, 22, 22);
        UIButton *cancleBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth- 64, 0, 64, 58) font:APPFONT16 title:@"取消" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
        [cancleBtn addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_topsearchView addSubview:cancleBtn];

        
        
    }
    
    return _topsearchView;
}
-(SearchHistoryView *)searchView{
    
    if (!_searchView) {
        _searchView = [[SearchHistoryView alloc]init];
    }
    return _searchView;
}

#pragma mark ========== get


-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat  _margin = 10;
        CGFloat _itemW = (ScreenWidth - 50)/2;;
        CGFloat _itemH =  _itemW + 67+14;
        
        layout.itemSize = CGSizeMake(_itemW, _itemH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT +58, ScreenWidth,ScreenHeight-STATUSBAR_HEIGHT -58) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[ProListCell class] forCellWithReuseIdentifier:@"ProListCell"];
        [_collectionView reloadData];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        _collectionView.mj_header.ignoredScrollViewContentInsetTop = 10;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
    
}

@end
