//
//  UPFactory.m
//  Up
//
//  Created by panle on 2018/4/12.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPFactory.h"

@implementation UPFactory

#pragma mark - ===== UIView =====

+ (UIView *)up_viewWithFrame:(CGRect)frame {
    return [self up_viewWithFrame:frame bgColor:[UIColor whiteColor]];
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)bgColorHexString {
    return [self up_viewWithFrame:frame bgColor:[UIColor colorWithHexString:bgColorHexString]];
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color {
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadiud {
    
    UIView *view = [self up_viewWithFrame:frame bgColor:color];
    view.layer.cornerRadius = cornerRadiud;
    view.clipsToBounds = YES;
    return view;
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)hexString cornerRadius:(CGFloat)cornerRadiud {
    return [self up_viewWithFrame:frame bgColor:[UIColor colorWithHexString:hexString] cornerRadius:cornerRadiud];
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    UIView *view = [self up_viewWithFrame:frame bgColor:color cornerRadius:cornerRadiud];
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    return view;
}

+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)hexString cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColorHexString:(NSString *)borderColorHexString {
    return [self up_viewWithFrame:frame bgColor:[UIColor colorWithHexString:hexString] cornerRadius:cornerRadiud borderWidth:borderWidth borderColor:[UIColor colorWithHexString:borderColorHexString]];
}


#pragma mark - ===== label =====

+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    
    return [self up_labelWithFrame:frame text:text font:font textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentCenter lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor {
    
    return [self up_labelWithFrame:frame attributedText:attributedText font:font textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentCenter lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString {
    return [self up_singleLabelWithFrame:frame text:text font:font textColor:[UIColor colorWithHexString:hexString]];
}

+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(NSString *)hexString {
    return [self up_singleLabelWithFrame:frame attributedText:attributedText font:font textColor:[UIColor colorWithHexString:hexString]];
}

+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    return [self up_labelWithFrame:frame text:text font:font textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor {
    return [self up_labelWithFrame:frame attributedText:attributedText font:font textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString {
    return [self up_singleLeftLabelWithFrame:frame text:text font:font textColor:[UIColor colorWithHexString:hexString]];
}

+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(NSString *)hexString {
    return [self up_singleLeftLabelWithFrame:frame attributedText:attributedText font:font textColor:[UIColor colorWithHexString:hexString]];
}

+ (UILabel *)up_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    return [self p_labelWithFrame:frame text:text attributedText:nil font:font textColor:textColor numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:lineBreakMode];
}

+ (UILabel *)up_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    return [self up_labelWithFrame:frame text:text font:font textColor:[UIColor colorWithHexString:hexString] numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:lineBreakMode];
}

+ (UILabel *)up_labelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    return [self p_labelWithFrame:frame text:nil attributedText:attributedText font:font textColor:textColor numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:lineBreakMode];
}

+ (UILabel *)up_labelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(NSString *)hexString numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    return [self up_labelWithFrame:frame attributedText:attributedText font:font textColor:[UIColor colorWithHexString:hexString] numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:lineBreakMode];
}

+ (UILabel *)p_labelWithFrame:(CGRect)frame text:(NSString *)text attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(NSString *)hexString numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    return [self p_labelWithFrame:frame text:text attributedText:attributedText font:font textColor:[UIColor colorWithHexString:hexString] numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:lineBreakMode];
}

+ (UILabel *)p_labelWithFrame:(CGRect)frame text:(NSString *)text attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.lineBreakMode = lineBreakMode;
    label.numberOfLines = numberOfLines;
    if (text.length) {
        label.text = text;
    }
    if (attributedText) {
        label.attributedText = attributedText;
    }
    return label;
}



#pragma mark - ===== UIImageView =====

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//    imageView.image = [image up_imageOriginalRender];
    return imageView;
}

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName {
    return [self up_imageViewWithFrame:frame image:[UIImage imageNamed:imageName]];
}

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadiud {
    UIImageView *imageView = [self up_imageViewWithFrame:frame image:image];
    imageView.layer.cornerRadius = cornerRadiud;
    imageView.clipsToBounds = YES;
    return imageView;
}

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadiud {
    return [self up_imageViewWithFrame:frame image:[UIImage imageNamed:imageName] cornerRadius:cornerRadiud];
}

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    UIImageView *imageView = [self up_imageViewWithFrame:frame image:image cornerRadius:cornerRadiud];
    imageView.layer.borderColor = borderColor.CGColor;
    imageView.layer.borderWidth = borderWidth;
    return imageView;
}

+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [self up_imageViewWithFrame:frame image:[UIImage imageNamed:imageName] cornerRadius:cornerRadiud borderWidth:borderWidth borderColor:borderColor];
}



@end
