//
//  BaiduMapTool.h
//  BaiduMap
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件


typedef void(^ResultBlock)(NSArray<BMKPoiInfo *>*poiInfos);

@interface BaiduMapTool : NSObject

//声明单例模式
single_interface(BaiduMapTool);

//POI检索
-(void)beginSearchWithCenter:(CLLocationCoordinate2D)center KeyWord:(NSString *)keyWord ResultBlock:(ResultBlock)resultBlock;
//添加大头针
-(void)addAnnotationWithCenter:(CLLocationCoordinate2D)center Tile:(NSString *)title SubTile :(NSString *)subtitle toMapView:(BMKMapView *)mapView;

@end
