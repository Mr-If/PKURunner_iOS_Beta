//
//  RListTableViewCell.h
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunInfoModel.h"

@interface RListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *totallabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel_;

@property (weak, nonatomic) IBOutlet UILabel *speedlabel;

@property (weak, nonatomic) IBOutlet UILabel *isverlabel;
@property (weak, nonatomic) IBOutlet UILabel *weekstr;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;

@property (nonatomic,strong)id     model;
- (IBAction)ClickPhotoBtn:(id)sender;
- (IBAction)ClickVerBtn:(id)sender;

@property (copy, nonatomic) void (^photoDataBlock)(id model);

@property (copy, nonatomic) void (^verBlock)(id model);

@end
