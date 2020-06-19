//
//  NYLNumberTextField.m
//  NYL_UnitTest
//
//  Created by 聂银龙 on 2020/6/19.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import "NYLNumberTextField.h"

static NSInteger        NYL_MAX_LENGTH    = 0; // 0代表无穷大
static NSString * const NYL_DOT_NUMBERS   = @"0123456789.\n";
static NSString * const NYL_NORMAL_NUMBER = @"0123456789\n";

@implementation NYLNumberTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxLength = NYL_MAX_LENGTH;
        self.keepDecimalPlacesLength = 2;
        self.beforeDecimalMaxLength = NYL_MAX_LENGTH;
        self.canEdit = YES;
        _canHaveHeadZero = YES;
        self.delegate = self;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

// 根据条件限制输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.isCanInputDecimal) {
        if (![string isEqualToString:@""]) {
            NSCharacterSet *cs;
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NYL_DOT_NUMBERS] invertedSet];
                if (range.location >= self.beforeDecimalMaxLength && self.beforeDecimalMaxLength > 0) {
                    NSLog(@"小数点之前不能超过%ld位", self.beforeDecimalMaxLength);
                    if ([string isEqualToString:@"."] && range.location == self.beforeDecimalMaxLength) {
                        return YES;
                    }
                    return NO;
                }
            } else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NYL_NORMAL_NUMBER] invertedSet];
            }
            // 按cs分离出数组,数组按@""分离出字符串
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                NSLog(@"只能输入数字和小数点");
                return NO;
            }
            if (dotLocation != NSNotFound && range.location > dotLocation + self.keepDecimalPlacesLength) {
                NSLog(@"小数点后最多%ld位", self.keepDecimalPlacesLength);
                return NO;
            }
        }
        return YES;
    } else {
        static NSString *NUMBERS = @"0123456789";
        NSInteger maxLen = self.maxLength;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        
        NSString *numStr = textField.text;
        numStr = [numStr stringByReplacingCharactersInRange:range withString:string];
        if (numStr.length == 0) {
            return YES;
        } else {
            //限制首位是否为0(动态的)，以及限制至多maxLength位数
            NSInteger tempNum = [numStr integerValue];
            NSInteger headNnum = self.isCanHaveHeadZero ? 0 : 1;
            //if (tempNum < headNnum || numStr.length > maxLen) {
            if (tempNum < headNnum || (numStr.length > maxLen && maxLen > 0)) {
                return NO;
            }
        }
        return YES;
    }
    return YES;
}

- (void)setCanInputDecimal:(BOOL)canInputDecimal {
    _canInputDecimal = canInputDecimal;
    if (canInputDecimal) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.isCanEdit;
}

@end
