//
//  ViewController.m
//  NYLNumberTextField
//
//  Created by 聂银龙 on 2020/6/19.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import "ViewController.h"
#import "NYLNumberTextField.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NYLNumberTextField *textField_1 = [[NYLNumberTextField alloc] init];
    textField_1.placeholder = @"小数点输入, 保留两位小数(例如金额输入)";
    textField_1.canInputDecimal = YES;
    textField_1.keepDecimalPlacesLength = 2;
    [self addBorderTF:textField_1];
    [self.view addSubview:textField_1];
    
    NYLNumberTextField *textField_2 = [[NYLNumberTextField alloc] init];
    textField_2.placeholder = @"小数点输入,小数点之前限制4位, 保留两位小数";
    textField_2.canInputDecimal = YES;
    textField_2.keepDecimalPlacesLength = 2;
    textField_2.beforeDecimalMaxLength = 4;
    [self addBorderTF:textField_2];
    [self.view addSubview:textField_2];


    NYLNumberTextField *textField_3 = [[NYLNumberTextField alloc] init];
    textField_3.placeholder = @"不能以0开头的纯数字, 限制3位(例如年龄)";
    textField_3.canHaveHeadZero = NO;
    textField_3.maxLength = 3;
    [self addBorderTF:textField_3];
    [self.view addSubview:textField_3];


    NYLNumberTextField *textField_4 = [[NYLNumberTextField alloc] init];
    textField_4.placeholder = @"任意纯数字输入, 不带小数点";
    [self addBorderTF:textField_4];
    [self.view addSubview:textField_4];
    
    [textField_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    [textField_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField_1.mas_bottom).offset(20);
        make.left.right.height.equalTo(textField_1);
    }];

    [textField_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField_2.mas_bottom).offset(20);
        make.left.right.height.equalTo(textField_1);
    }];

    [textField_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField_3.mas_bottom).offset(20);
        make.left.right.height.equalTo(textField_1);
    }];
}


- (void)addBorderTF:(UITextField *)textField {
    textField.borderStyle = UITextBorderStyleRoundedRect;
}



@end
