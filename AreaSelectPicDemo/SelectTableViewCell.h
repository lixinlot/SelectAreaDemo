//
//  SelectTableViewCell.h
//  AreaSelectPicDemo
//
//  Created by jimmy on 2018/12/4.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTableViewCell : UITableViewCell

+ (SelectTableViewCell *)cellWithTableView:(UITableView *)tableView;

- (void)setTitleString:(NSString *)titleString;
- (void)setContentString:(NSString *)contentString;

@end

NS_ASSUME_NONNULL_END
