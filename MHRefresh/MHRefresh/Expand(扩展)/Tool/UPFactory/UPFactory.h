//
//  UPFactory.h
//  Up
//
//  Created by panle on 2018/4/12.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFactory : NSObject

///------------------------------
/// @name UIView
///------------------------------

/**
 工厂创建view [UIColor whiteColor]

 @param frame frame
 @return      UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame;

/**
 工厂创建view
 
 @param frame  frame
 @param bgColorHexString color hex string
 @return       UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)bgColorHexString;

/**
 工厂创建view

 @param frame frame
 @param color color
 @return      UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color;

/**
 工厂创建view

 @param frame        frame
 @param color        color
 @param cornerRadiud cornerRadiud
 @return              UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadiud;

/**
 工厂创建view

 @param frame        frame
 @param hexString    hexString
 @param cornerRadiud cornerRadiud
 @return             UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)hexString cornerRadius:(CGFloat)cornerRadiud;

/**
 工厂创建view

 @param frame        frame
 @param color        color
 @param cornerRadiud cornerRadiud
 @param borderWidth  borderWidth
 @param borderColor  borderColor
 @return             UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 工厂创建view

 @param frame        frame
 @param hexString    hexString
 @param cornerRadiud cornerRadiud
 @param borderWidth  borderWidth
 @param borderColorHexString  borderColor
 @return             UIView
 */
+ (UIView *)up_viewWithFrame:(CGRect)frame bgColorHexString:(NSString *)hexString cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColorHexString:(NSString *)borderColorHexString;


///------------------------------
/// @name UILabel
///------------------------------

/**
 工厂创建 UILabel
 textAlignment = Center,lineBreakMode = Tail,numberOfLines = 1

 @param frame     frame
 @param text      text
 @param font      font
 @param textColor textColor
 @return          UILabel
 */
+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 工厂创建 UILabel
 textAlignment = Center,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param textColor      textColor
 @return               UILabel
 */
+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 工厂创建 UILabel
 textAlignment = Center,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame     frame
 @param text      text
 @param font      font
 @param hexString hexString
 @return          UILabel
 */
+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString;

/**
 工厂创建 UILabel
 textAlignment = Center,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param hexString      hexString
 @return               UILabel
 */
+ (UILabel *)up_singleLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(NSString *)hexString;

/**
 工厂创建 UILabel
 textAlignment = Left,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame     frame
 @param text      text
 @param font      font
 @param textColor textColor
 @return          UILabel
 */
+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 工厂创建 UILabel
 textAlignment = Left,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param textColor      textColor
 @return               UILabel
 */
+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 工厂创建 UILabel
 textAlignment = Left,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame     frame
 @param text      text
 @param font      font
 @param hexString hexString
 @return          UILabel
 */
+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString;

/**
 工厂创建 UILabel
 textAlignment = Left,lineBreakMode = Tail,numberOfLines = 1
 
 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param hexString      hexString
 @return               UILabel
 */
+ (UILabel *)up_singleLeftLabelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(UIColor *)hexString;

/**
 工厂创建 UILabel

 @param frame         frame
 @param text          text
 @param font          font
 @param textColor     textColor
 @param numberOfLines numberOfLines
 @param textAlignment textAlignment
 @param lineBreakMode lineBreakMode
 @return              UiLabel
 */
+ (UILabel *)up_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 工厂创建 UILabel
 
 @param frame         frame
 @param text          text
 @param font          font
 @param hexString     hexString
 @param numberOfLines numberOfLines
 @param textAlignment textAlignment
 @param lineBreakMode lineBreakMode
 @return              UiLabel
 */
+ (UILabel *)up_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColorHexString:(NSString *)hexString numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 工厂创建 UILabel

 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param textColor      textColor
 @param numberOfLines  numberOfLines
 @param textAlignment  textAlignment
 @param lineBreakMode  lineBreakMode
 @return               UIlabel
 */
+ (UILabel *)up_labelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 工厂创建 UILabel
 
 @param frame          frame
 @param attributedText attributedText
 @param font           font
 @param hexString      hexString
 @param numberOfLines  numberOfLines
 @param textAlignment  textAlignment
 @param lineBreakMode  lineBreakMode
 @return               UIlabel
 */
+ (UILabel *)up_labelWithFrame:(CGRect)frame attributedText:(NSAttributedString *)attributedText font:(UIFont *)font textColorHexString:(UIColor *)hexString numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

///------------------------------
/// @name UIImageView
///------------------------------

/**
 工厂创建UIImageView

 @param frame frame
 @param image image
 @return      UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image;

/**
 工厂创建UIImageView
 
 @param frame     frame
 @param imageName imageName
 @return          UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

/**
 工厂创建UIImageView
 
 @param frame        frame
 @param image        image
 @param cornerRadiud cornerRadiud
 @return             UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadiud;

/**
 工厂创建UIImageView
 
 @param frame        frame
 @param imageName    imageName
 @param cornerRadiud cornerRadiud
 @return             UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadiud;

/**
 工厂创建UIImageView
 
 @param frame        frame
 @param image        image
 @param cornerRadiud cornerRadiud
 @param borderWidth  borderWidth
 @param borderColor  borderColor
 @return             UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 工厂创建UIImageView
 
 @param frame        frame
 @param imageName    imageName
 @param cornerRadiud cornerRadiud
 @param borderWidth  borderWidth
 @param borderColor  borderColor
 @return             UIImageView
 */
+ (UIImageView *)up_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadiud borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
