//
//  LineInfo+CoreDataProperties.m
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "LineInfo+CoreDataProperties.h"

@implementation LineInfo (CoreDataProperties)

+ (NSFetchRequest<LineInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LineInfo"];
}

@dynamic imageData;
@dynamic index;
@dynamic restart;
@dynamic userid;

@end
