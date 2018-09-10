//
//  GYZChooseCityController.m
//  GYZChooseCityDemo
//  选择城市列表
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZChooseCityController.h"
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GYZChooseCityController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;

/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *localCityData;

/**
 *  热门城市
 */
@property (nonatomic, strong) NSMutableArray *hotCityData;

/**
 *  最近访问城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;

@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;

/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
@property(nonatomic,retain)CLLocationManager *locationManager;

/**
 是否需要展示定位引导  YES -> 是
 */
@property (nonatomic, assign) BOOL isNeedShowLocationGuid;

@end

NSString *const cityHeaderView = @"CityHeaderView";
NSString *const cityGroupCell = @"CityGroupCell";
NSString *const cityCell = @"CityCell";

@implementation GYZChooseCityController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:LocalizedString(@"navigateItem.chooseCity.title")];

//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backBarButtonItemWithTarget:self action:@selector(cancelButtonDown:)];

    self.isSearch = NO;
    self.isNeedShowLocationGuid = NO;
    [self locationStart];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = LocalizedString(@"chooseCity.searchbar.placehold.title");
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.searchBar.layer setBorderWidth:0.5f];
    [self.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    
    [self.tableView setTableHeaderView:self.searchBar];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor colorWithIntegerRed:36 green:162 blue:86]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCell];
    [self.tableView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:cityGroupCell];
    [self.tableView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:cityHeaderView];
}
-(NSMutableArray *) cityDatas{
    if (_cityDatas == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        _cityDatas = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            GYZCityGroup *group = [[GYZCityGroup alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                GYZCity *city = [[GYZCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [group.arrayCitys addObject:city];
                [self.recordCityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_cityDatas addObject:group];
        }
    }
    return _cityDatas;
}
- (NSMutableArray *) recordCityData
{
    if (_recordCityData == nil) {
        _recordCityData = [[NSMutableArray alloc] init];
    }
    return _recordCityData;
}

- (NSMutableArray *) localCityData
{
    if (_localCityData == nil) {
        _localCityData = [[NSMutableArray alloc] init];
        if (self.locationCityID != nil) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityID isEqualToString:self.locationCityID]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                DLog(@"Not Found City: %@", self.locationCityID);
            }
            else {
                [_localCityData addObject:city];
            }
        }
    }
    return _localCityData;
}

- (NSMutableArray *) hotCityData
{
    if (_hotCityData == nil) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityName isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                DLog(@"Not Found City: %@", str);
            } else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

- (NSMutableArray *) commonCityData
{
    if (_commonCityData == nil) {
        _commonCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.commonCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityName isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                DLog(@"Not Found City: %@", str);
            } else {
                [_commonCityData addObject:city];
            }
        }
    }
    return _commonCityData;
}

- (NSMutableArray *) arraySection
{
    if (_arraySection == nil) {
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, LocalizedString(@"chooseCity.city.section.title.loction"), /*@"最近",*/ LocalizedString(@"chooseCity.city.section.title.hot"), nil];
    }
    return _arraySection;
}

- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.cityDatas.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return self.searchCities.count;
    }
    if (section < 2) {
        return 1;
    }
    GYZCityGroup *group = [self.cityDatas objectAtIndex:section - 2];
    return group.arrayCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
        GYZCity *city =  [self.searchCities objectAtIndex:indexPath.row];
        [cell.textLabel setText:city.cityName];
        return cell;
    }
    
    //change
    if (indexPath.section < 2) {
        GYZCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cityGroupCell];
        if (indexPath.section == 0) {
            cell.titleLabel.text = LocalizedString(@"chooseCity.titleLabel.title");
            cell.noDataLabel.text = LocalizedString(@"chooseCity.noDataLabel.title");
            [cell setCityArray:self.localCityData];
        }
        else {
            cell.titleLabel.text = LocalizedString(@"chooseCity.titleLabel.hotCity.title");
            [cell setCityArray:self.hotCityData];
        }
        [cell setDelegate:self];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 2];
    GYZCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    
    [self setSectionIndexFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    
    return cell;
}

//修改索引的字体
- (void)setSectionIndexFont:(UIFont *)font {
    UIView *sectionIndexView = [self sectionIndexView];
    if (sectionIndexView) {
        if ([sectionIndexView respondsToSelector:@selector(setFont:)]) {
            [sectionIndexView performSelector:@selector(setFont:) withObject:font];
        }
    }
}

