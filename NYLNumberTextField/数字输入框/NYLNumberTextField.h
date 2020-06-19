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
