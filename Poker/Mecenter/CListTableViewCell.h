//
//  CListTableViewCell.h
//  PKU
//
//  Created by ironfive on 16/8/11.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *daylabel;


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (nonatomic,strong)NSDictionary     *model;

@end
