//
//  YMKShape.m
//  ZnaetMama
//
//  Created by Admin on 25.09.15.
//  Copyright (c) 2015 Gygol. All rights reserved.
//

#import "YMKShapeCircle.h"

@implementation YMKShapeCircle

+ (YMKShapeCircle *) drawCircleOnMap:(YMKMapView *)mapView Center:(YMKMapCoordinate) center Radius: (CGFloat) radius{
    YMKShapeCircle* returnShape;
    
    @try {
        for (UIView * view in ((UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1]).subviews) {
            if([view isKindOfClass:[YMKShapeCircle class]]){
                returnShape=(YMKShapeCircle *)view;
            }
        }
        
        if(returnShape==nil){
            
            [mapView setNeedsLayout];
            [mapView layoutIfNeeded];
            
            //Create new View
            returnShape = [[YMKShapeCircle alloc] initWithFrame:(CGRect){0,0,mapView.frame.size}];
            
            //Get UIScrollView
            returnShape.YXScrollView = (UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1];
            
            //Insert RouteView
            [returnShape.YXScrollView insertSubview:returnShape atIndex:1];
            
            returnShape.YMKMapViewInternal = mapView;
            
            //Setting properties of Route view
            [returnShape setBackgroundColor:[UIColor clearColor]];
            [returnShape setUserInteractionEnabled:NO];
            
        }
        
        returnShape.circleCenter = center;
        returnShape.circleRadius = radius;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Can't show spahe");
    }
    @finally {
        return returnShape;
    }
}

- (void) drawRect:(CGRect)rect{
    
    long z = [self.YMKMapViewInternal zoomLevel];
    
    //Setting CGContext
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Width of route line
    CGContextSetLineWidth(context, z/2);
    
    //Color of route line
    //CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5].CGColor);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3].CGColor);
    
    //Move to first position of route
    CGPoint centerPoint=[self.YMKMapViewInternal convertLLToMapView:self.circleCenter];
    
    // to draw ellipse we must set rect: x, y, width and height
    // calculate top center point using bearing, distance and center point
    YMKMapCoordinate topCenterCoord = [self coordinateFromCoord:self.circleCenter atDistanceKm:self.circleRadius/1000 atBearingDegrees:0];
    CGPoint topCenterPoint=[self.YMKMapViewInternal convertLLToMapView:topCenterCoord];
    
    // distance between centerPoint and topCenterPoint (upper side)
    CGFloat xDist = (centerPoint.x - topCenterPoint.x);
    CGFloat yDist = (centerPoint.y - topCenterPoint.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    
    CGFloat width = distance * 2;
    CGFloat height = distance * 2;
    
    // draw ellipse
    CGRect rectangle = CGRectMake(topCenterPoint.x - distance, topCenterPoint.y, width, height);
    CGContextFillEllipseInRect(context, rectangle);
    
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:1 alpha:1].CGColor);
    
    CGFloat shift = width*0.03;
    CGRect rectangle2 = CGRectMake(centerPoint.x - shift, centerPoint.y - shift, shift * 2, shift * 2);
    CGContextFillEllipseInRect(context, rectangle2);
    
    CGContextStrokePath(context);
    
}

- (YMKMapCoordinate)coordinateFromCoord:(YMKMapCoordinate)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    // usefull resource http://www.movable-type.co.uk/scripts/latlong.html
    // topic "Destination point given distance and bearing from start point"
    
    double distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    
    return result;
}

- (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

@end
