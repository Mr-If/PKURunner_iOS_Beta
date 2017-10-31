//
//  MeInfoTableViewCell.h
//  PKU
//
//  Created by ironfive on 16/8/30.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UILabel *valuelabel;

@property (nonatomic,strong)NSDictionary     *model;

@end
