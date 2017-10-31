//
//  MAMutablePolylineView.m
//  test3D
//
//  Created by xiaoming han on 15/7/15.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "MAMutablePolylineRenderer.h"

@implementation MAMutablePolylineRenderer

- (instancetype)initWithMutablePolyline:(MAMutablePolyline *)polyline withDetail:(BOOL)detail
{
    self = [super initWithOverlay:polyline];
    if (self)
    {
        self.detail=detail;
    }
    return self;
}

- (MAMutablePolyline *)mutablePolyline
{
    return (MAMutablePolyline *)self.overlay;
}

#pragma mark - Override

- (void)referenceDidChange
{
    [super referenceDidChange];
    
//    MAMutablePolyline *polyline = [self mutablePolyline];
//    
//    if (polyline.points == NULL || polyline.pointCount < 2)
//    {
//        return;
//    }
////    MAMapPoint po=polyline.points[polyline.pointCount-2];
////    if (po.x==268435456&&po.y==134217728) {
////        [polyline.pointArray removeObjectAtIndex:polyline.pointCount-2];
////        polyline.pointCount=polyline.pointArray.count;
////        MAMapPoint *points = (MAMapPoint *)malloc(polyline.pointArray.count * sizeof(MAMapPoint));
////        
////        int i = 0;
////        for (NSValue *value in polyline.pointArray)
////        {
////            MAMapPoint point = [value MAMapPointValue];
////            points[i] = point;
////            ++i;
////        }
////        self.glPoints = [self glPointsForMapPoints:points count:polyline.pointArray.count];
////        self.glPointCount = polyline.pointCount;
////         self.lineDash=YES;
////    }else{
////        self.glPoints = [self glPointsForMapPoints:polyline.points count:polyline.pointCount];
////        self.glPointCount = polyline.pointCount;
////         self.lineDash=NO;
////    }
////    
//    
//    NSMutableArray *array=[NSMutableArray array];
//    NSMutableArray *total=[NSMutableArray array];
//    [total addObject:array];
//    for (int i=0;i<polyline.pointArray.count;i++) {
//        NSValue *value=[polyline.pointArray objectAtIndex:i];
//         MAMapPoint po= [value MAMapPointValue];
//        if (po.x==268435456&&po.y==134217728) {
//            array =[NSMutableArray array];
//            [total addObject:array];
//            
//            MAMapPoint *points = (MAMapPoint *)malloc(2 * sizeof(MAMapPoint));
//            
//            NSValue *value1=[polyline.pointArray objectAtIndex:i-1];
//            NSValue *value2=[polyline.pointArray objectAtIndex:i+1];
//            
//            MAMapPoint point1 = [value1 MAMapPointValue];
//            MAMapPoint point2 = [value2 MAMapPointValue];
//            points[0] = point1;
//            points[1]=point2;
//            
//            self.glPoints = [self glPointsForMapPoints:points count:2];
//            self.glPointCount = 2;
//            self.lineDash=YES;
//            continue;
//        }
//        [array addObject:value];
//    }
//    
//    for (NSMutableArray *ar in total) {
//         MAMapPoint *points = (MAMapPoint *)malloc(ar.count * sizeof(MAMapPoint));
//        int i=0;
//        for (NSValue *value in ar) {
//            MAMapPoint po= [value MAMapPointValue];
//            points[i]=po;
//            i++;
//        }
//        self.glPoints = [self glPointsForMapPoints:points count:ar.count];
//        self.glPointCount = ar.count;
//        self.lineDash=NO;
//    }
    
    
//    self.glPoints = [self glPointsForMapPoints:polyline.points count:polyline.pointCount];
//    self.glPointCount = polyline.pointCount;
}

