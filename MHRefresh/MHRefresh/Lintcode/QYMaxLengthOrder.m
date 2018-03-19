//
//  QYMaxLengthOrder.m
//  MHRefresh
//
//  Created by panle on 2018/3/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYMaxLengthOrder.h"

/*
 给一列没有经过排序的数，计算最长的递增序列有几个
 
 ⅰ. 输入：[1,3,5,4,7]
 ⅱ. 输出 : 2
 ⅲ. 说明 ： 可见上升的最长序列有这么两个，[1, 3, 4, 7] 和 [1, 3, 5, 7]
 ⅳ. 输入：[2,2,2,2,2]
 ⅴ. 输出 ： 5
 ⅵ. 说明： 最长的长度为 1 ，有5个情况，每个都是2

 
 1.首先解决最长的递增序列问题，最朴素的做法是深搜，以每一个数为开头，找位置在它后面的且数值比它大的为下一层，显然会超时，考虑用动态规划去解决问题(也就是最长上升序列（LIS），一个经典的动态规划问题)
 
 2.设dp[i]为以该数结尾，能构成的最长序列的长度。进行连接的时候，对于每个数字num[i]，遍历位置在它之前的数字num[j]，如果比这个数小（num[j]<num[i]），也就是能构成一个序列，这样就能进行状态转移，我们令dp[i]=max(dp[i],dp[j]+1)来保证存储的为最长长度，同时可以记录max(dp[i])
 
 3.考虑完题目的长度优先后，我们考虑数量，也就是说最长长度的序列有几个，这个问题需要我们在处理dp的时候来记录，我们设ans[i]为以第i个数结尾的最长序列的个数，与dp同理，ans初值也都是1
 
 4.状态转移的时候，如果dp更新了，也就是说（dp[j]+1>dp[i]）说明这个长度的序列是新出现的，我们需要将ans[i]设置为ans[j]，因为新序列中，最新的数提供了序列的尾巴，数量是由前面积累的（或者说转移）；举例序列[1 1 3 7]我们易得数字3对应的dp=2,ans=2,因为可以构成两个[1 3]那么我们操作到数字7的时候，发现接在3后面最长，就可以转移ans来作为初始数量

 5.而当dp[j]+1==dp[i]的时候，如同样例，操作7的时候，我们最先发现了可以接在5后面，最长序列[1 3 5 7],然后发现可以接在4后面，[1 3 4 7]，长度也是4，这时候就同样需要转移ans，加上去 ans[i]+=ans[j]

 6.最后我们需要遍历dp，找到dp[i]=我们记录的最大值的时候，累加我们得到的ans[i]，即为所求结果，时间复杂度是O(n^2)
 */

@implementation QYMaxLengthOrder

- (void)qy_lintcodeSolution {
    NSArray *array = @[@(1), @(3), @(5), @(4), @(7)];
    [self findNumberOfList:array];
}

- (void)findNumberOfList:(NSArray *)nums {
    NSInteger len = nums.count, max_ans = 1, cnt = 0;
    NSMutableArray *dp = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *ans = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < nums.count * nums.count + 1; i++) {
        dp[i] = @(0);
        ans[i] = @(0);
    }
    
    for (NSInteger i = 0; i < len; i++) {
        
        dp[i] = @(1);
        ans[i] = @(1);
        
        NSInteger numsi = [nums integerWithIndex:i];
        
        for (int j = 0; j < i; j++) {
            if ([nums integerWithIndex:j] < numsi &&
                [dp integerWithIndex:j] + 1 > [dp integerWithIndex:i]) {
                dp[i] = @([dp integerWithIndex:j] + 1);
                ans[i] = ans[j];
            } else if ([nums integerWithIndex:j] < numsi &&
                       [dp integerWithIndex:j] + 1 == [dp integerWithIndex:i]) {
                ans[i] = @([ans integerWithIndex:i] + [ans integerWithIndex:j]);
            }
        }
        
        if ([dp integerWithIndex:i] > max_ans) {
            max_ans = [dp integerWithIndex:i];
        }
    }
    
    for (int i = 0; i < len; i++) {
        if ([dp integerWithIndex:i] == max_ans) {
            cnt += [ans integerWithIndex:i];
        }
    }
    
    DLog(@"%@ = %ld", NSStringFromClass([self class]), cnt);
}

@end
