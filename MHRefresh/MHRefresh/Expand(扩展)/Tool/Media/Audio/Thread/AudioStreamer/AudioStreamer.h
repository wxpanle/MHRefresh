//
//  AudioStreamer.h
//  StreamingAudioPlayer
//
//  Created by Matt Gallagher on 27/09/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#if TARGET_OS_IPHONE			
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif // TARGET_OS_IPHONE

#include <pthread.h>
#include <AudioToolbox/AudioToolbox.h>

#define LOG_QUEUED_BUFFERS 0  //缓冲队列buffers个数

/* Number of audio queue buffers we allocate.
   Needs to be big enough to keep audio pipeline busy (non-zero number of queued buffers) but not so big that audio takes too long to begin (kNumAQBufs * kAQBufSize of data must be loaded before playback will start).  选择一个合理值保证音频数据管道一直处于繁忙状态
 
 Set LOG_QUEUED_BUFFERS to 1 to log how many buffers are queued at any time -- if it drops to zero too often, this value may need to increase. Min 3, typical 8-24.  开启打印日志   如果经常降为0  就需要增加  典型的是8-24
 */
#define kNumAQBufs 16

/* Number of bytes in each audio queue buffer.  队列缓冲的默认大小
 
 Needs to be big enough to hold a packet of audio from the audio file. If number is too large, queuing of audio before playback starts will take too long.  需要足够大的值保存音频文件中的音频包  但是如果太大会造成浪费时间排序
 
 Highly compressed files can use smaller numbers (512 or less). 2048 should hold all but the largest packets. A buffer size error will occur if this number is too small.  高度压缩的文件可以使用较小的数字  2048 应该包含最大的数据包的大小  如果  数据包大于2048  则会发生读取数据错误
 */
#define kAQDefaultBufSize 2048

/* Number of packet descriptions in our array
   卡包描述符
 */
#define kAQMaxPacketDescs 512

typedef enum {
    //初始化
	AS_INITIALIZED = 0,
	//开启文件读取通道
    AS_STARTING_FILE_THREAD,
	//等待缓冲
    AS_WAITING_FOR_DATA,
	//缓冲结束
    AS_FLUSHING_EOF,
	//等待队列开始
    AS_WAITING_FOR_QUEUE_TO_START,
	//播放中
    AS_PLAYING,
	//缓冲中
    AS_BUFFERING,
	//停止中
    AS_STOPPING,
	//停止
    AS_STOPPED,
	//暂停
    AS_PAUSED
} AudioStreamerState; //状态

typedef enum {
    //没有停止
	AS_NO_STOP = 0,
	//停止中
    AS_STOPPING_EOF,
	//用户动作
    AS_STOPPING_USER_ACTION,
	//发生了错误
    AS_STOPPING_ERROR,
	//临时停止
    AS_STOPPING_TEMPORARILY
} AudioStreamerStopReason; //停止原因

typedef enum {
    //没有错误
	AS_NO_ERROR = 0,
	//网络连接失败
    AS_NETWORK_CONNECTION_FAILED,
	//获取属性失败
    AS_FILE_STREAM_GET_PROPERTY_FAILED,
	//设置属性失败
    AS_FILE_STREAM_SET_PROPERTY_FAILED,
	//seek失败
    AS_FILE_STREAM_SEEK_FAILED,
	//解析字节失败
    AS_FILE_STREAM_PARSE_BYTES_FAILED,
	//开启失败
    AS_FILE_STREAM_OPEN_FAILED,
	//关闭失败
    AS_FILE_STREAM_CLOSE_FAILED,
	//数据传入失败
    AS_AUDIO_DATA_NOT_FOUND,
	//创建队列失败
    AS_AUDIO_QUEUE_CREATION_FAILED,
	//队列开辟缓冲失败
    AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED,
	//加入数据失败
    AS_AUDIO_QUEUE_ENQUEUE_FAILED,
	//添加监听失败
    AS_AUDIO_QUEUE_ADD_LISTENER_FAILED,
	//移除监听失败
    AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED,
	//开启队列失败
    AS_AUDIO_QUEUE_START_FAILED,
	//暂停队列失败
    AS_AUDIO_QUEUE_PAUSE_FAILED,
	//队列格式不匹配
    AS_AUDIO_QUEUE_BUFFER_MISMATCH,
	//销毁队列失败
    AS_AUDIO_QUEUE_DISPOSE_FAILED,
	//停止队列失败
    AS_AUDIO_QUEUE_STOP_FAILED,
	//缓动队列失败
    AS_AUDIO_QUEUE_FLUSH_FAILED,
	//
    AS_AUDIO_STREAMER_FAILED,
	//获取队列播放时间失败
    AS_GET_AUDIO_TIME_FAILED,
	//缓冲数据太小
    AS_AUDIO_BUFFER_TOO_SMALL
} AudioStreamerErrorCode;  //错误代码