- (void)glRender
{
//    if (self.glPoints == NULL || self.glPointCount < 2 || self.lineWidth <= 0.0)
//    {
//        return;
//    }
//    
    MAMutablePolyline *polyline = [self mutablePolyline];
    
    if (polyline.points == NULL || polyline.pointCount < 2||self.lineWidth<=0.0)
    {
        return;
    }
    
    if (!self.detail) {
        NSMutableArray *array=[NSMutableArray array];
        NSMutableArray *total=[NSMutableArray array];
        [total addObject:array];
        for (int i=0;i<polyline.pointArray.count;i++) {
            NSValue *value=[polyline.pointArray objectAtIndex:i];
            MAMapPoint po= [value MAMapPointValue];
            if (po.x==268435456&&po.y==134217728) {
                array =[NSMutableArray array];
                [total addObject:array];
                
                MAMapPoint *points = (MAMapPoint *)malloc(2 * sizeof(MAMapPoint));
                
                NSValue *value1=[polyline.pointArray objectAtIndex:i-1];
                NSValue *value2=[polyline.pointArray objectAtIndex:i+1];
                
                MAMapPoint point1 = [value1 MAMapPointValue];
                MAMapPoint point2 = [value2 MAMapPointValue];
                points[0] = point1;
                points[1]=point2;
                
                self.glPoints = [self glPointsForMapPoints:points count:2];
                self.glPointCount = 2;
                self.lineDash=YES;
                self.lineWidth=2.0;
                self.strokeColor=[UIColor lightGrayColor];
                [self renderLinesWithPoints:self.glPoints
                                 pointCount:self.glPointCount
                                strokeColor:self.strokeColor
                                  lineWidth:[self glWidthForWindowWidth:self.lineWidth]
                                     looped:NO
                               LineJoinType:self.lineJoinType
                                LineCapType:self.lineCapType
                                   lineDash:self.lineDash];
                continue;
            }
            [array addObject:value];
        }
        
        for (NSMutableArray *ar in total) {
            MAMapPoint *points = (MAMapPoint *)malloc(ar.count * sizeof(MAMapPoint));
            int i=0;
            for (NSValue *value in ar) {
                MAMapPoint po= [value MAMapPointValue];
                points[i]=po;
                i++;
            }
            self.glPoints = [self glPointsForMapPoints:points count:ar.count];
            self.glPointCount = ar.count;
            self.lineDash=NO;
            
            self.lineWidth=8.0;
            self.strokeColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
            [self renderLinesWithPoints:self.glPoints
                             pointCount:self.glPointCount
                            strokeColor:self.strokeColor
                              lineWidth:[self glWidthForWindowWidth:self.lineWidth]
                                 looped:NO
                           LineJoinType:self.lineJoinType
                            LineCapType:self.lineCapType
                               lineDash:self.lineDash];
        }
    }else{
        NSMutableArray *array=[NSMutableArray array];
        NSMutableArray *colortotal=[NSMutableArray array];
        NSMutableArray *colorarray=[NSMutableArray array];
        NSMutableArray *total=[NSMutableArray array];
        [total addObject:array];
        [colortotal addObject:colorarray];
        for (int i=0;i<polyline.pointArray.count;i++) {
            NSValue *value=[polyline.pointArray objectAtIndex:i];
            MAMapPoint po= [value MAMapPointValue];
            if (po.x==268435456&&po.y==134217728) {
                array =[NSMutableArray array];
                [total addObject:array];
                colorarray=[NSMutableArray array];
                [colortotal addObject:colorarray];
                
                MAMapPoint *points = (MAMapPoint *)malloc(2 * sizeof(MAMapPoint));
                
                NSValue *value1=[polyline.pointArray objectAtIndex:i-1];
                NSValue *value2=[polyline.pointArray objectAtIndex:i+1];
                
                MAMapPoint point1 = [value1 MAMapPointValue];
                MAMapPoint point2 = [value2 MAMapPointValue];
                points[0] = point1;
                points[1]=point2;
                
                self.glPoints = [self glPointsForMapPoints:points count:2];
                self.glPointCount = 2;
                self.lineDash=YES;
                self.lineWidth=2.0;
                self.strokeColor=[UIColor blackColor];
                [self renderLinesWithPoints:self.glPoints
                                 pointCount:self.glPointCount
                                strokeColor:self.strokeColor
                                  lineWidth:[self glWidthForWindowWidth:self.lineWidth]
                                     looped:NO
                               LineJoinType:self.lineJoinType
                                LineCapType:self.lineCapType
                                   lineDash:self.lineDash];
                continue;
            }
            [array addObject:value];
            [colorarray addObject:[polyline.colorArray objectAtIndex:i]];
        }
        
        for (int i=0;i<total.count;i++) {
            
            NSMutableArray *ar=[total objectAtIndex:i];
            
            MAMapPoint *points = (MAMapPoint *)malloc(ar.count * sizeof(MAMapPoint));
            int j=0;
            
            NSMutableArray       *index=[NSMutableArray array];
            for (NSValue *value in ar) {
                MAMapPoint po= [value MAMapPointValue];
                points[j]=po;
                [index addObject:@(j)];
                j++;
            }
            self.glPoints = [self glPointsForMapPoints:points count:ar.count];
            self.glPointCount = ar.count;
            self.lineDash=NO;
            
            self.lineWidth=8.0;
            
            NSMutableArray *color=[colortotal objectAtIndex:i];
            
            [self renderLinesWithPoints:self.glPoints
                             pointCount:self.glPointCount
                             strokeColors:color
                             drawStyleIndexes:index
                             isGradient:YES
                             lineWidth:[self glWidthForWindowWidth:self.lineWidth]
                            looped:NO
                            LineJoinType:self.lineJoinType
                            LineCapType:self.lineCapType
                            lineDash:self.lineDash];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
