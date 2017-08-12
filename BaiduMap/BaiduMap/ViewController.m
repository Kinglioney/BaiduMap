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
#import "BaiduMapTool.h"

@interface ViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;


@end

@implementation ViewController


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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view = self.mapView;


}


#pragma mark - BMKMapViewDelegate
//长按地图执行该方法
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    //修改地图显示

    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.045584, 0.033282);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];

    //开始检索
    [[BaiduMapTool sharedBaiduMapTool] beginSearchWithCenter:coordinate KeyWord:@"小吃" ResultBlock:^(NSArray<BMKPoiInfo *> *poiInfos) {
        [poiInfos enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull poiInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            [[BaiduMapTool sharedBaiduMapTool]addAnnotationWithCenter:poiInfo.pt Tile:poiInfo.name SubTile:poiInfo.address toMapView:self.mapView];
        }];

    }];

}
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //NSLog(@"%f----%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}
@end
