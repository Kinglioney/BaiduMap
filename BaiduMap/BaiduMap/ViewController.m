//
//  ViewController.m
//  BaiduMap
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
@interface ViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKPoiSearch *searcher;
@end

@implementation ViewController


-(BMKPoiSearch *)searcher{
    if (!_searcher) {
        _searcher = [[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
    }

    return _searcher;
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

    }
    return _mapView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
    self.searcher.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view = self.mapView;


}

-(void)startSearch{
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.location = (CLLocationCoordinate2D){39.915, 116.404};
    option.keyword = @"小吃";
    BOOL flag = [self.searcher poiSearchNearBy:option];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [poiResult.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo *_Nonnull poiInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@----%@", poiInfo.city, poiInfo.address);
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.coordinate = poiInfo.pt;
            annotation.title = poiInfo.name;
            annotation.subtitle = poiInfo.address;
            [self.mapView addAnnotation:annotation];
        }];
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark - BMKMapViewDelegate
//长按地图执行该方法
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    //修改地图显示

    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.045584, 0.033282);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    //开始检索
    [self startSearch];
}
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //NSLog(@"%f----%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}
@end