//查找索引view
- (UIView *)sectionIndexView {
    
    for (UIView *view in self.tableView.subviews) {
        
        if ([view respondsToSelector:@selector(setIndexColor:)]) {
            return view;
        }

    }
    return nil;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 2 || self.isSearch) {
        return nil;
    }
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderView];
    NSString *title = [_arraySection objectAtIndex:section + 1];
    headerView.titleLabel.text = title;
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44.0f;
    }
    if (indexPath.section == 0) {
        return [GYZCityGroupCell getCellHeightOfCityArray:self.localCityData];
    }
    else if (indexPath.section == 1){
        return [GYZCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 2 || self.isSearch) {
        return 0.0f;
    }
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYZCity *city = nil;
    if (self.isSearch) {
        city =  [self.searchCities objectAtIndex:indexPath.row];
    }else{
        if (indexPath.section < 2) {
            if (indexPath.section == 0 && self.localCityData.count <= 0) {
                self.isNeedShowLocationGuid = YES;
                [self locationStart];
            }
            return;
        }
        GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 2];
        city =  [group.arrayCitys objectAtIndex:indexPath.row];
    }
   
    [self didSelctedCity:city];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return nil;
    }
    return self.arraySection;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        return -1;
    }
    return index - 1;
}

#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
//    [btn setTitle:[UIAlertAction titleWithType:UPAlertActionTitleTypeCancel] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

//text改变时调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
    
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (GYZCity *city in self.recordCityData){
            NSRange chinese = [city.cityName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  initials = [city.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                [self.searchCities addObject:city];
            }
        }
    }
    [self.tableView reloadData];
}

//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [searchBar setShowsCancelButton:NO animated:YES];
     searchBar.text=@"";
    [searchBar resignFirstResponder];
    self.isSearch = NO;
    [self.tableView reloadData];
}

#pragma mark GYZCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(GYZCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}
#pragma mark - Private Methods
- (void) didSelctedCity:(GYZCity *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    if (self.commonCitys.count >= MAX_COMMON_CITY_NUMBER) {
        [self.commonCitys removeLastObject];
    }
    for (NSString *str in self.commonCitys) {
        if ([city.cityName isEqualToString:str]) {
            [self.commonCitys removeObject:str];
            break;
        }
    }
    [self.commonCitys insertObject:city.cityName atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:self.commonCitys forKey:COMMON_CITY_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//开始定位 pl change
-(void)locationStart {
    
    if ([CLLocationManager locationServicesEnabled]) {

        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined: {//用户没有做出选择
                
                if (IOS8) {
                    //使用应用程序期间允许访问位置数据
                    [self.locationManager requestWhenInUseAuthorization];
                }
                
                // 开始定位
                [self.locationManager startUpdatingLocation];
            }
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                
                // 开始定位
                [self.locationManager startUpdatingLocation];
                
                break;
                
            case kCLAuthorizationStatusDenied: {
                
                //查询本地是否已经展示过询问狂
                BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"mIsALreadyShowLocationGuid"];
                
                if (self.isNeedShowLocationGuid == YES || isShow == NO) {
                    
//                    NSString *title = LocalizedString(@"alert.location.title");
//                    NSString *message = LocalizedString(@"alert.location.message");
//
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeCancel handle:nil];
//
//                    UIAlertAction *setAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeSet handle:^(UIAlertAction *action) {
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        [[UIApplication sharedApplication] openURL:url];
//
//                        // 开始定位
//                        [self.locationManager startUpdatingLocation];
//                    }];
//
//                    [UIAlertController up_alertVcWithVc:self title:title message:message actionArray:@[cancelAction, setAction]];
//
//                    if (!isShow) {
//                        //关闭初始进入页面提示
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mIsALreadyShowLocationGuid"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                    }
                    
                }
            }
                
                break;
                
            case kCLAuthorizationStatusRestricted:
                
                break;
                
            default:
                break;
        }
    } else {
        
        //定位服务已关闭
        DLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
    }

}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DLog(@"开始定位");
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             if (self.localCityData.count <= 0) {
                 GYZCity *city = [[GYZCity alloc] init];
                 city.cityName = currCity;
                 city.shortName = currCity;
                 [self.localCityData addObject:city];
                 
                 [self.tableView reloadData];
             }
             
         } else if (error ==nil && [array count] == 0)
         {
             DLog(@"No results were returned.");
         }else if (error !=nil)
         {
             DLog(@"An error occurred = %@", error);
         }
         
     }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    
    }
    
}

@end
