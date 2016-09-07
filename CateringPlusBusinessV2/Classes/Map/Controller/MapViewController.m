//
//  MapViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/5.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController (){
    UITextField *_searchText;
    UIButton *_searchBtn;
    BOOL _isSearch;//是否正在搜索
}
@property(nonatomic,strong) NSMutableArray *poiAnnotations;//当前位置周边数据
@property(nonatomic,strong) NSMutableArray *searchPoiAnnotations;//搜索数据
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureMAPAPIKey];
    
    [self initLayout];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)initLayout{
    
    _isSearch = NO;
    
    [self setNav];
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.currentTableView];
    
    [self.view addSubview:self.searchTableView];
    
    self.search.delegate = self;
    
    //定位当前地址
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 2;
    self.locationManager.reGeocodeTimeout = 2;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@",location);
        if (regeocode) {
            NSLog(@"regeocode:%@",regeocode);
        }
        //得到定位信息,添加annotation
        if (location) {
            [self searchPoiByCenterCoordinate:[AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude]];
        }
    }];
    
    
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+10, 30, screen_width-(CGRectGetMaxX(backBtn.frame)+20+60), 30)];
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = RGB(224, 224, 224).CGColor;
    searchView.layer.cornerRadius = 4;
    searchView.layer.masksToBounds = YES;
    [backView addSubview:searchView];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5f, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    [searchView addSubview:searchImage];
    
    CGSize searchSize = searchView.bounds.size;
    _searchText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImage.frame)+5, 0, searchSize.width-20, searchSize.height)];
    _searchText.delegate = self;
    _searchText.font = [UIFont systemFontOfSize:12];
    _searchText.placeholder = @"搜索";
    [_searchText addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_searchText];
    
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchView.frame)+5, 30, 55, 30)];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _searchBtn.backgroundColor = RGB(153, 153, 153);
    _searchBtn.layer.cornerRadius = 4;
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_searchBtn];
    
    UIView *bglineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 1)];
    bglineView.backgroundColor = RGB(224, 224, 224);
    [backView addSubview:bglineView];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(AMapGeoPoint *)amapGeoPoint
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = amapGeoPoint;
    //    request.keywords            = @"电影院";
    /* 按照距离排序. */
    request.sortrule = 0;
    request.requireExtension = YES;
    
    [_search AMapPOIAroundSearch:request];
}

//查询结果
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0)
    {
        return;
    }
    [self.poiAnnotations removeAllObjects];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [_poiAnnotations addObject:obj];
        NSLog(@"uid=%@,name=%@,type=%@,address=%@,district=%@",obj.uid,obj.name,obj.type,obj.address,obj.district);
    }];
    [self.currentTableView reloadData];
    [self.searchTableView reloadData];
}
//关键字查询
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    
    [self.searchPoiAnnotations removeAllObjects];
    [response.tips enumerateObjectsUsingBlock:^(AMapTip * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_searchPoiAnnotations addObject:obj];
        NSLog(@"uid=%@,name=%@,address=%@",obj.uid,obj.name,obj.address);
    }];
    [self.searchTableView reloadData];
}

-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64+1, screen_width, (screen_height-64)/2)];
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //
    }
    return _mapView;
}

-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

-(NSMutableArray *)poiAnnotations{
    if (!_poiAnnotations) {
        _poiAnnotations = [[NSMutableArray alloc] init];
    }
    return _poiAnnotations;
}

-(NSMutableArray *)searchPoiAnnotations{
    if (!_searchPoiAnnotations) {
        _searchPoiAnnotations = [[NSMutableArray alloc] init];
    }
    return _searchPoiAnnotations;
}

-(UITableView *)currentTableView{
    if (!_currentTableView) {
        float tableH = CGRectGetMaxY(self.mapView.frame);
        _currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableH, screen_width, screen_height-tableH) style:UITableViewStylePlain];
        _currentTableView.delegate = self;
        _currentTableView.dataSource = self;
        _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _currentTableView;
}

