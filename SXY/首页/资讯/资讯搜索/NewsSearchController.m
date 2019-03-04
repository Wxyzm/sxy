//
//  NewsSearchController.m
//  SXY
//
//  Created by yh f on 2019/1/17.
//  Copyright © 2019 XX. All rights reserved.
//

#import "NewsSearchController.h"
#import "NewsDetailViewController.h"
#import "NewsSearchController.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "NewsHotCell.h"
@interface NewsSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UIView *topsearchView;

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)BaseTableView *ListTab;
@property (nonatomic,strong)UITextField *searchTextField;

@end

@implementation NewsSearchController
{
     NSString *_searchTxt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

- (void)initUI{
    _searchTxt = @"";
    [self.view addSubview:self.ListTab];
    [self.view addSubview:self.topsearchView];

    _dataArr = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    
}

- (void)loadNews{
    NSDictionary *dic = @{@"pageNo":[NSString stringWithFormat:@"%ld",self.page],
                          @"key":_searchTxt,
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
        [_dataArr  removeAllObjects];
    }
    [_dataArr addObjectsFromArray:suArr];
    if (_dataArr.count<=0) {
        self.nothingIma.hidden = NO;
        [self.view bringSubviewToFront:self.nothingIma];
    }else{
        self.nothingIma.hidden = YES;
    }
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


#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _dataArr.count;
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
    cell.model = _dataArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *model = _dataArr[indexPath.row];
    NewsDetailViewController *deVc = [[NewsDetailViewController alloc]init];
    deVc.title = model.title;
    deVc.newsId = model.theId;
    [self.navigationController pushViewController:deVc animated:YES];
}
#pragma mark ====== textfielddelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_dataArr removeAllObjects];
    [self.ListTab reloadData];
    _searchTxt = textField.text;
    [self reloadListDatas];
    return YES;
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


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT +58, ScreenWidth, ScreenHeight-STATUSBAR_HEIGHT-58) style:UITableViewStylePlain];
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
