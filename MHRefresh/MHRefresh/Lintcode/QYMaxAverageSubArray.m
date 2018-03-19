//
//  QYMaxAverageSubArray.m
//  MHRefresh
//
//  Created by panle on 2018/2/23.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYMaxAverageSubArray.h"

/*
 给定n个数的数组，找到所有长度大于等于k的连续子数组中平均值最大的那个。返回那个最大的平均值。
 
 1 <= k <= n <= 10000，数组中的元素在范围[-10000, 10000]之间，最后返回的答案的误差应在10^(-5)以内。
 
 输入： [1,12,-5,-6,50,3], k = 4
 输出： 12.75
 说明：
 长度为4的子数组中，最大的平均值为12.75，（=(12 + -5 + -6 + 50)/4）
 长度为5的子数组中，最大的平均值为10.8，（=(12 + -5 + -6 + 50 + 3)/5）
 长度为6的子数组中，最大的平均值为9.16667。（所有数的平均值）
 因此返回12.75。
 
 a. 可以枚举所有的长度大于等于k的子数组计算平均值，并对所有得到的平均值求最大值，这样可以做到时间复杂度O(n^2)，但是会超时。或许有同学会想到是不是可以只看长度为k的子数组，因为如果没有长度限制，那么显然最大平均值子数组就是数组中最大的数（长度为1的子数组），而且刚好样例给出的数据是满足长度为k的所有子数组的最大平均值随着k增大而减小的。很可惜这个想法是错误的，很容易举出反例，对于[1, -1, 1]， 长度1子数组的最大平均值为1，长度2的为0，长度3的为1/3，如果题目给出k=2，则应输出返回1/3而非0。
 
 
 b. 有些最值问题可以转化为判断问题从而用二分法求得答案。对于n个数a(0),a(1),……,a(n-1)，以及一个数A，如果存在一个子数组起始于i，长为L>=k，使得其平均值大于等于A，即(a(i)+a(i+1)+……+a(i+L-1))/L >= A，那么我们所求的答案应当大于等于A；反之如果对于所有长度大于等于k的子数组，其平均值均小于A，那么我们所求的答案也必然小于A。
 
 i. 如何判断是否存在长度至少为k的子数组，其平均值大于等于A？观察式子(a(i)+a(i+1)+……+a(i+L-1))/L >= A，其等价于(a(i)-A)+(a(i+1)-A)+……+(a(i+L-1)-A)>=0，令b(0)=a(0)-A , b(1)=a(1)-A , …… , b(n-1)=a(n-1)-A，那么判断a数组中是否存在长度至少为k的子数组平均值大于等于A，就变成了判断b数组中是否存在长度至少为k的子数组和大于等于0，只要求出b数组长度至少为k的子数组的最大和与0比较即可。
 
 ii. 求长度大于等于k的最大和子数组比原问题容易的多，令s为b的前缀和子数组，即s(i)=b(0)+b(1)+……+b(i-1)，且s(0)=0，那么b(j)到b(i-1)的区间和可表示为s(i)-s(j)，找长度大于等于k的最大和子数组等价于找i,j，满足i-j>=k，且使s(i)-s(j)最大。固定i，则要使s(i)-s(j)最大，s(j)应最小，同时也应满足j<=i-k，令p(i) = min{s(j)},j<=i-k，故 i 固定时s(i)-s(j)的最大值为s(i)-p(i)，枚举所有i即可得到最终的最大值。因为s(i),p(i)均可通过递推得到，故时间复杂度为O(n)。
 
 iii. 这样一来，我们就可以二分答案，二分的初始区间可以设置为[min{a(i)},i=0~n-1 , max{a(i)},i=0~n-1]，因为一组数的平均值不会小于这组数的最小值，也不会大于这组数的最大值。对于二分值A，通过前面讲的方法以O(n)的时间判断是否有子数组的平均值大于等于A，若有则答案大于等于A，若没有，则答案小于A。二分至区间长度小于所需精度，即可返回该值。时间复杂度为O(n*log((MAX-MIN) / eps))，其中MIN、MAX分别为a数组的最小值和最大值，eps为要求的精度。
 
 Follow up：本题亦有O(n)时间复杂度的算法（斜率优化/单调队列），但是比较难以理解，而且在面试中一般不会考，有兴趣的读者可以了解一下。
 */

@implementation QYMaxAverageSubArray

- (void)qy_lintcodeSolution {
    NSArray *array = @[@(1), @(12), @(-5), @(-6), @(50), @(3)];
    NSLog(@"%f", [self findMaxAverage:array number:4]);
}

- (double)findMaxAverage:(NSArray *)nums number:(int)k {
    
    NSInteger n = nums.count;
    
    double l = NSIntegerMax;
    double r = NSIntegerMin;
    
    for (NSInteger i = 0; i < n; i++) {
        l = MIN(l, [nums[i] doubleValue]);
        r = MAX(r, [nums[i] doubleValue]);
    }
    
    NSMutableArray *sunNums = [NSMutableArray arrayWithCapacity:n + 1];
    sunNums[0] = @0.0;
    
    while (r - l > 1e-6) {
        double mid = (r + l) / 2;
        for (int i = 0; i < n; i++) {
            sunNums[i + 1] = @([sunNums[i] doubleValue] + [nums[i] doubleValue] - mid);
        }
        
        double preMin = 0;
        double sunMax = NSIntegerMin;
        
        for (int i = k; i <= n; i++) {
            sunMax = MAX(sunMax, [sunNums[i] doubleValue] - preMin);
            preMin = MIN(preMin, [sunNums[i - k + 1] doubleValue]);
        }
        
        if (sunMax >= 0) {
            l = mid;
        } else {
            r = mid;
        }
    }
    
    return l;
}

@end
