//
//  QYCircleSubString.m
//  MHRefresh
//
//  Created by panle on 2018/2/26.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYCircleSubString.h"

/*
 假设s是一个无限循环的字符串”abcdefghijklmnopqrstuvwxyz”，s就是一个”...zabcdefghijklmnopqrstuvwxyza...”这样的字符串，现在给你另外一个字符串p，求p中存在多少个截然不同的子串，使得它们也是s的子串。p只包括英语的小写字母并且p的长度可能大于10000。
 
 输入：a  输出：1
 说明：只有'a'是s的子串。

 输入：a  输出：1
 说明：只有'a'是s的子串。

 输入：a  输出：1
 说明：只有'a'是s的子串。

 1. 这一题我们首先考虑的是，一个长为n的连续的串，有多少个符合题目要求的子串呢？经过思考我们可以得出长为n的连续的串，我们有1+2+3+...+n这么多个符合题目要求的子串。
 
 2. 解决了上述这个问题，我们直接找出p中所有连续的子串的长度L1,L2,L3...Ln,我们若是直接对(1~L1)(1~L2)...(1~Ln)求和，我们得到的结果显然是错误的，因为会存在字符串重复的问题，例如abcdpjiezabc，这里abcd和zabc有一部分abc是重复的，我们要求有多少种不同的子串，就需要把这部分重复的减去。如果我们采用暴力计算的方法显然很麻烦，那么我们要如何才能避免计算到重复的呢？
 
 3. 在我们学过的数据结构中，有一种数据结构可以避免重复，那就是哈希表！
 
 在本问题中，我们也可以通过哈希表去重。对于一个符合条件的子串（符合条件指的是该串为p的子串），我们只需要记录“长度”和“结尾字符”这两个关键字就可以唯一确定这个子串。我们以abcdpjiezabc为例，两个符合条件的极大子串为abcd和zabc，对于abcd，我们把[1,a],[2,b],[3,c],[4,d]记录到哈希表。细心的读者可以发现，我们不需要记录[1,b],[2,c]等等，因为[2,b],[3,c]天然包含了长度比它们小的子串。对于zabc，我们记录[1,z],[2,a],[3,b][4,c]
 
 4.得到哈希表之后，我们如何统计答案呢？
 
 我们发现，对于[1,a]，因为哈希表中已经存在[2,a]，所以[1,a]所表示的子串已经在[2,a]中被统计。也就是说，为了避免重复统计，我们只需要记录某个字母结尾的、长度最大的那个符合条件的子串长度就可以了。假设我们的哈希表中对应某个字母P的最长子串长度为k，因为长为k的字符串，有k个子串是以P结尾的，那么我们需要给最终答案加上k，这种统计方式把所有可能的子串都记录其中，并且不会重复。综上我们的算法时间复杂度为遍历数组和更新哈希表的时间复杂度：O(N)，空间复杂度为O(1)。
 */

@implementation QYCircleSubString

- (void)qy_lintcodeSolution {
    NSLog(@"%ld", [self findSubstringInWraproundString:@"zabc"]);
}

- (NSInteger)findSubstringInWraproundString:(NSString *)string {
    
    NSMutableArray *dp = [NSMutableArray arrayWithCapacity:26];
    
    for (int i = 0; i < 26; i++) {
        dp[i] = @0;
    }
    
    NSUInteger len = string.length;
    NSUInteger pos = 0;
    
    for (int i = 0; i < len; i++) {
        if (i > 0 && ([string characterAtIndex:i] - [string characterAtIndex:i - 1] == 1 || ([string characterAtIndex:i] == 'a' && [string characterAtIndex:i - 1] == 'z'))) {
            pos++;
        } else {
            pos = 1;
        }
        
        dp[[string characterAtIndex:i] - 'a'] = @(MAX(pos, [dp[[string characterAtIndex:i] - 'a'] integerValue]));
    }
    
    NSInteger ans = 0;
    
    for (NSNumber *number in dp) {
        ans += [number integerValue];
    }
    
    return ans;
}

@end