//队列状态改变通知
extern NSString * const ASStatusChangedNotification;

@interface AudioStreamer : NSObject
{
    //播放url
	NSURL *url;

    /*  Special threading consideration:
     The audioQueue property should only ever be accessed inside a synchronized(self) block and only *after* checking that ![self isFinishing]
     audioQueue 会同步回调自身的监听属性
     */
	AudioQueueRef audioQueue;
    //定义表示音频文件解析流的不透明数据类型
	AudioFileStreamID audioFileStream;	// the audio file stream parser
    //音频描述文件
	AudioStreamBasicDescription asbd;	// description of the audio
    //播放音频的线程
	NSThread *internalThread;			// the thread where the download and
										// audio file stream parsing occurs
	
    //audio queue 缓冲
	AudioQueueBufferRef audioQueueBuffer[kNumAQBufs];		// audio queue buffers
	AudioStreamPacketDescription packetDescs[kAQMaxPacketDescs];	// packet descriptions for enqueuing audio
	//正在被填充的缓冲队列音频
    unsigned int fillBufferIndex;	// the index of the audioQueueBuffer that is being filled
	//包缓冲大小
    UInt32 packetBufferSize;
	//已经被填充的字节
    size_t bytesFilled;				// how many bytes have been filled
	//有多少已经被填充的包
    size_t packetsFilled;			// how many packets have been filled
	//标记表明缓冲是否在被使用
    bool inuse[kNumAQBufs];			// flags to indicate that a buffer is still in use
    //缓冲使用
    NSInteger buffersUsed;
	//http请求头
    NSDictionary *httpHeaders;
	//文件扩展
    NSString *fileExtension;
	
    //状态
	AudioStreamerState state;
	//最后一次状态
    AudioStreamerState laststate;
	//停止原因
    AudioStreamerStopReason stopReason;
	//错误代码
    AudioStreamerErrorCode errorCode;
	//
    OSStatus err;
	
    //标志指示音频流是不连续的
	bool discontinuous;			// flag to indicate middle of the stream
	
    //锁
	pthread_mutex_t queueBuffersMutex;			// a mutex to protect the inuse flags
	pthread_cond_t queueBufferReadyCondition;	// a condition varable for handling the inuse flags

	CFReadStreamRef stream;
	NSNotificationCenter *notificationCenter;
	
    //音频流的比特率
	UInt32 bitRate;				// Bits per second in the file
    //流中第一个音频数据包的偏移量
	NSInteger dataOffset;		// Offset of the first audio packet in the stream
    //文件的长度
	NSInteger fileLength;		// Length of the file in bytes
    //seek的字节
	NSInteger seekByteOffset;	// Seek offset within the file in bytes
    //字节总数  当文件中的实际音频字节数已知时使用
	UInt64 audioDataByteCount;  // Used when the actual number of audio bytes in
								// the file is known (more accurate than assuming
								// the whole file is audio)

    //估算比特率使用
	UInt64 processedPacketsCount;		// number of packets accumulated for bitrate estimation
	UInt64 processedPacketsSizeTotal;	// byte size of accumulated estimation packets

    //seek时间
	double seekTime;
    //seek 请求
	BOOL seekWasRequested;
	//请求seek的时间
    double requestedSeekTime;
	//音频采样率
    double sampleRate;			// Sample rate of the file (used to compare with
								// samples played by the queue for current playback
								// time)
    //包时长 采样率 * 每个数据包的帧数
	double packetDuration;		// sample rate times frames per packet
    //最后计算的进度点
	double lastProgress;		// last calculated progress point
#if TARGET_OS_IPHONE
    //异常 打断音频  如电话、拔下耳机等
	BOOL pausedByInterruption;
#endif
}

//错误码
@property AudioStreamerErrorCode errorCode;
//状态
@property (readonly) AudioStreamerState state;
//进度
@property (readonly) double progress;
//时长
@property (readonly) double duration;
//bitrate
@property (readwrite) UInt32 bitRate;
//请求头
@property (readonly) NSDictionary *httpHeaders;
//文件扩展
@property (copy,readwrite) NSString *fileExtension;
//是否展示弹窗  错误提示
@property (nonatomic) BOOL shouldDisplayAlertOnError; // to control whether the alert is displayed in failWithErrorCode

//初始化
- (id)initWithURL:(NSURL *)aURL;
//开始
- (void)start;
//停止
- (void)stop;
//暂停
- (void)pause;
//播放中
- (BOOL)isPlaying;
//是否暂停
- (BOOL)isPaused;
//是否等待
- (BOOL)isWaiting;
//是否空闲
- (BOOL)isIdle;
//是否终止
- (BOOL)isAborted; // return YES if streaming halted due to error (AS_STOPPING + AS_STOPPING_ERROR)
//seek到某以时间点
- (void)seekToTime:(double)newSeekTime;
//计算比特率
- (double)calculatedBitRate;

@end






