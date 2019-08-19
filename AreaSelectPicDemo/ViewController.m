//
//  ViewController.m
//  AreaSelectPicDemo
//
//  Created by jimmy on 2018/9/13.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "ViewController.h"
#import "PlaceSelectPickerView.h"
#import "GKCover.h"
#import "SelectTableViewCell.h"

// 弱引用
#define WeakObj(o) __weak typeof(o) o##Weak = o

#define UIColorFromRGB(rgbValue,A) [UIColor colorWithHexString:rgbValue alpha:A]

#define Kfont(f)   [UIFont systemFontOfSize:ScreenX375(f)]
#define KBlodfont(f)   [UIFont fontWithName:@"PingFangSC-Semibold" size:ScreenX375(f)]

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define ScreenX375(x)   (x) * SCREEN_WIDTH / 375
#define ScreenY375(y)   y * SCREEN_HEIGHT / 375

#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define NAVIGATION_BAR_HEIGHT           (IS_iPhoneX ? 88.0f : 64.0f)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)  UITableView   * tableView;

@property (nonatomic,strong)  UIView        * bjView;
///日期选择器
@property (nonatomic,strong)  UIDatePicker  * datePicker;
///选中的日期字符串
@property (nonatomic,copy)    NSString      * dateStr;
///选中的地址字符串
@property (nonatomic,copy)    NSString      * areaStr;


///
@property (nonatomic,strong)  NSMutableArray  * array;

@end

@implementation ViewController

- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"选择器"];
    [self buildUI];
    [self setDatePicker];
}

#pragma mark - 设置UI
-(void)buildUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) style: UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:self.tableView];
}

-(void)setDatePicker
{
    self.bjView = [[UIView alloc] init];
    self.bjView.gk_size = CGSizeMake(SCREEN_WIDTH, ScreenX375(243));
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenX375(43))];
    [self.bjView addSubview:btnView];
    
    btnView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, ScreenX375(43), SCREEN_WIDTH, ScreenX375(0.5));
    lineLabel.backgroundColor = [UIColor blackColor];
    [self.bjView addSubview:lineLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX375(16), 0, ScreenX375(32), ScreenX375(43))];
    [btnView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ScreenX375(48), 0, ScreenX375(32), ScreenX375(43))];
    [btnView addSubview:sureBtn];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    //创建DatePicker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenX375(43), SCREEN_WIDTH, ScreenX375(200))];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.bjView addSubview:self.datePicker];
}

-(void)cancelClick
{
    [GKCover hideCover];
}

-(void)sureClick
{
    //获取挑选的日期
    NSDate *date =_datePicker.date;
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    //设定转换格式
    dateForm.dateFormat =@"yyy年MM月dd日";//h时mm分
    //由当前获取的NSDate数据，转换为日期字符串，显示在私有成员变量_textField上
    self.dateStr = [dateForm stringFromDate:date];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
//    self.contentL.text = self.dateStr;
    
    [GKCover hideCover];
}

#pragma mark - 实现TableView的代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * titleArray = @[@"日期",@"地址"];
    SelectTableViewCell *tableViewCell = [SelectTableViewCell cellWithTableView:tableView];
    
    [tableViewCell setTitleString:titleArray[indexPath.row]];
    if (self.dateStr) {
        if (indexPath.row == 0) {
            [tableViewCell setContentString:self.dateStr];
        }
    }
    
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakObj(self);
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row == 0) {
        [GKCover coverFrom:self.view contentView:self.bjView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:true];
    }else{
        [PlaceSelectPickerView selectPickViewWithValueBlock:^(NSString *value, NSString *value1, NSString *value2) {
            selfWeak.areaStr = [NSString stringWithFormat:@"%@-%@-%@",value,value1,value2 ];
            SelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setContentString:selfWeak.areaStr];
        }];
        
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
//        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


@end
