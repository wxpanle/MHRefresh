//
//  PLAudioFileSource.h
//  MHRefresh
//
//  Created by panle on 2018/3/15.
//  Copyright © 2018年 developer. All rights reserved.
//

#ifndef PLAudioFileSource_h
#define PLAudioFileSource_h


@protocol PLAudioFileSource <NSObject>

@required

/**
 音频文件来源
 
 以前缀https://  或者  http://  区分  是否需要下载
 
 @return Audio source
 */
- (NSURL *)audioFileSourceUrl;

@optional

/*
 缓存文件完成后调用询问  如果需要保存文件
 提供保存的文件地址  将会执行拷贝操作
 */
- (BOOL)isNeedSaveFile;
- (NSString *)fileSavePath;

@end

#endif /* PLAudioFileSource_h */
