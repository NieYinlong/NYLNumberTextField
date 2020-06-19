# 先看效果
![图片](https://img-blog.csdnimg.cn/20200619165659170.gif#pic_center)
# 开发背景
项目开发中经常用到数字输入框，例如输入金额（小数点之前最多几位， 保留几位小数）、年龄（开头不能为0）、纯数字、这些都需要单独在 
```- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range```代理方法中判断，比较麻烦，为了不重复造轮子， 单位封装出来了一个通用数字输入框控件。NYLNumberTextField 继承自UITextField，在本类中加入各种属性，来满足各种数字输入需求。


# 如何使用
引入```NYLNumberTextField``头文件

##### 例1: 小数点保留两位小数
```Objc
 NYLNumberTextField *textField_1 = [[NYLNumberTextField alloc] init];
 textField_1.placeholder = @"小数点输入, 保留两位小数(例如金额输入)";
 textField_1.canInputDecimal = YES; // 是否可输入小数点
 textField_1.keepDecimalPlacesLength = 2; // 保留两位小数
 [self.view addSubview:textField_1];
```

##### 例2: 小数点输入,小数点之前限制4位, 保留两位小数
```Objc
 textField.keepDecimalPlacesLength = 2;
 textField.beforeDecimalMaxLength = 4;
```

##### 例3: 不能以0开头的纯数字, 限制3位(例如年龄)
```Objc
textField.canHaveHeadZero = NO;
textField.maxLength = 3;
```
##### 例4: 任意数字输入 
```Objc
NYLNumberTextField *textField_4 = [[NYLNumberTextField alloc] init];
textField_4.placeholder = @"任意纯数字输入, 不带小数点";
[self.view addSubview:textField_4];
```

# 源代码
###### NYLNumberTextField.h
```Objc
//
//  NYLNumberTextField.h
//  NYL_UnitTest
//
//  Created by 聂银龙 on 2020/6/19.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYLNumberTextField : UITextField<UITextFieldDelegate>

/// 无小数点的情况下限制输入数字的长度,  默认很大
@property (nonatomic, assign) NSInteger maxLength;
/// 不可输入小数点的情况下, 首位是否可为0, 默认YES
@property (nonatomic, assign, getter=isCanHaveHeadZero) BOOL canHaveHeadZero;
/// 是否可输入小数点, 默认NO
@property (nonatomic, assign, getter=isCanInputDecimal) BOOL canInputDecimal;
/// 保留几位小数, 默认2
@property (nonatomic, assign) NSInteger keepDecimalPlacesLength;
/// 小数点之前最多几位, 默认很大
@property (nonatomic, assign) NSInteger beforeDecimalMaxLength;
/// 是否可编辑, 默认YES
@property (nonatomic, assign, getter=isCanEdit) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END

```

######  NYLNumberTextField.m
```Objc
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

```
