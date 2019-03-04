//
//  NewsController.m
//  SXY
//
//  Created by yh f on 2019/1/2.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsController.h"
#import "NewsDetailViewController.h"
#import "NewsSearchController.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "NewsHotCell.h"

@interface NewsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;


@property (nonatomic,strong)BaseTableView *ListTab;



@end


@implementation NewsController
{
    NSMutableArray *_collectDataArr;
    NSMutableArray *_tabDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    [self setBarBackBtnWithImage:nil];
    [self initDatas];
    [self initUI];
    [self loadHotNews];
    [self loadNews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=NO;
}



- (void)initDatas{
    _collectDataArr = [NSMutableArray arrayWithCapacity:0];
    _tabDataArr = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
}

- (void)initUI{
    
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    
    YLButton *searchBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(0xf1f1f1) titlecolor:UIColorFromRGB(0xc4c4c4) cornerRadius:14 andtarget:self action:@selector(searchBtnClick) titleFont:APPFONT12 title:@"搜索"];
    searchBtn.layer.cornerRadius =14;
    [self.view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"news_search"] forState:UIControlStateNormal];
    [searchBtn setImageRect:CGRectMake((ScreenWidth-40-56)/2, 2.5, 23, 23)];
    [searchBtn setTitleRect:CGRectMake((ScreenWidth-40-56)/2+30, 0, 26, 28)];
    searchBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    searchBtn.frame = CGRectMake(20, 10, ScreenWidth-40, 28);
    
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(17, 48, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@"热点"];
    [self.view addSubview:lab];
    [self.view addSubview:self.collectionView];
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 220, ScreenWidth, 6) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:line];
    UILabel *lab1 = [BaseViewFactory labelWithFrame:CGRectMake(17, 226, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@"全部资讯"];
    [self.view addSubview:lab1];
    [self.view addSubview:self.ListTab];

    
}


- (void)searchBtnClick{
    
    NewsSearchController *seVC = [[NewsSearchController alloc]init];
    [self.navigationController pushViewController:seVC animated:YES];
    
}



- (void)loadHotNews{
    NSDictionary *dic = @{@"hot":@"true"};
    [NewsPL News_NewsGetNewsListWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _collectDataArr = [NewsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.collectionView reloadData];
        
    } andErrorBlock:^(NSString *msg) {
        
    }];
    
}

- (void)loadNews{
    NSDictionary *dic = @{@"pageNo":[NSString stringWithFormat:@"%ld",self.page],
                          @"pageSize":@"10"
                          };
    [HUD showLoading:nil];
    [NewsPL News_NewsGetNewsListWithDic:dic ReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSLog(@"%@",returnValue);
        NSMutableArray *arr  = [NewsModel mj_objectArrayWithKeyValuesArray:returnValue];
         [self loadSuccessWithArr:arr];
        [self.ListTab reloadData];
        [self endLoading];

    } andErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [self endLoading];

    }];
    
    
}


- (void)loadSuccessWithArr:(NSMutableArray *)suArr{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_tabDataArr  removeAllObjects];
    }
    [_tabDataArr addObjectsFromArray:suArr];
    
    [self.ListTab reloadData];
}

- (void)endLoading{
    [self.ListTab.mj_header endRefreshing];
    [self.ListTab.mj_footer endRefreshing];
    
}
- (void)setPageCount{
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        self.page = 1;
    }
    self.page ++;
}

//上拉加载下拉刷新
- (void)reloadListDatas{
    self.page = 1;
    self.loadWay = RELOAD_DADTAS ;
    [self loadNews];
}

- (void)loadmoreData{
    self.loadWay = LOAD_MORE_DATAS ;
    [self loadNews];
    
}

#pragma mark ========== collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _collectDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsHotCell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.model = _collectDataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsModel *model = _collectDataArr[indexPath.row];
    NewsDetailViewController *deVc = [[NewsDetailViewController alloc]init];
    deVc.title = model.title;
    deVc.newsId = model.theId;
    [self.navigationController pushViewController:deVc animated:YES];
}



#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _tabDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _tabDataArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *model = _tabDataArr[indexPath.row];
    NewsDetailViewController *deVc = [[NewsDetailViewController alloc]init];
    deVc.title = model.title;
    deVc.newsId = model.theId;
    [self.navigationController pushViewController:deVc animated:YES];
}

    
#pragma mark ========== get


-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat  _margin = 10;
        CGFloat _itemW = 164;
        CGFloat _itemH =  128;
        
        layout.itemSize = CGSizeMake(_itemW, _itemH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 92, ScreenWidth,128) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 18, 0, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[NewsHotCell class] forCellWithReuseIdentifier:@"NewsHotCell"];
        [_collectionView reloadData];
    }
    return _collectionView;
    
}


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 270, ScreenWidth, ScreenHeight-NaviHeight64-270) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}


@end
