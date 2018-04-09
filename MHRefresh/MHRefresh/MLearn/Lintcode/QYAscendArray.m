//
//  QYAscendArray.m
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYAscendArray.h"

/*
 给出包含n个整数的数组，你的任务是检查它是否可以通过修改至多一个元素变成非下降的。一个非下降的数组array对于所有的i（1<=i<n）满足array[i-1]<=array[i]。n属于区间[1,10000]。
 
 ⅰ 输入： [4,2,3]
 ⅱ 输出： True
 ⅲ 说明： 可以把第一个数4修改为1，得到[1,2,3]为非下降的数组最长上升子序列ⅲ 说明： 可以把第一个数4修改为1，得到[1,2,3]为非下降的数组
 
 ⅰ 输入： [4,2,1]
 ⅱ 输出： False
 ⅲ 说明： 无法通过修改至多一个元素使数组变为非下降的。

 a. 简单的思考可以得到，情况无非为三种：不需要修改就满足条件的、修改一个元素可满足条件的和修改一个元素也无法满足条件的。对于第一种情况，只需遍历数组看是否满足数组的每一项都大于等于前一项，满足则返回true。对于第二种情况，可以枚举要修改的那个数array[i]，再去检查array[i]之前的数是否是非下降的，array[i]之后的数是否是非下降的，最后还应该检查array[i-1]<=array[i+1]是否成立（如果array[i]位于边界则无需检查），如果成立则可以将array[i]改为array[i-1]和array[i+1]之间的任何数使数组变为非下降数组，这是情况二，返回true，如果对于所有的i都不成立，则为情况三，返回false。这样做的时间复杂度为O(n^2)，额外空间复杂度为O(1)。
 
 
 
 b. 修改一个数以后可以变成非下降的数组满足什么条件呢？显然，这样的数组应当满足只存在一对相邻的数不满足非下降的条件，即只存在唯一的i（1<=i<n）满足array[i-1]>array[i]，可以断言，如果这样的i存在多个，则原数组无法通过修改至多一个数变为非下降数组。那么是否满足这个条件的数组都可以通过修改一个数而满足非下降呢？不是的，比如[2,4,1,3]，只有相邻的4,1不满足非下降，但它不能通过只改变一个数变为非下降。其实，如果只存在一个i满足array[i-1]>array[i]，那么要修改的那个数一定在array[i-1]和array[i]这两个数之中，那么就可以套用上一种做法，对于两种情况分别进行判断即可。更进一步地来说，由于只有对于i才有array[i-1]>array[i]成立，所以别的所有相邻的数均满足非下降的条件，因此对于array[i-1]来说，它之前和它之后的数组均分别满足非下降的条件，对于array[i]亦是如此，所以，只需判断前后两段数组能否可以接成非下降的数组即可。具体来说，如果要修改的数是array[i-1]，那么只需判断array[i-2]<=array[i]是否成立，同样的如果要修改array[i]，那么应判断array[i-1]<=array[i+1]是否成立，当然如果array[i-1]或array[i]位于边界则直接成立。总结该算法：统计所有不满足非下降的相邻位置的个数count，如果count为0，则返回true（不用修改），若count大于1，则返回false，否则应进行进一步的判断：设不满足非下降的位置为i，array[i-1]>array[i]，则最终返回true的条件为array[i-1]、array[i]为边界或者array[i-2]<=array[i]或者array[i-1]<=array[i+1]。时间复杂度为O(n)，额外空间复杂度为O(1)。
 */

@implementation QYAscendArray

- (void)qy_lintcodeSolution {
    
}

- (BOOL)checkPossibility:(NSArray *)array {
    NSInteger n = array.count;
    NSInteger pos = 0, count = 0;
    
    for (int i = 1; i < n; i++) {
        if ([array[i - 1] integerValue] > [array[i] integerValue]) {
            pos = i;
            count++;
        }
        
        if (count > 1) {
            break;
        }
    }
    
    if (count == 0) {
        return YES;
    }
    
    if (count > 1) {
        return NO;
    }
    
    return pos == 1 || pos == n - 1 || [array[pos - 2] integerValue] <= [array[pos] integerValue] || [array[pos - 1] integerValue] <= [array[pos + 1] integerValue];
}

@end