-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screen_height, screen_width, 0) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchTableView;
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _currentTableView) {
        return [self.poiAnnotations count];
    }else{
        if (_isSearch && self.searchPoiAnnotations.count > 0) {
            return [self.searchPoiAnnotations count];
        }else{
            return [self.poiAnnotations count];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapPOIAddressCell *cell = [[MapPOIAddressCell alloc] cellWithTableView:tableView];
    if (tableView == _currentTableView) {
        AMapPOI *item = [self.poiAnnotations objectAtIndex:indexPath.row];
        cell.name.text = item.name;
        cell.address.text = item.address;
        cell.attributes = [TableGroupAttributes initWithCounts:self.poiAnnotations.count row:indexPath.row];
        return cell;
    }else{
        if (_isSearch && self.searchPoiAnnotations.count > 0) {
            AMapTip *item = [self.searchPoiAnnotations objectAtIndex:indexPath.row];
            cell.name.text = item.name;
            cell.address.text = item.address;
            cell.attributes = [TableGroupAttributes initWithCounts:self.searchPoiAnnotations.count row:indexPath.row];
            return cell;
        }else{
            AMapPOI *item = [self.poiAnnotations objectAtIndex:indexPath.row];
            cell.name.text = item.name;
            cell.address.text = item.address;
            cell.attributes = [TableGroupAttributes initWithCounts:self.poiAnnotations.count row:indexPath.row];
            return cell;
        }
    }
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MapSelectResult *resultItem = nil;
    if (tableView == _currentTableView) {
        AMapPOI *item = [self.poiAnnotations objectAtIndex:indexPath.row];
        resultItem = [[MapSelectResult alloc] initResultWithName:item.name address:item.address latitude:item.location.latitude longitude:item.location.longitude district:item.district];
    }else{
        if (_isSearch && self.searchPoiAnnotations.count > 0) {
            AMapTip *item = [self.searchPoiAnnotations objectAtIndex:indexPath.row];
            resultItem = [[MapSelectResult alloc] initResultWithName:item.name address:item.address latitude:item.location.latitude longitude:item.location.longitude district:item.district];
        }else{
            AMapPOI *item = [self.poiAnnotations objectAtIndex:indexPath.row];
            resultItem = [[MapSelectResult alloc] initResultWithName:item.name address:item.address latitude:item.location.latitude longitude:item.location.longitude district:item.district];
        }
    }

    [self.delegate selectAddress:resultItem];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 重写UITextField方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2f animations:^{
        self.searchTableView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    }];
    _isSearch = YES;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.5f animations:^{
//        self.searchTableView.frame = CGRectMake(0, screen_height, screen_width, 0);
//    }];
//    _isSearch = NO;
}

-(void)textFieldDidChangeValue:(UITextField *)sender{
    if (sender.text.length>0) {
        _searchBtn.backgroundColor = RGB(249, 215, 38);
    }else{
        _searchBtn.backgroundColor = RGB(153, 153, 153);
    }
}

#pragma mark 配置高德地图Key
- (void)configureMAPAPIKey
{
    if ([MAPAPIKey length] > 0)
    {
        [AMapServices sharedServices].apiKey = (NSString *)MAPAPIKey;
        [AMapLocationServices sharedServices].apiKey = (NSString *)MAPAPIKey;
    }
}

//搜索
-(void)searchBtnClick{
    if (_searchText.text.length == 0)
    {
        return;
    }
    NSLog(@"_searchText:%@",_searchText.text);
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = _searchText.text;
    tips.city     = @"重庆市";
    tips.cityLimit = YES;// 是否限制城市
    
    [self.search AMapInputTipsSearch:tips];
}
//返回
-(void)onBackBtn:(id)button{
    if (_isSearch) {
        _isSearch = NO;
        [UIView animateWithDuration:0.5f animations:^{
            self.searchTableView.frame = CGRectMake(0, screen_height, screen_width, 0);
        }];
        _searchText.text = @"";
        [self.view endEditing:YES];
        _searchBtn.backgroundColor = RGB(153, 153, 153);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
