//
//  YMKShape.h
//  ZnaetMama
//
//  Created by Admin on 25.09.15.
//  Copyright (c) 2015 Gygol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YandexMapKit/YandexMapKit.h>

@interface YMKShapeCircle : UIView

@property (nonatomic, strong) YMKMapView * YMKMapViewInternal;
@property (nonatomic, strong) UIScrollView<UIScrollViewDelegate> * YXScrollView;
@property (nonatomic, assign) YMKMapCoordinate circleCenter;
@property (nonatomic, assign) CGFloat circleRadius;

+ (YMKShapeCircle *) drawCircleOnMap:(YMKMapView *)mapView Center:(YMKMapCoordinate) center Radius: (CGFloat) radius;

@end
