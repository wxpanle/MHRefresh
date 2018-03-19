//
//  QYNumberDecode.m
//  MHRefresh
//
//  Created by panle on 2018/2/26.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYNumberDecode.h"

/*
 一个包含A到Z的消息通过如下方式加密：
 
 'A' -> 1
 'B' -> 2
 ...
 'Z' → 26
 
 除了上述规则外，加密字符串还可能包含字符'*'，可以将其视为一个1到9之间的数字字符。给定一个包含数字字符和'*'的加密信息，问有几种解码方式。由于答案可能很大，只需返回答案对10^9+7取模后的结果即可。
 
 输入: "*"
 输出: 9
 说明: 该加密信息可解码为这些字符串："A", "B", "C", "D", "E", "F", "G", "H", "I"。
 
 输入: "1*"
 输出: 18
 说明:  "1*"可以表示"11"、"12"、……、"19"，每种表示都既可以解码成单个字符，也可以解码成两个字符，答案为9+9=18。
 
 */

@implementation QYNumberDecode

@end
