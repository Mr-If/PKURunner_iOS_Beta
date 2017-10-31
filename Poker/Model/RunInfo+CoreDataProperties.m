//
//  RunInfo+CoreDataProperties.m
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "RunInfo+CoreDataProperties.h"

@implementation RunInfo (CoreDataProperties)

+ (NSFetchRequest<RunInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RunInfo"];
}

@dynamic array;
@dynamic distance;
@dynamic endtime;
@dynamic index;
@dynamic isver;
@dynamic speed;
@dynamic time;
@dynamic tureline;
@dynamic userid;
@dynamic photoFilename;
@dynamic imageData;
@dynamic restart;
@dynamic step;

@end
