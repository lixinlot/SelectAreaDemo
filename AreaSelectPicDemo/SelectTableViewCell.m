//
//  SelectTableViewCell.m
//  AreaSelectPicDemo
//
//  Created by jimmy on 2018/12/4.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "SelectTableViewCell.h"

#define Kfont(f)   [UIFont systemFontOfSize:ScreenX375(f)]
#define KBlodfont(f)   [UIFont fontWithName:@"PingFangSC-Semibold" size:ScreenX375(f)]

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define ScreenX375(x)   (x) * SCREEN_WIDTH / 375
#define ScreenY375(y)   y * SCREEN_HEIGHT / 375

#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define NAVIGATION_BAR_HEIGHT           (IS_iPhoneX ? 88.0f : 64.0f)

@interface SelectTableViewCell ()

@property (nonatomic,strong)  UILabel       * contentL;
@property (nonatomic,strong)  UILabel       * titleL;

@end

@implementation SelectTableViewCell

+ (SelectTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"SelectCell";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell createChildUI];
    }
    return cell;
}

- (void)createChildUI
{
    self.titleL = [[UILabel alloc] init];
    self.titleL.frame = CGRectMake(ScreenX375(10), ScreenX375(10), ScreenX375(80), ScreenX375(24));
    self.titleL.textAlignment = NSTextAlignmentLeft;
    self.titleL.font = KBlodfont(16);
    [self addSubview:self.titleL];
    
    self.contentL = [[UILabel alloc] init];
    self.contentL.frame = CGRectMake(ScreenX375(90), ScreenX375(10), ScreenX375(200), ScreenX375(24));
    self.contentL.font = Kfont(16);
    self.contentL.textColor = [UIColor blackColor];
    self.contentL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.contentL];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, ScreenX375(43.5), SCREEN_WIDTH, ScreenX375(0.5));
    lineLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:lineLabel];
    
}

- (void)setTitleString:(NSString *)titleString
{
    self.titleL.text = titleString;
}

- (void)setContentString:(NSString *)contentString
{
    self.contentL.text = contentString;
}

@end
