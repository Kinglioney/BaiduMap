//
//  BaiduMapTool.m
//  BaiduMap
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaiduMapTool.h"
@interface BaiduMapTool()<BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKPoiSearch *searcher;

@property (nonatomic, copy) ResultBlock resultBlock;

@end

@implementation BaiduMapTool

//实现单例模式
single_implementation(BaiduMapTool);


-(BMKPoiSearch *)searcher{
    if (!_searcher) {
        _searcher = [[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
    }

    return _searcher;
}

//POI检索
-(void)beginSearchWithCenter:(CLLocationCoordinate2D)center KeyWord:(NSString *)keyWord ResultBlock:(ResultBlock)block{
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.location = center;
    option.keyword = keyWord;
    BOOL flag = [self.searcher poiSearchNearBy:option];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
        self.resultBlock = block;
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
//添加大头针
-(void)addAnnotationWithCenter:(CLLocationCoordinate2D)center Tile:(NSString *)title SubTile :(NSString *)subtitle toMapView:(BMKMapView *)mapView{

    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = center;
    annotation.title = title;
    annotation.subtitle = subtitle;
    [mapView addAnnotation:annotation];

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
        self.resultBlock(poiResult.poiInfoList);

    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
