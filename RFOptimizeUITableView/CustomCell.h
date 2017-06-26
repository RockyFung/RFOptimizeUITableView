//
//  CustomCell.h
//  RFOptimizeUITableView
//
//  Created by rocky on 2017/6/26.
//  Copyright © 2017年 rocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"
@interface CustomCell : UITableViewCell
@property (nonatomic, strong) CustomModel *model;
- (void)clear;
- (void)loadData;
@end
