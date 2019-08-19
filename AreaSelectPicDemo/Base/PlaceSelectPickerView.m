//
//  PlaceSelectPickerView.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/9/10.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "PlaceSelectPickerView.h"
#import "GKCover.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define ScreenX375(x)   (x) * SCREEN_WIDTH / 375
#define ScreenY375(y)   y * SCREEN_HEIGHT / 375

@interface PlaceSelectPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_recProv;//省
    NSString *_recCity;//市
    NSString *_recArea;//区
    NSString *_selectedProvince;//选中的省份
    UIButton *_shadowBtn;//蒙尘效果按钮
}

@property (nonatomic,strong)  UIPickerView         * pickerView;

///地址数组
@property (nonatomic, strong)  NSArray        * areaDataSource;
///省份数组
@property (nonatomic, strong)  NSMutableArray * provinceArray;
///城市数组
@property (nonatomic, strong)  NSMutableArray * cityArray;
///城镇区数组
@property (nonatomic, strong)  NSMutableArray * districtArray;
///存放地址的字典
@property (nonatomic, strong)  NSDictionary   * dataDict;
///pickview的完成工具条
@property (nonatomic, strong)  UIView         * pickViewToobar;

@end

@implementation PlaceSelectPickerView

+(void)selectPickViewWithValueBlock:(PlaceSelectPickerViewBlock)valueBlock
{
    PlaceSelectPickerView * pickView = [[PlaceSelectPickerView alloc] init];
    pickView.gk_size = CGSizeMake(SCREEN_WIDTH, ScreenX375(240));
    pickView.selectMoreBlock = valueBlock;
    [pickView showPickView];
    [pickView initWithData];
    
    [GKCover coverFrom:[[UIApplication sharedApplication] keyWindow] contentView:pickView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:true];
}

//初始化三级联动地址
- (void)initWithData{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [self.dataDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[self.dataDict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    self.provinceArray = [[NSMutableArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [self.provinceArray objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[self.dataDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    self.cityArray = [[NSMutableArray alloc] initWithArray: [cityDic allKeys]];
    
    NSString *selectedCity = [self.cityArray objectAtIndex: 0];
    self.districtArray = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    _selectedProvince = [self.provinceArray objectAtIndex: 0];
    
}

- (void)showPickView
{
    [self endEditing:YES];
    if (!self.pickerView){
        _recProv = @"北京市";
        _recCity = @"北京市";
        _recArea = @"东城区";
        
        //工具条
        self.pickViewToobar = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, ScreenX375(44))];
        self.pickViewToobar.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickViewToobar];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(0, ScreenX375(43), SCREEN_WIDTH, ScreenX375(0.5));
        lineLabel.backgroundColor = [UIColor blackColor];
        [self.pickViewToobar addSubview:lineLabel];
        
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenX375(20), 0, ScreenX375(40), ScreenX375(44))];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(isClosePickerView) forControlEvents:UIControlEventTouchUpInside];
        [self.pickViewToobar addSubview:cancleBtn];
        
        UIButton *achiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - ScreenX375(50), 0, ScreenX375(40), ScreenX375(44))];
        [achiveBtn setTitle:@"完成" forState:UIControlStateNormal];
        achiveBtn.tag = 1;
        [achiveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [achiveBtn addTarget:self action:@selector(completePick) forControlEvents:UIControlEventTouchUpInside];
        [self.pickViewToobar addSubview:achiveBtn];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.frame = CGRectMake(0, ScreenX375(44), SCREEN_WIDTH, ScreenX375(196));
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
        
        
    }
}

///隐藏选择器
-(void)isClosePickerView
{
    [GKCover hideCover];
}

///完成选择器所选择
-(void)completePick
{
    if (self.selectMoreBlock) {
        self.selectMoreBlock(_recProv,_recCity,_recArea);
    }
    [GKCover hideCover];
}

// 返回的列显示的数量。
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//返回行数在每个组件(每一列)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else{
        return self.districtArray.count;
    }
}

//每一列组件的列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (SCREEN_WIDTH - ScreenX375(40))/3;
}

//每一列组件的行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

// 返回每一列组件的每一行的标题内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray[row];
    }else if (component == 1){
        return self.cityArray[row];
    }else{
        return self.districtArray[row];
    }
}

//执行选择某列某行的操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //让三级联动，存在关系跳转
    if (component == 0) {
        _selectedProvince = [self.provinceArray objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.dataDict objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        self.cityArray = [[NSMutableArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        self.districtArray = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: [self.cityArray objectAtIndex: 0]]];
        [self.pickerView selectRow: 0 inComponent: 1 animated: YES];
        [self.pickerView selectRow: 0 inComponent: 2 animated: YES];
        [self.pickerView reloadComponent: 1];
        [self.pickerView reloadComponent: 2];
        
    }
    else if (component == 1) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[self.provinceArray indexOfObject: _selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.dataDict objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        self.districtArray = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.pickerView selectRow: 0 inComponent: 2 animated: YES];
        [self.pickerView reloadComponent: 2];
    }
    
    //获得当前选中的城市
    NSInteger provinceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger districtIndex = [self.pickerView selectedRowInComponent:2];
    
    NSString *provinceStr = [self.provinceArray objectAtIndex: provinceIndex];
    NSString *cityStr = [self.cityArray objectAtIndex: cityIndex];
    NSString *districtStr = [self.districtArray objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    _recProv = provinceStr;
    _recCity = cityStr;
    _recArea = districtStr;
    
    NSLog(@"%@%@%@",_recProv,_recCity,_recArea);
}

@end
