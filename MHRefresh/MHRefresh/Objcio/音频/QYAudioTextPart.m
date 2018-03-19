//
//  QYAudioTextPart.m
//  MHRefresh
//
//  Created by panle on 2018/2/26.
//  Copyright © 2018年 developer. All rights reserved.
//

/*
 http://msching.github.io/
 */

#import "QYAudioTextPart.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

/*
 iOS 音频播放概述1
 
 1.读取文件
 2.解析采样率、码率、时长等信息。分离音频帧
 3.对分离出来的音频帧解码得到PCM数据
 4.对PCM数据进行音效处理
 5.把PCM数据解码成音频信号
 6.把音频信号交给硬件播放
 7. re1-6
 
 Audio File Services 读写音频数据  步骤2
 Audio File Stream Services 对音频进行解码  步骤2
 
 Audio Converter Services  音频数据转换  步骤3
 
 Audio Processing Graph Services 音效处理模块  步骤4
 
 Audio Unit Services  播放音频数据  5.6
 
 Audio Queue Services 高级接口，可以进行录音和播放  3.5.6
 
 如果只是想实现音频的播放，没有其它需求   AVFoundation
 
 如果app需要进行流播放并且同时存储， AudioFileStreamer + AudioQueue  可以把音频数据下载到本地，一边下载异变使用NSFileHandled等接口读取音频文件交给AudioFileStreamer或者AudioFile解析分离音频帧，分离出来的音频帧可以发送给AudioQueue进行解码和播放。如果是本地文件直接读取解析即可
 
 如果你正在开发一个专业的音乐播放器，需要对音频添加音效，那么除了数据的读取和解析外还需要用到AudioCOnverter来把音频数据转换为PCM数据，再由AudioUnit+AUGraph来进行音效处理和播放
 
 */

@interface QYAudioTextPart () <MPMediaPickerControllerDelegate>

@end

@implementation QYAudioTextPart

- (void)p_audioSession {
    
    /*
     1.AudioToolBox中的AudioSession   废弃
     2.AVFoundation中的AVFudioSession
     
     如果最低版本支持iOS 5，可以使用AudioSession也可以考虑使用AVAudioSession，需要有一个类统一管理AudioSession的所有回调，在接到回调后发送对应的自定义通知；
     如果最低版本支持iOS 6及以上，请使用AVAudioSession，不用统一管理，接AVAudioSession的通知即可；
     根据app的应用场景合理选择Category；
     在deactive时需要注意app的应用场景来合理的选择是否使用NotifyOthersOnDeactivation参数；
     在处理InterruptEnd事件时需要注意ShouldResume的值。
     */
}

- (void)p_audioFileStream {
    /*
     AudioFileStreamer 用来读取采样率、码率、时长等基本信息记忆分离音频帧
     
     AudioFileStreamer
     */
    
    //初始化AudioFileStream
    
    /*!
     @function        AudioFileStreamOpen
     
     @discussion        Create a new audio file stream parser.
     The client provides the parser with data and the parser calls
     callbacks when interesting things are found in the data, such as properties and
     audio packets.
     
     @param            inClientData  //上下文对象
     a constant that will be passed to your callbacks.
     
     @param            inPropertyListenerProc
     Whenever the value of a property is parsed in the data, this function will be called.
     You can then get the value of the property from in the callback. In some cases, due to
     boundaries in the input data, the property may return kAudioFileStreamError_DataUnavailable.
     When unavailable data is requested from within the property listener, the parser will begin
     caching the property value and will call the property listener again when the property is
     available. For property values for which kAudioFileStreamPropertyFlag_PropertyIsCached is unset, this
     will be the only opportunity to get the value of the property, since the data will be
     disposed upon return of the property listener callback.
     
     @param            inPacketsProc  数据包的回调
     Whenever packets are parsed in the data, a pointer to the packets is passed to the client
     using this callback. At times only a single packet may be passed due to boundaries in the
     input data.
     
     @param             inFileTypeHint  文件类型
     For files whose type cannot be easily or uniquely determined from the data (ADTS,AC3),
     this hint can be used to indicate the file type.
     Otherwise if you do not know the file type, you can pass zero.
     
     @param            outAudioFileStream  输出文件流
     A new file stream ID for use in other AudioFileStream API calls.
     */
    //extern OSStatus  //判断初始化是否成功
//    AudioFileStreamOpen (
//                         void * __nullable                        inClientData,
//                         AudioFileStream_PropertyListenerProc    inPropertyListenerProc,
//                         AudioFileStream_PacketsProc                inPacketsProc,
//                         AudioFileTypeID                            inFileTypeHint,
//                         AudioFileStreamID __nullable * __nonnull outAudioFileStream)
//    __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);
    
    //解析数据
    /*!
     @function        AudioFileStreamParseBytes
     
     @discussion        This call is the means for streams to supply data to the parser.
     Data is expected to be passed in sequentially from the beginning of the file, without gaps.
     In the course of parsing, the client's property and/or packets callbacks may be called.
     At the end of the stream, this function must be called once with null data pointer and zero
     data byte size to flush any remaining packets out of the parser.
     
     @param            inAudioFileStream 初始化返回的id
     The file stream ID
     
     @param            inDataByteSize 本次解析的数据长度
     The number of bytes passed in for parsing. Must be zero when flushing the parser.
     
     @param            inData  本地解析的数据
     The data passed in to be parsed. Must be null when flushing the parser.
     
     @param            inFlags  本次的解析和上一次解析是否是连续的关系，如果是连续的传入0，否则传入 kAudioFileStreamParseFlag_Discontinuity
     If there is a data discontinuity（不连续）, then kAudioFileStreamParseFlag_Discontinuity should be set true.
     数据以帧的形式存在，解析时也需要以帧为单位解析。但在解码之前我们不能知道每个帧的边界在第几个字节我们传给AudioFileStreamParseBytes的数据在解析完成之后会有一部分数据余下来，这部分数据是接下去那一帧的前半部分，如果再次有数据输入需要继续解析时就必须要用到前一次解析余下来的数据才能保证帧数据完整，所以在正常播放的情况下传入0即可。目前知道的需要传入kAudioFileStreamParseFlag_Discontinuity的情况有两个，一个是在seek完毕之后显然seek后的数据和之前的数据完全无关；另一个是开源播放器AudioStreamer的作者@Matt Gallagher曾在自己的blog中提到过的：
     
     the Audio File Stream Services hit me with a nasty bug: AudioFileStreamParseBytes will crash when trying to parse a streaming MP3.
     
     In this case, if we pass the kAudioFileStreamParseFlag_Discontinuity flag to AudioFileStreamParseBytes on every invocation between receiving kAudioFileStreamProperty_ReadyToProducePackets and the first successful call to MyPacketsProc, then AudioFileStreamParseBytes will be extra cautious in its approach and won't crash.
     
     Matt发布这篇blog是在2008年，这个Bug年代相当久远了，而且原因未知，究竟是否修复也不得而知，而且由于环境不同（比如测试用的mp3文件和所处的iOS系统）无法重现这个问题，所以我个人觉得还是按照Matt的work around在回调得到kAudioFileStreamProperty_ReadyToProducePackets之后，在正常解析第一帧之前都传入kAudioFileStreamParseFlag_Discontinuity比较好。
     
     回到之前的内容，AudioFileStreamParseBytes方法的返回值表示当前的数据是否被正常解析，如果OSStatus的值不是noErr则表示解析不成功，其中错误码包括：
     enum
     {
     kAudioFileStreamError_UnsupportedFileType        = 'typ?',
     kAudioFileStreamError_UnsupportedDataFormat      = 'fmt?',
     kAudioFileStreamError_UnsupportedProperty        = 'pty?',
     kAudioFileStreamError_BadPropertySize            = '!siz',
     kAudioFileStreamError_NotOptimized               = 'optm',
     kAudioFileStreamError_InvalidPacketOffset        = 'pck?',
     kAudioFileStreamError_InvalidFile                = 'dta?',
     kAudioFileStreamError_ValueUnknown               = 'unk?',
     kAudioFileStreamError_DataUnavailable            = 'more',
     kAudioFileStreamError_IllegalOperation           = 'nope',
     kAudioFileStreamError_UnspecifiedError           = 'wht?',
     kAudioFileStreamError_DiscontinuityCantRecover   = 'dsc!'
     };
     大多数都可以从字面上理解，需要提一下的是kAudioFileStreamError_NotOptimized，文档上是这么说的：
     
     It is not possible to produce output packets because the file's packet table or other defining info is either not present or is after the audio data.
     
     它的含义是说这个音频文件的文件头不存在或者说文件头可能在文件的末尾，当前无法正常Parse，换句话说就是这个文件需要全部下载完才能播放，无法流播。
     
     注意AudioFileStreamParseBytes方法每一次调用都应该注意返回值，一旦出现错误就可以不必继续Parse了。
     
     
     */
    //extern OSStatus
    //AudioFileStreamParseBytes(
    //                          AudioFileStreamID                inAudioFileStream,
    //                          UInt32                            inDataByteSize,
    //                          const void * __nullable            inData,
    //                          AudioFileStreamParseFlags        inFlags);
    
    
    //解析文件格式信息
    //在调用AudioFileStreamParseBytes方法进行解析时会首先读取格式信息，并同步的进入AudioFileStream_PropertyListenerProc回调方法
    
    //typedef void (*AudioFileStream_PropertyListenerProc)(
    //                                                     void *                            inClientData,
    //                                                     AudioFileStreamID                inAudioFileStream,
    //                                                     AudioFileStreamPropertyID        inPropertyID,
    //                                                     AudioFileStreamPropertyFlags *    ioFlags);
    //第一个参数是open函数中的上下文对象
    //第二个参数open返回参数AudioFileStreamID的  ID
    //第三个参数是此次解析的信息id，表示当前propertyId对应的信息已经解析完成信息（例如数据格式、音频数据的偏移量等等），使用者可以通过AudioFileStreamGetProperty接口获取propertyId对应的值或者数据结构
    //extern OSStatus
    //AudioFileStreamGetProperty(
    //                           AudioFileStreamID                    inAudioFileStream,
    //                           AudioFileStreamPropertyID            inPropertyID,
    //                           UInt32 *                            ioPropertyDataSize,
    //                           void *                                outPropertyData)
    //__OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);
    //第四个参数ioFlags是一个返回参数，表示这个property是否需要被缓存，如果需要赋值kAudioFileStreamPropertyFlag_PropertyIsCached  否则不赋值
    //这个回调会进来多次，但并不是每一次都需要进行处理，可以根据需求处理需要的PropertyID进行处理（PropertyID列表如下）。
    //AudioFileStreamProperty枚举
    //enum
    //{
    //    kAudioFileStreamProperty_ReadyToProducePackets           =    'redy',
    //    kAudioFileStreamProperty_FileFormat                      =    'ffmt',
     //   kAudioFileStreamProperty_DataFormat                      =    'dfmt',
    //    kAudioFileStreamProperty_FormatList                      =    'flst',
    //    kAudioFileStreamProperty_MagicCookieData                 =    'mgic',
    //    kAudioFileStreamProperty_AudioDataByteCount              =    'bcnt',
    //    kAudioFileStreamProperty_AudioDataPacketCount            =    'pcnt',
    //    kAudioFileStreamProperty_MaximumPacketSize               =    'psze',
    //    kAudioFileStreamProperty_DataOffset                      =    'doff',
    //    kAudioFileStreamProperty_ChannelLayout                   =    'cmap',
    //    kAudioFileStreamProperty_PacketToFrame                   =    'pkfr',
    //    kAudioFileStreamProperty_FrameToPacket                   =    'frpk',
    //    kAudioFileStreamProperty_PacketToByte                    =    'pkby',
    //    kAudioFileStreamProperty_ByteToPacket                    =    'bypk',
    //    kAudioFileStreamProperty_PacketTableInfo                 =    'pnfo',
    //    kAudioFileStreamProperty_PacketSizeUpperBound            =    'pkub',
    //    kAudioFileStreamProperty_AverageBytesPerPacket           =    'abpp',
    //    kAudioFileStreamProperty_BitRate                         =    'brat',
    //    kAudioFileStreamProperty_InfoDictionary                  =    'info'
    //};
    
    //kAudioFileStreamProperty_BitRate   表示音频数据的码率，获取这个property是为了计算音频的总时长Duration
    //UInt32 bitrate;
    //UInt32 bitRateSize = sizeof(bitrate);
    //OSStatus status = AudioFileStreamGetProperty(<#AudioFileStreamID  _Nonnull inAudioFileStream#>, <#AudioFileStreamPropertyID inPropertyID#>, <#UInt32 * _Nonnull ioPropertyDataSize#>, <#void * _Nonnull outPropertyData#>);
    //if (status != noErr) {
        //错误处理
    //}
    //在流播放的情况下，有时数据流比较小时会出现ReadyToProducePackets还没有获取到bitRate的情况，这是就需要分离一些音频帧然后计算平均bitRate
    //UInt32 averageBitRate = totalPackectByteCount / totalPacketCout;
    
    //kAudioFileStreamProperty_DataOffset
    //表示音频数据在整个音频文件中的offset，这个值是seek音频文件的关键。音频的seek并不是直接seek文件位置而是seek时间，seek会根据时间计算出音频数据的字节offset然后需要机上音频数据的offset才能得到真正的offset
    SInt64 dataOffset;
    UInt32 offsetSize = sizeof(dataOffset);
    OSStatus status = AudioFileStreamGetProperty(nil, kAudioFileStreamProperty_DataOffset, &offsetSize, &dataOffset);
    if (status != noErr) {
        //错误处理
    }
    
    //kAudioFileStreamProperty_DataFormat
    //表示音频文件结构信息  是一个AudioStreamBaseDescription的结构
    struct AudioStreamBasicDescription
    {
        Float64 mSampleRate;
        UInt32  mFormatID;
        UInt32  mFormatFlags;
        UInt32  mBytesPerPacket;
        UInt32  mFramesPerPacket;
        UInt32  mBytesPerFrame;
        UInt32  mChannelsPerFrame;
        UInt32  mBitsPerChannel;
        UInt32  mReserved;
    };
    AudioStreamBasicDescription asbd;
    UInt32 asbdSize = sizeof(asbd);
    OSStatus status1 = AudioFileStreamGetProperty(nil, kAudioFileStreamProperty_DataFormat, &asbdSize, &asbd);
    if (status1 != noErr)
    {
        //错误处理
    }
    
    //kAudioFileStreamProperty_FormatList\
    作用和kAudioFileStreamProperty_DataFormat是一样的，区别在于用这个PropertyID获取到是一个AudioStreamBasicDescription的数组，这个参数是用来支持AAC SBR这样的包含多个文件类型的音频格式。由于到底有多少个format我们并不知晓，所以需要先获取一下总数据大小：
    //获取数据大小
    Boolean outWriteable;
    UInt32 formatListSize;
    OSStatus status2 = AudioFileStreamGetPropertyInfo(nil, kAudioFileStreamProperty_FormatList, &formatListSize, &outWriteable);
    if (status2 != noErr)
    {
        //错误处理
    }
    //获取formatlist
    AudioFormatListItem *formatList = malloc(formatListSize);
    OSStatus status3 = AudioFileStreamGetProperty(nil, kAudioFileStreamProperty_FormatList, &formatListSize, formatList);
    if (status3 != noErr)
    {
        //错误处理
    }
    
    //选择需要的格式
    for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i++)
    {
        AudioStreamBasicDescription pasbd = formatList[i].mASBD;
        //选择需要的格式。。
    }
    free(formatList);
    
    //kAudioFileStreamProperty_AudioDataByteCount
    //音频文件中音频的总量，这个property的作用意识用来计算音频的总时长，而是可以可以在在seek时用来计算时间对应的字节offset
    UInt64 audioDataByteCount;
    UInt32 byteCountSize = sizeof(audioDataByteCount);
    OSStatus status4 = AudioFileStreamGetProperty(nil, kAudioFileStreamProperty_AudioDataByteCount, &byteCountSize, &audioDataByteCount);
    if (status4 != noErr) {
        //错误处理
    }
    //近似计算audioDataByteCount 音频文件的总大小一定是可以得到的
    UInt32 dataOffset1 = 0; // kAudioFileStreamProperty_DataOffset
    UInt32 fileLength = 0; //音频文件大小
    UInt32 audioDataByteCount2 = fileLength - dataOffset;
    
    //kAudioFileStreamProperty_ReadyToProducePackets
    //这个propertyID可以不必获取对应的值，一旦回调中这个propertyID出现就代表解析完成，接下来就可以对音频数据进行帧分离了。
    
    
    //计算时长 Duration
    //获取时长的最佳方法是从ID3信息中去读取，那样是最准确的。如果没有，依赖于头文件中的信息去计算了
    //double duration = (audioDataByteCount * 8) / bitRate
    //audioDataByteCount kAudioFileStreamProperty_AudioDataByteCount
    //bitRate kAudioFileStreamProperty_BitRate  或者通过解析数据后计算平均码率来得到
    
    
    //分离音频帧
    //读取格式信息完成之后继续调用AudioFileStreamParseBytes方法可以对帧进行分离，并同步的进入AudioFileStream_PacketsProc回调方法。
    //typedef void (*AudioFileStream_PacketsProc)(
    //                                            void *                            inClientData,
    //                                            UInt32                            inNumberBytes,
    //                                            UInt32                            inNumberPackets,
    //                                            const void *                    inInputData,
    //                                            AudioStreamPacketDescription    *inPacketDescriptions);
    //inClientData  上下文对象
    //inNumberBytes 本次处理的数据大小
    //inNumberPackets 本次共处理了多少帧
    //inInputData   本次处理的所有数据
    //inPacketDescriptions  AudioStreamPacketDescription数组，存储了每一帧数据是从第几个字节开始的，这一帧总共多少字节。
    //struct  AudioStreamPacketDescription
    //{
    //    SInt64  mStartOffset;
    //    UInt32  mVariableFramesInPacket;
    //    UInt32  mDataByteSize;
    //};
    //typedef struct AudioStreamPacketDescription AudioStreamPacketDescription;
    //inPacketDescriptions这个字段为空时需要按CBR的数据处理。但其实在解析CBR数据时inPacketDescriptions一般也会有返回，因为即使是CBR数据帧的大小也不是恒定不变的，例如CBR的MP3会在每一帧的数据后放1 byte的填充位，这个填充位也并非时时刻刻存在，所以帧的大小会有1 byte的浮动。（比如采样率44.1KHZ，码率160kbps的CBR MP3文件每一帧的大小在522字节和523字节浮动。所以不能因为有inPacketDescriptions没有返回NULL而判定音频数据就是VBR编码的）。
    
    //seek
    //拖动到第几个音频字节开始读取音频数据
    
    //关闭AudioFileStream
    //extern OSStatus AudioFileStreamClose(AudioFileStreamID inAudioFileStream);
}

- (void)p_audioFile {
    
    /*
     AudioFile
     这个类可以用来创建、初始化音频文件；读写音频数据；对音频文件进行优化；读取和写入音频格式信息等等
     */
    
    //打开
    /*!
     @function                AudioFileOpenURL
     @abstract                Open an existing audio file.
     
     @discussion                Open an existing audio file for reading or reading and writing.
     
     @param inFileRef        the CFURLRef of an existing audio file.  文件路径
     
     @param inPermissions    use the permission constants
     
     @param inFileTypeHint    For files which have no filename extension and whose type cannot be easily or
     uniquely determined from the data (ADTS,AC3), this hint can be used to indicate the file type.
     Otherwise you can pass zero for this. The hint is only used on OS versions 10.3.1 or greater.
     For OS versions prior to that, opening files of the above description will fail.
     
     @param outAudioFile        upon success, an AudioFileID that can be used for subsequent
     AudioFile calls.
     @result                    returns noErr if successful.
     */
    //extern OSStatus
    //AudioFileOpenURL (    CFURLRef                            inFileRef,
    //                  AudioFilePermissions                inPermissions,
    //                  AudioFileTypeID                        inFileTypeHint,
    //                  AudioFileID    __nullable * __nonnull    outAudioFile)                    __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);
//    typedef CF_ENUM(SInt8, AudioFilePermissions) {
//        kAudioFileReadPermission      = 0x01,
//        kAudioFileWritePermission     = 0x02,
//        kAudioFileReadWritePermission = 0x03
//    };
    //第一个参数  文件路径
    //第二个参数  文件的允许使用方式 是读是写还是读写，如果打开文件后允许使用方式以外的操作，就得到kAudioFilePermissionsError
    //第三个参数  文件类型提示   如果文件累次类型确定的话 应该传入
    //第四个参数  返回AudioFile实例对应的AudioFileId 这个id需要保存起来作为后续一些方法的参数使用
    //返回值状态
    
    //AudioFileOpenWithCallbacks
    
    /*!
     @function    AudioFileOpenWithCallbacks
     @abstract   Open an existing file. You provide callbacks that the AudioFile API
     will use to get the data.
     
     @param inClientData  a constant that will be passed to your callbacks. 上下文信息
     
     @param inReadFunc   a function that will be called when AudioFile needs to read data. 需要读音频数据时进行的回调
     
     @param inWriteFunc   a function that will be called when AudioFile needs to write data. 写音频数据时进行的回调
     
     @param inGetSizeFunc  a function that will be called when AudioFile needs to know the total file size.  需要用到文件的总大小是回调  调用open和read方式后同步回调
     
     @param inSetSizeFunc   a function that will be called when AudioFile needs to set the file size. 需要设置文件大小时回调
     
     @param inFileTypeHint    For files which have no filename extension and whose type cannot be easily or
     uniquely determined from the data (ADTS,AC3), this hint can be used to indicate the file type.
     Otherwise you can pass zero for this. The hint is only used on OS versions 10.3.1 or greater.
     For OS versions prior to that, opening files of the above description will fail.
     @param outAudioFile        upon success, an AudioFileID that can be used for subsequent
     AudioFile calls.
     @result                    returns noErr if successful.
     */
    //extern OSStatus
    //AudioFileOpenWithCallbacks (
    //                            void *                                inClientData,
    //                            AudioFile_ReadProc                    inReadFunc,
    //                            AudioFile_WriteProc __nullable        inWriteFunc,
    //                            AudioFile_GetSizeProc                inGetSizeFunc,
    //                            AudioFile_SetSizeProc __nullable    inSetSizeFunc,
    //                            AudioFileTypeID                        inFileTypeHint,
    //                            AudioFileID    __nullable * __nonnull    outAudioFile)                __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_2_0);
    
    //typedef SInt64 (*AudioFile_GetSizeProc)(
    //                                        void *         inClientData);
    //typedef OSStatus (*AudioFile_ReadProc)(
    //                                       void *        inClientData,
    //                                       SInt64        inPosition,
    //                                       UInt32        requestCount,
    //                                       void *        buffer,
    //                                       UInt32 *    actualCount);
    
    //AudioFile_GetSizeProc 这个回调很好理解，返回文件总长度即可，总长度的获取途径自然是文件系统或者HTTPResponse等等
    //AudioFile_ReadProc
    //第一个参数，上下文对象，不再赘述；
    //第二个参数，需要读取第几个字节开始的数据；
    //第三个参数，需要读取的数据长度；
    //第四个参数，返回参数，是一个数据指针并且其空间已经被分配，我们需要做的是把数据memcpy到buffer中；
    //第五个参数，实际提供的数据长度，即memcpy到buffer中的数据长度；
    //返回值，如果没有任何异常产生就返回noErr，如果有异常可以根据异常类型选择需要的error常量返回（一般用不到其他返回值，返回noErr就足够了）；
    
    //这里需要解释一下这个回调方法的工作方式。AudioFile需要数据时会调用回调方法，需要数据的时间点有两个：
    
   // Open方法调用时，由于AudioFile的Open方法调用过程中就会对音频格式信息进行解析，只有符合要求的音频格式才能被成功打开否则Open方法就会返回错误码（换句话说，Open方法一旦调用成功就相当于AudioStreamFile在Parse后返回ReadyToProducePackets一样，只要Open成功就可以开始读取音频数据，详见第三篇），所以在Open方法调用的过程中就需要提供一部分音频数据来进行解析；
    
   // Read相关方法调用时，这个不需要多说很好理解；
    
    //通过回调提供数据时需要注意inPosition和requestCount参数，这两个参数指明了本次回调需要提供的数据范围是从inPosition开始requestCount个字节的数据。这里又可以分为两种情况：
    
    //有充足的数据：那么我们需要把这个范围内的数据拷贝到buffer中，并且给actualCount赋值requestCount，最后返回noError；
    
    //数据不足：没有充足数据的话就只能把手头有的数据拷贝到buffer中，需要注意的是这部分被拷贝的数据必须是从inPosition开始的连续数据，拷贝完成后给actualCount赋值实际拷贝进buffer中的数据长度后返回noErr，这个过程可以用下面的代码来表示：
    //static OSStatus MyAudioFileReadCallBack(void *inClientData,
    //                                        SInt64 inPosition,
    //                                        UInt32 requestCount,
    //                                        void *buffer,
    //                                        UInt32 *actualCount)
    //{
    //    __unsafe_unretained MyContext *context = (__bridge MyContext *)inClientData;
        
    //    *actualCount = [context availableDataLengthAtOffset:inPosition maxLength:requestCount];
    //    if (*actualCount > 0)
    //    {
    //        NSData *data = [context dataAtOffset:inPosition length:*actualCount];
    //        memcpy(buffer, [data bytes], [data length]);
    //    }
    //
    //    return noErr;
    //}
    
    //2.1. Open方法调用时的回调数据不足：AudioFile的Open方法会根据文件格式类型分几步进行数据读取以解析确定是否是一个合法的文件格式，其中每一步的inPosition和requestCount都不一样，如果某一步不成功就会直接进行下一步，如果几部下来都失败了，那么Open方法就会失败。简单的说就是在调用Open之前首先需要保证音频文件的格式信息完整，这就意味着AudioFile并不能独立用于音频流的读取，在流播放时首先需要使用AudioStreamFile来得到ReadyToProducePackets标志位来保证信息完整；
    
    //2.2. Read方法调用时的回调数据不足：这种情况下inPosition和requestCount的数值与Read方法调用时传入的参数有关，数据不足对于Read方法本身没有影响，只要回调返回noErr，Read就成功，只是实际交给Read方法的调用方的数据会不足，那么就把这个问题的处理交给了Read的调用方；
    
    
    //读取音频数据
    /*!
     @function    AudioFileReadBytes
     @abstract   Read bytes of audio data from the audio file.
     
     @discussion                Returns kAudioFileEndOfFileError when read encounters end of file.
     @param inAudioFile        an AudioFileID.  文件id
     
     @param inUseCache         true if it is desired to cache the data upon read, else false 是否需要缓存
     
     @param inStartingByte    the byte offset of the audio data desired to be returned  从第几个byte开始读取数据
     
     @param ioNumBytes         on input, the number of bytes to read, on output, the number of
     bytes actually read. 这个参数在调用时作为输入参数表示需要读取读取多少数据，调用完成后作为输出参数表示实际读取了多少数据（即Read回调中的requestCount和actualCount）；
     
     @param outBuffer         outBuffer should be a void * to user allocated memory large enough for the requested bytes. buffer指针，需要事先分配好足够大的内存（ioNumBytes大，即Read回调中的buffer，所以Read回调中不需要再分配内存）；
     
     返回值表示是否读取成功，EOF时会返回kAudioFileEndOfFileError；
     
     @result                    returns noErr if successful.
     */
    //extern OSStatus
    //AudioFileReadBytes (    AudioFileID      inAudioFile,
    //                    Boolean            inUseCache,
    //                    SInt64            inStartingByte,
    //                    UInt32            *ioNumBytes,
    //                    void            *outBuffer)                            __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_2_0);
    
    //按packet读取音频数据
    /*!
     @function    AudioFileReadPacketData
     @abstract   Read packets of audio data from the audio file.
     @discussion AudioFileReadPacketData reads as many of the requested number of packets
     as will fit in the buffer size given by ioNumPackets.
     Unlike the deprecated AudioFileReadPackets, ioNumPackets must be initialized.
     If the byte size of the number packets requested is
     less than the buffer size, ioNumBytes will be reduced.
     If the buffer is too small for the number of packets
     requested, ioNumPackets and ioNumBytes will be reduced
     to the number of packets that can be accommodated and their byte size.
     Returns kAudioFileEndOfFileError when read encounters end of file.
     For all uncompressed formats, packets == frames.
     
     @param inAudioFile                an AudioFileID.
     @param inUseCache                 true if it is desired to cache the data upon read, else false
     @param ioNumBytes                on input the size of outBuffer in bytes.
     on output, the number of bytes actually returned.
     @param outPacketDescriptions     An array of packet descriptions describing the packets being returned.
     The size of the array must be greater or equal to the number of packets requested.
     On return the packet description will be filled out with the packet offsets and sizes.
     Packet descriptions are ignored for CBR data.
     @param inStartingPacket         The packet index of the first packet desired to be returned
     @param ioNumPackets             on input, the number of packets to read, on output, the number of
     packets actually read.
     @param outBuffer                 outBuffer should be a pointer to user allocated memory.
     @result                            returns noErr if successful.
     */
    extern OSStatus
    AudioFileReadPacketData (    AudioFileID                      inAudioFile,
                             Boolean                            inUseCache,
                             UInt32 *                        ioNumBytes,
                             AudioStreamPacketDescription * __nullable outPacketDescriptions,
                             SInt64                            inStartingPacket,
                             UInt32 *                         ioNumPackets,
                             void * __nullable                outBuffer)            __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_2_2);
    
    /*!
     @function    AudioFileReadPackets
     @abstract   Read packets of audio data from the audio file.
     @discussion AudioFileReadPackets is DEPRECATED. Use AudioFileReadPacketData instead.
     READ THE HEADER DOC FOR AudioFileReadPacketData. It is not a drop-in replacement.
     In particular, for AudioFileReadPacketData ioNumBytes must be initialized to the buffer size.
     AudioFileReadPackets assumes you have allocated your buffer to ioNumPackets times the maximum packet size.
     For many compressed formats this will only use a portion of the buffer since the ratio of the maximum
     packet size to the typical packet size can be large. Use AudioFileReadPacketData instead.
     
     @param inAudioFile                an AudioFileID.
     @param inUseCache                 true if it is desired to cache the data upon read, else false
     @param outNumBytes                on output, the number of bytes actually returned
     @param outPacketDescriptions     on output, an array of packet descriptions describing
     the packets being returned. NULL may be passed for this
     parameter. Nothing will be returned for linear pcm data.
     @param inStartingPacket         the packet index of the first packet desired to be returned
     @param ioNumPackets             on input, the number of packets to read, on output, the number of
     packets actually read.
     @param outBuffer                 outBuffer should be a pointer to user allocated memory of size:
     number of packets requested times file's maximum (or upper bound on)
     packet size.
     @result                            returns noErr if successful.
     */
    extern OSStatus
    AudioFileReadPackets (    AudioFileID                      inAudioFile,
                          Boolean                            inUseCache,
                          UInt32 *                        outNumBytes,
                          AudioStreamPacketDescription * __nullable outPacketDescriptions,
                          SInt64                            inStartingPacket,
                          UInt32 *                         ioNumPackets,
                          void * __nullable                outBuffer)            __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2,__MAC_10_10, __IPHONE_2_0,__IPHONE_8_0);
    
    //AudioFileReadPacketData is memory efficient when reading variable bit-rate (VBR) audio data;
    //AudioFileReadPacketData is more efficient than AudioFileReadPackets when reading compressed file formats that do not have packet tables, such as MP3 or ADTS. This function is a good choice for reading either CBR (constant bit-rate) or VBR data if you do not need to read a fixed duration of audio.
     //   Use AudioFileReadPackets only when you need to read a fixed duration of audio data, or when you are reading only uncompressed audio.
    
    //第一、二个参数，同AudioFileReadBytes；
    //第三个参数，对于AudioFileReadPacketData来说ioNumBytes这个参数在输入输出时都要用到，在输入时表示outBuffer的size，输出时表示实际读取了多少size的数据。而对AudioFileReadPackets来说outNumBytes只在输出时使用，表示实际读取了多少size的数据；
    //第四个参数，帧信息数组指针，在输入前需要分配内存，大小必须足够存在ioNumPackets个帧信息（ioNumPackets * sizeof(AudioStreamPacketDescription)）；
    //第五个参数，从第几帧开始读取数据；
    //第六个参数，在输入时表示需要读取多少个帧，在输出时表示实际读取了多少帧；
    //第七个参数，outBuffer数据指针，在输入前就需要分配好空间，这个参数看上去两个方法一样但其实并非如此。对于AudioFileReadPacketData来说只要分配近似帧大小 * 帧数的内存空间即可，方法本身会针对给定的内存空间大小来决定最后输出多少个帧，如果空间不够会适当减少出的帧数；而对于AudioFileReadPackets来说则需要分配最大帧大小(或帧大小上界) * 帧数的内存空间才行（最大帧大小和帧大小上界的区别等下会说）；这也就是为何第三个参数一个是输入输出双向使用的，而另一个只是输出时使用的原因。就这点来说两个方法中前者在使用的过程中要比后者更省内存；
    //返回值，同AudioFileReadBytes；
    //这两个方法读取后的数据为帧分离后的数据，可以直接用来播放或者解码。
    
    AudioFileID fileID; //Open方法返回的AudioFileID
    UInt32 ioNumPackets = 0; //要读取多少个packet
    SInt64 inStartingPacket = 0; //从第几个Packet开始读取
    
    UInt32 bitRate = 0; //AudioFileGetProperty读取kAudioFilePropertyBitRate
    UInt32 sampleRate = 0; //AudioFileGetProperty读取kAudioFilePropertyDataFormat或kAudioFilePropertyFormatList
    UInt32 byteCountPerPacket = 144 * bitRate / sampleRate; //MP3数据每个Packet的近似大小
    
    UInt32 descSize = sizeof(AudioStreamPacketDescription) * ioNumPackets;
    AudioStreamPacketDescription * outPacketDescriptions = (AudioStreamPacketDescription *)malloc(descSize);
    
    UInt32 ioNumBytes = byteCountPerPacket * ioNumPackets;
    void * outBuffer = (void *)malloc(ioNumBytes);
    
    OSStatus status = AudioFileReadPacketData(fileID,
                                              false,
                                              &ioNumBytes,
                                              outPacketDescriptions,
                                              inStartingPacket,
                                              &ioNumPackets,
                                              outBuffer);
    
    if (status == noErr) {
        
    }
    
    
//    AudioFileID fileID; //Open方法返回的AudioFileID
//    UInt32 ioNumPackets = ...; //要读取多少个packet
//    SInt64 inStartingPacket = ...; //从第几个Packet开始读取
//
//    UInt32 maxByteCountPerPacket = ...; //AudioFileGetProperty读取kAudioFilePropertyMaximumPacketSize，最大的packet大小
//    //也可以用：
//    //UInt32 byteCountUpperBoundPerPacket = ...; //AudioFileGetProperty读取kAudioFilePropertyPacketSizeUpperBound，当前packet大小上界（未扫描全文件的情况下）
//
//    UInt32 descSize = sizeof(AudioStreamPacketDescription) * ioNumPackets;
//    AudioStreamPacketDescription * outPacketDescriptions = (AudioStreamPacketDescription *)malloc(descSize);
//
//    UInt32 outNumBytes = 0;
//    UInt32 ioNumBytes = maxByteCountPerPacket * ioNumPackets;
//    void * outBuffer = (void *)malloc(ioNumBytes);
//
//    OSStatus status = AudioFileReadPackets(fileID,
//                                           false,
//                                           &outNumBytes,
//                                           outPacketDescriptions,
//                                           inStartingPacket,
//                                           &ioNumPackets,
//                                           outBuffer);
    
    
    //seek
    //使用AudioFileReadBytes时需要计算出approximateSeekOffset
    //使用AudioFileReadPacketData或者AudioFileReadPackets时需要计算出seekToPacket
    //approximateSeekOffset和seekToPacket的计算方法参见第三篇。
    
    //关闭AudioFile
    //AudioFile使用完毕后需要调用AudioFileClose进行关闭，没啥特别需要注意的。
    //extern OSStatus AudioFileClose (AudioFileID inAudioFile);
}

- (void)p_audioQueue {
    /*
     AudioQueue来实现app中的播放和录音功能。
     */
    
    /*
     工作模式
     在使用AudioQueue之前首先必须理解其工作模式，它之所以这么命名是因为在其内部有一套缓冲队列（Buffer Queue）的机制。在AudioQueue启动之后需要通过AudioQueueAllocateBuffer生成若干个AudioQueueBufferRef结构，这些Buffer将用来存储即将要播放的音频数据，并且这些Buffer是受生成他们的AudioQueue实例管理的，内存空间也已经被分配（按照Allocate方法的参数），当AudioQueue被Dispose时这些Buffer也会随之被销毁。
     
     当有音频数据需要被播放时首先需要被memcpy到AudioQueueBufferRef的mAudioData中（mAudioData所指向的内存已经被分配，之前AudioQueueAllocateBuffer所做的工作），并给mAudioDataByteSize字段赋值传入的数据大小。完成之后需要调用AudioQueueEnqueueBuffer把存有音频数据的Buffer插入到AudioQueue内置的Buffer队列中。在Buffer队列中有buffer存在的情况下调用AudioQueueStart，此时AudioQueue就回按照Enqueue顺序逐个使用Buffer队列中的buffer进行播放，每当一个Buffer使用完毕之后就会从Buffer队列中被移除并且在使用者指定的RunLoop上触发一个回调来告诉使用者，某个AudioQueueBufferRef对象已经使用完成，你可以继续重用这个对象来存储后面的音频数据。如此循环往复音频数据就会被逐个播放直到结束。
     
     创建AudioQueue，创建一个自己的buffer数组BufferArray;
     使用AudioQueueAllocateBuffer创建若干个AudioQueueBufferRef（一般2-3个即可），放入BufferArray；
     有数据时从BufferArray取出一个buffer，memcpy数据后用AudioQueueEnqueueBuffer方法把buffer插入AudioQueue中；
     AudioQueue中存在Buffer后，调用AudioQueueStart播放。（具体等到填入多少buffer后再播放可以自己控制，只要能保证播放不间断即可）；
     AudioQueue播放音乐后消耗了某个buffer，在另一个线程回调并送出该buffer，把buffer放回BufferArray供下一次使用；
     返回步骤3继续循环直到播放结束
     从以上步骤其实不难看出，AudioQueue播放的过程其实就是一个典型的生产者消费者问题。生产者是AudioFileStream或者AudioFile，它们生产处音频数据帧，放入到AudioQueue的buffer队列中，直到buffer填满后需要等待消费者消费；AudioQueue作为消费者，消费了buffer队列中的数据，并且在另一个线程回调通知数据已经被消费生产者可以继续生产。所以在实现AudioQueue播放音频的过程中必然会接触到一些多线程同步、信号量的使用、死锁的避免等等问题。
     
     了解了工作流程之后再回头来看AudioQueue的方法，其中大部分方法都非常好理解，部分需要稍加解释。
     */
    
    /*
     创建
     OSStatus AudioQueueNewOutput (const AudioStreamBasicDescription * inFormat,
     AudioQueueOutputCallback inCallbackProc,
     void * inUserData,
     CFRunLoopRef inCallbackRunLoop,
     CFStringRef inCallbackRunLoopMode,
     UInt32 inFlags,
     AudioQueueRef * outAQ);
     
     OSStatus AudioQueueNewOutputWithDispatchQueue(AudioQueueRef * outAQ,
     const AudioStreamBasicDescription * inFormat,
     UInt32 inFlags,
     dispatch_queue_t inCallbackDispatchQueue,
     AudioQueueOutputCallbackBlock inCallbackBlock);
     
     先来看第一个方法：
     
     第一个参数表示需要播放的音频数据格式类型，是一个AudioStreamBasicDescription对象，是使用AudioFileStream或者AudioFile解析出来的数据格式信息；
     
     第二个参数AudioQueueOutputCallback是某块Buffer被使用之后的回调；
     
     第三个参数为上下文对象；
     
     第四个参数inCallbackRunLoop为AudioQueueOutputCallback需要在的哪个RunLoop上被回调，如果传入NULL的话就会再AudioQueue的内部RunLoop中被回调，所以一般传NULL就可以了；
     
     第五个参数inCallbackRunLoopMode为RunLoop模式，如果传入NULL就相当于kCFRunLoopCommonModes，也传NULL就可以了；
     
     第六个参数inFlags是保留字段，目前没作用，传0；
     
     第七个参数，返回生成的AudioQueue实例；
     
     返回值用来判断是否成功创建（OSStatus == noErr）。
     
     第二个方法就是把RunLoop替换成了一个dispatch queue，其余参数同相同。
     

     */
    
    
    /*
     buffer的相关方法
     
     1.创建
     OSStatus AudioQueueAllocateBuffer(AudioQueueRef inAQ,
     UInt32 inBufferByteSize,
     AudioQueueBufferRef * outBuffer);
     
     OSStatus AudioQueueAllocateBufferWithPacketDescriptions(AudioQueueRef inAQ,
     UInt32 inBufferByteSize,
     UInt32 inNumberPacketDescriptions,
     AudioQueueBufferRef * outBuffer);
     
     第一个方法传入AudioQueue实例和Buffer大小，传出的Buffer实例；
     
     第二个方法可以指定生成的Buffer中PacketDescriptions的个数；
     
     2.销魂
     OSStatus AudioQueueFreeBuffer(AudioQueueRef inAQ,AudioQueueBufferRef inBuffer);
     注意这个方法一般只在需要销毁特定某个buffer时才会被用到（因为dispose方法会自动销毁所有buffer），并且这个方法只能在AudioQueue不在处理数据时才能使用。所以这个方法一般不太能用到。
     
     3.插入
     OSStatus AudioQueueEnqueueBuffer(AudioQueueRef inAQ,
     AudioQueueBufferRef inBuffer,
     UInt32 inNumPacketDescs,
     const AudioStreamPacketDescription * inPacketDescs);
     
     这个Enqueue方法需要传入AudioQueue实例和需要Enqueue的Buffer，对于有inNumPacketDescs和inPacketDescs则需要根据需要选择传入，文档上说这两个参数主要是在播放VBR数据时使用，但之前我们提到过即便是CBR数据AudioFileStream或者AudioFile也会给出PacketDescription所以不能如此一概而论。简单的来说就是有就传PacketDescription没有就给NULL，不必管是不是VBR。
     
     */
    
    /*
     播放控制
     
     1.开始播放
     OSStatus AudioQueueStart(AudioQueueRef inAQ,const AudioTimeStamp * inStartTime);
     
     2.解码数据
     OSStatus AudioQueuePrime(AudioQueueRef inAQ,
     UInt32 inNumberOfFramesToPrepare,
     UInt32 * outNumberOfFramesPrepared);
     
     3.暂停播放
     OSStatus AudioQueuePause(AudioQueueRef inAQ);
     需要注意的是这个方法一旦调用后播放就会立即暂停，这就意味着AudioQueueOutputCallback回调也会暂停，这时需要特别关注线程的调度以防止线程陷入无限等待。
     
     4.停止播放
     OSStatus AudioQueueStop(AudioQueueRef inAQ, Boolean inImmediate);
     第二个参数如果传入true的话会立即停止播放（同步），如果传入false的话AudioQueue会播放完已经Enqueue的所有buffer后再停止（异步）。使用时注意根据需要传入适合的参数。
     
     5.flush
     OSStatus AudioQueueFlush(AudioQueueRef inAQ);
     调用后会播放完Enqueu的所有buffer后重置解码器状态，以防止当前的解码器状态影响到下一段音频的解码（比如切换播放的歌曲时）。如果和AudioQueueStop(AQ,false)一起使用并不会起效，因为Stop方法的false参数也会做同样的事情。
     
     6.重置
     OSStatus AudioQueueReset(AudioQueueRef inAQ);
     重置AudioQueue会清除所有已经Enqueue的buffer，并触发AudioQueueOutputCallback,调用AudioQueueStop方法时同样会触发该方法。这个方法的直接调用一般在seek时使用，用来清除残留的buffer（seek时还有一种做法是先AudioQueueStop，等seek完成后重新start）。
     
     7.获取播放时间
     OSStatus AudioQueueGetCurrentTime(AudioQueueRef inAQ,
     AudioQueueTimelineRef inTimeline,
     AudioTimeStamp * outTimeStamp,
     Boolean * outTimelineDiscontinuity);
     传入的参数中，第一、第四个参数是和AudioQueueTimeline相关的我们这里并没有用到，传入NULL。调用后的返回AudioTimeStamp，从这个timestap结构可以得出播放时间，计算方法如下：
     AudioTimeStamp time = ...; //AudioQueueGetCurrentTime方法获取
     NSTimeInterval playedTime = time.mSampleTime / _format.mSampleRate;
     
     在使用这个时间获取方法时有两点必须注意：
     
     1、 第一个需要注意的时这个播放时间是指实际播放的时间和一般理解上的播放进度是有区别的。举个例子，开始播放8秒后用户操作slider把播放进度seek到了第20秒之后又播放了3秒钟，此时通常意义上播放时间应该是23秒，即播放进度；而用GetCurrentTime方法中获得的时间为11秒，即实际播放时间。所以每次seek时都必须保存seek的timingOffset：
     
     AudioTimeStamp time = ...; //AudioQueueGetCurrentTime方法获取
     NSTimeInterval playedTime = time.mSampleTime / _format.mSampleRate; //seek时的播放时间
     
     NSTimeInterval seekTime = ...; //需要seek到哪个时间
     NSTimeInterval timingOffset = seekTime - playedTime;
     seek后的播放进度需要根据timingOffset和playedTime计算：
     
     NSTimeInterval progress = timingOffset + playedTime;
     2、 第二个需要注意的是GetCurrentTime方法有时候会失败，所以上次获取的播放时间最好保存起来，如果遇到调用失败，就返回上次保存的结果。

     8.销魂AudioQueue
     AudioQueueDispose(AudioQueueRef inAQ,  Boolean inImmediate);
     销毁的同时会清除其中所有的buffer，第二个参数的意义和用法与AudioQueueStop方法相同。
     这个方法使用时需要注意当AudioQueueStart调用之后AudioQueue其实还没有真正开始，期间会有一个短暂的间隙。如果在AudioQueueStart调用后到AudioQueue真正开始运作前的这段时间内调用AudioQueueDispose方法的话会导致程序卡死。这个问题是我在使用AudioStreamer时发现的，起因是由于AudioStreamer会在音频EOF时就进入Cleanup环节，Cleanup环节会flush所有数据然后调用Dispose，那么当音频文件中数据非常少时就有可能出现AudioQueueStart调用之时就已经EOF进入Cleanup，此时就会出现上述问题。
     
     要规避这个问题第一种方法是做好线程的调度，保证Dispose方法调用一定是在每一个播放RunLoop之后（即至少是一个buffer被成功播放之后）。第二种方法是监听kAudioQueueProperty_IsRunning属性，这个属性在AudioQueue真正运作起来之后会变成1，停止后会变成0，所以需要保证Start方法调用后Dispose方法一定要在IsRunning为1时才能被调用。
     */
    
    /*
     属性和参数
     
     //参数相关方法
     AudioQueueGetParameter
     AudioQueueSetParameter
     
     //属性相关方法
     AudioQueueGetPropertySize
     AudioQueueGetProperty
     AudioQueueSetProperty
     
     //监听属性变化相关方法
     AudioQueueAddPropertyListener
     AudioQueueRemovePropertyListener
     
     //属性列表
     enum { // typedef UInt32 AudioQueuePropertyID
     kAudioQueueProperty_IsRunning               = 'aqrn',       // value is UInt32
     
     kAudioQueueDeviceProperty_SampleRate        = 'aqsr',       // value is Float64
     kAudioQueueDeviceProperty_NumberChannels    = 'aqdc',       // value is UInt32
     kAudioQueueProperty_CurrentDevice           = 'aqcd',       // value is CFStringRef
     
     kAudioQueueProperty_MagicCookie             = 'aqmc',       // value is void*
     kAudioQueueProperty_MaximumOutputPacketSize = 'xops',       // value is UInt32
     kAudioQueueProperty_StreamDescription       = 'aqft',       // value is AudioStreamBasicDescription
     
     kAudioQueueProperty_ChannelLayout           = 'aqcl',       // value is AudioChannelLayout
     kAudioQueueProperty_EnableLevelMetering     = 'aqme',       // value is UInt32
     kAudioQueueProperty_CurrentLevelMeter       = 'aqmv',       // value is array of AudioQueueLevelMeterState, 1 per channel
     kAudioQueueProperty_CurrentLevelMeterDB     = 'aqmd',       // value is array of AudioQueueLevelMeterState, 1 per channel
     
     kAudioQueueProperty_DecodeBufferSizeFrames  = 'dcbf',       // value is UInt32
     kAudioQueueProperty_ConverterError          = 'qcve',       // value is UInt32
     
     kAudioQueueProperty_EnableTimePitch         = 'q_tp',       // value is UInt32, 0/1
     kAudioQueueProperty_TimePitchAlgorithm      = 'qtpa',       // value is UInt32. See values below.
     kAudioQueueProperty_TimePitchBypass         = 'qtpb',       // value is UInt32, 1=bypassed
     };
     
     //参数列表
     enum    // typedef UInt32 AudioQueueParameterID;
     {
     kAudioQueueParam_Volume         = 1,
     kAudioQueueParam_PlayRate       = 2,
     kAudioQueueParam_Pitch          = 3,
     kAudioQueueParam_VolumeRampTime = 4,
     kAudioQueueParam_Pan            = 13
     };
     
     kAudioQueueProperty_IsRunning 监听它可以知道当前AudioQueue是否在运行，这个参数的作用在讲到AudioQueueDispose
     kAudioQueueProperty_MagicCookie 部分音频格式需要设置magicCookie，这个cookie可以从AudioFileStream和AudioFile中获取
     
     kAudioQueueParam_Volume  可以用来调节AudioQueue的播放音量，AudioQueue的内部播放音量和系统音量相互独立设置并且最后叠加生效。
     kAudioQueueParam_VolumeRampTime参数和Volume参数配合使用可以实现音频播放淡入淡出的效果；
     kAudioQueueParam_PlayRate参数可以调整播放速率；
     */
}

- (void)p_simplePlayer {
    /*
     访问 MediaLibrary
     MediaPicker MediaQuery
     */
    
    //MediaPicker
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    picker.prompt = @"请选择需要播放的歌曲";
    picker.showsCloudItems = NO;
    picker.allowsPickingMultipleItems = YES;
    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
    
    //通过MediaPicker最终可以得到MPMediaItemCollection，其中存放着所有在Picker中选中的歌曲，每一个歌曲使用一个MPMediaItem对象表示。对于MediaPicker的使用也可以参考官方文档。
    
    
    //MediaQuery
    // Base queries which can be used directly or as the basis for custom queries.
    // The groupingType for these queries is preset to the appropriate type for the query.
//    + (MPMediaQuery *)albumsQuery;
//    + (MPMediaQuery *)artistsQuery;
//    + (MPMediaQuery *)songsQuery;
//    + (MPMediaQuery *)playlistsQuery;
//    + (MPMediaQuery *)podcastsQuery;
//    + (MPMediaQuery *)audiobooksQuery;
//    + (MPMediaQuery *)compilationsQuery;
//    + (MPMediaQuery *)composersQuery;
//    + (MPMediaQuery *)genresQuery;
    
//    MPMediaPropertyPredicate *artistNamePredicate =
//    [MPMediaPropertyPredicate predicateWithValue:@"Happy the Clown"
//                                     forProperty:MPMediaItemPropertyArtist
//                                  comparisonType:MPMediaPredicateComparisonEqualTo];
//
//    MPMediaQuery *quert = [[MPMediaQuery alloc] init];
//    [quert addFilterPredicate: artistNamePredicate];
//    quert.groupingType = MPMediaGroupingArtist;
//
//    NSArray *itemsFromArtistQuery = [quert items];
//    NSArray *collectionsFromArtistQuery = [quert collections];
    
    //MediaCollection
    //MPMediaCollection是MediaItem的合集，可以通过访问它的items属性来访问所有的MediaItem。
    
    //MPMediaPlaylist是一个特殊的MPMediaCollection代表用户创建的播放列表，它会比MediaCollection包含更多的信息，比如播放列表的名字等等。这些属性可以通过MPMediaEntity的方法访问（MPMediaCollection是MPMediaEntity的子类，MPMediaItem也是）。

    // Returns the value for the given entity property.
    // MPMediaItem and MPMediaPlaylist have their own properties
    //- (id)valueForProperty:(NSString *)property;
    
    // Executes a provided block with the fetched values for the given item properties, or nil if no value is available for a property.
    // In some cases, enumerating the values for multiple properties can be more efficient than fetching each individual property with -valueForProperty:.
    //- (void)enumerateValuesForProperties:(NSSet *)properties usingBlock:(void (^)(NSString *property, id value, BOOL *s
    
    //MediaItem
    //通过MediaPicker和MediaQuery最终都会得到MPMediaItem，这个item中包含了许多信息。这些信息都可以通过MPMediaEntity的方法访问，其中参数非常多就不列举了具体可以参照MPMediaItem.h。
    
    //使用MPMusicPlayerController
    //拿到iPod Library中的歌曲后就可以开始播放了。播放的方式有很多种，先介绍一下MediaPlayer framework中的MPMusicPlayerController类。
    
    //通过MPMusicPlayerController的类方法可以生成两种播放器，生成方法如下：
    // Playing media items with the applicationMusicPlayer will restore the user's iPod state after the application quits.
    //+ (MPMusicPlayerController *)applicationMusicPlayer;
    // Playing media items with the iPodMusicPlayer will replace the user's current iPod state.
   // + (MPMusicPlayerController *)iPodMusicPlayer;
    
    //这两个方法看似生成了一样的对象，但它们的行为却有很大不同。从Apple写的注释上我们可以很清楚的发现它们的区别。+applicationMusicPlayer不会继承来自iOS系统自带的iPod应用中的播放状态，同时也不会覆盖iPod的播放状态。而+iPodMusicPlayer完全继承iPod应用的播放状态（甚至是播放时间），对其实例的任何操作也会覆盖到iPod应用。对+iPodMusicPlayer方法command+点击后可以看到更详细的注释。
      //说白了，当在使用iPodMusicPlayerv其实并不是你的程序在播放音频，而是你的程序在操纵iPod应用播放音频，即使你的程序crash了或者被kill了，音乐也不会因此停止。
                  
      //而对于+applicationMusicPlayer通过command+点击可以看到
      //从注释中可以知道这个方法返回的对象虽然不是调用iPod应用播放的也不会影响到iPod应用，但它有个很大的缺点：无法后台播放，即使你在active了audioSession并且在app的设置中设置了Background Audio同样不会奏效。
      //综上所述，一般在开发音乐软件时很少用到这两个接口来进行iPod Library的播放，大部分开发者都是用这个类中的volme来调整系统音量的（这个属性在SDK 7中也被deprecate掉了）。如果你想用到这个类进行播放的话，这里需要提个醒，给MPMusicPlayerController设置需要播放的音乐时要使用下面两个方法：

      // Call -play to begin playback after setting an item queue source. Setting a query will implicitly use MPMediaGroupingTitle.
      //- (void)setQueueWithQuery:(MPMediaQuery *)query;
      //- (void)setQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;

      // Returns the currently playing media item, or nil if none is playing.
      // Setting the nowPlayingItem to an item in the current queue will begin playback at that item.
    
      //@property(nonatomic, copy) MPMediaItem *nowPlayingItem;
      //光看名字很容易被nowPlayingItem这个属性迷惑，它的意思其实是说在设置了MediaQuery或者MediaCollection之后再设置这个nowPlayingItem可以让播放器从这个item开始播放，前提是这个item需要在MediaQuery或者MediaCollection的.items集合内。
                  
    //使用AVAudioPlayer和AVPlayer
    //AVAudioPlayer
    //- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError;
    
    //AVPlayer
    //+ (id)playerWithURL:(NSURL *)URL;
    //- (id)initWithURL:(NSURL *)URL;
    
    //其中的NSURL正是来自于MPMediaItem的MPMediaItemPropertyAssetURL属性。
    ///A URL pointing to the media item,
    //from which an AVAsset object (or other URL-based AV Foundation object) can be created, with any options as desired.
    //Value is an NSURL object.
    //MP_EXTERN NSString *const MPMediaItemPropertyAssetURL;
    
    //读取和导出数据
    //前面说到使用MPMediaItem的MPMediaItemPropertyAssetURL属性可以得到一个表示当前MediaItem的NSURL，有了这个NSURL我们使用AVFoundation中的类进行播放。播放只是最基本的需求，有了这个URL我们可以做更多更有趣的事情。
    
    //在AVFoundation中还有两个有趣的类：AVAssetReader和AVAssetExportSession。它们可以把iPod Library中的指定歌曲以指定的音频格式导出到内存中或者硬盘中，这个指定的格式包括PCM。这是一个激动人心的特性，有了PCM数据我们就可以做很多很多其他的事情了。
    
    
    //Apple提供两种方法来访问iPod Library，它们分别是MPMediaPickerController和MPMediaQuery；
    //MPMediaPickerController和MPMediaQuery最后输出给开发者的对象是MPMediaItem，MPMediaItem的属性需要通过-valueForProperty:方法获取了；
    //MPMusicPlayerController可以用来播放MPMediaItem，但有很多局限性，使用时需要根据不同的使用场景来决定用哪个类方法生成实例；
    //AVAudioPlayer和AVPlayer也可以用来播放MPMediaItem，这两个类的功能比较完善，推荐使用，在使用之前别忘记设置AudioSession；
    //MPMediaItem可以得到对应的URL，这个URL可以用来做很多事情，例如用AVAssetReader和AVAssetExportSession可以导出其中的数据；
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    //do something
}


- (void)p_NowPlayingCenter {
    
    /*
     NowPlayingCenter能够显示当前正在播放的歌曲信息，它可以控制的范围包括：
     
     锁频界面上所显示的歌曲播放信息和图片
     iOS7之后控制中心上显示的歌曲播放信息
     iOS7之前双击home键后出现的进程中向左滑动出现的歌曲播放信息
     AppleTV，AirPlay中显示的播放信息
     车载系统中显示的播放信息
     
     信息的显示都由MPNowPlayingInfoCenter类来控制，这个类的定义非常简单：
     
     MP_EXTERN_CLASS_AVAILABLE(5_0) @interface MPNowPlayingInfoCenter : NSObject
     
     // Returns the default now playing info center.
     // The default center holds now playing info about the current application.
     + (MPNowPlayingInfoCenter *)defaultCenter;
     
     // The current now playing info for the center.
     // Setting the info to nil will clear it.
     @property (copy) NSDictionary *nowPlayingInfo;
     
     @end
     
     #import <MediaPlayer/MPNowPlayingInfoCenter.h>
     MPMediaItemPropertyAlbumTitle              //NSString
     MPMediaItemPropertyAlbumTrackCount         //NSNumber of NSUInteger
     MPMediaItemPropertyAlbumTrackNumber        //NSNumber of NSUInteger
     MPMediaItemPropertyArtist                  //NSString
     MPMediaItemPropertyArtwork                 //MPMediaItemArtwork
     MPMediaItemPropertyComposer                //NSString
     MPMediaItemPropertyDiscCount               //NSNumber of NSUInteger
     MPMediaItemPropertyDiscNumber              //NSNumber of NSUInteger
     MPMediaItemPropertyGenre                   //NSString
     MPMediaItemPropertyPersistentID            //NSNumber of uint64_t
     MPMediaItemPropertyPlaybackDuration        //NSNumber of NSTimeInterval
     MPMediaItemPropertyTitle                   //NSString
     
     上面这些属性大多比较浅显易懂，基本上按照字面上的意思去理解就可以了，需要稍微解释以下的是MPMediaItemPropertyArtwork。这个属性表示的是锁屏界面或者AirPlay中显示的歌曲封面图，MPMediaItemArtwork类可以由UIImage类进行初始化。
     MP_EXTERN_CLASS_AVAILABLE(3_0) @interface MPMediaItemArtwork : NSObject
     
     // Initializes an MPMediaItemArtwork instance with the given full-size image.
     // The crop rect of the image is assumed to be equal to the bounds of the
     // image as defined by the image's size in points, i.e. tightly cropped.
     - (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER NS_AVAILABLE_IOS(5_0);
     
     // Returns the artwork image for an item at a given size (in points).
     - (UIImage *)imageWithSize:(CGSize)size;
     
     @property (nonatomic, readonly) CGRect bounds; // The bounds of the full size image (in points).
     @property (nonatomic, readonly) CGRect imageCropRect; // The actual content area of the artwork, in the bounds of the full size image (in points).
     
     @end
     
     另外一些附加属性被定义在<MediaPlayer/MPNowPlayingInfoCenter.h>中
     
     1
     2
     3
     4
     5
     6
     7
     8
     9
     10
     11
     12
     13
     14
     15
     16
     17
     18
     19
     20
     21
     22
     23
     24
     25
     26
     27
     28
     29
     30
     31
     32
     33
     // The elapsed time of the now playing item, in seconds.
     // Note the elapsed time will be automatically extrapolated from the previously
     // provided elapsed time and playback rate, so updating this property frequently
     // is not required (or recommended.)
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyElapsedPlaybackTime NS_AVAILABLE_IOS(5_0); // NSNumber (double)
     
     // The playback rate of the now playing item, with 1.0 representing normal
     // playback. For example, 2.0 would represent playback at twice the normal rate.
     // If not specified, assumed to be 1.0.
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyPlaybackRate NS_AVAILABLE_IOS(5_0); // NSNumber (double)
     
     // The "default" playback rate of the now playing item. You should set this
     // property if your app is playing a media item at a rate other than 1.0 in a
     // default playback state. e.g., if you are playing back content at a rate of
     // 2.0 and your playback state is not fast-forwarding, then the default
     // playback rate should also be 2.0. Conversely, if you are playing back content
     // at a normal rate (1.0) but the user is fast-forwarding your content at a rate
     // greater than 1.0, then the default playback rate should be set to 1.0.
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyDefaultPlaybackRate NS_AVAILABLE_IOS(8_0); // NSNumber (double)
     
     // The index of the now playing item in the application's playback queue.
     // Note that the queue uses zero-based indexing, so the index of the first item
     // would be 0 if the item should be displayed as "item 1 of 10".
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyPlaybackQueueIndex NS_AVAILABLE_IOS(5_0); // NSNumber (NSUInteger)
     
     // The total number of items in the application's playback queue.
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyPlaybackQueueCount NS_AVAILABLE_IOS(5_0); // NSNumber (NSUInteger)
     
     // The chapter currently being played. Note that this is zero-based.
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyChapterNumber NS_AVAILABLE_IOS(5_0); // NSNumber (NSUInteger)
     
     // The total number of chapters in the now playing item.
     MP_EXTERN NSString *const MPNowPlayingInfoPropertyChapterCount NS_AVAILABLE_IOS(5_0); // NSNumber (NSUInteger)
     
     其中常用的是MPNowPlayingInfoPropertyElapsedPlaybackTime和MPNowPlayingInfoPropertyPlaybackRate：
     
     MPNowPlayingInfoPropertyElapsedPlaybackTime表示已经播放的时间，用这个属性可以让NowPlayingCenter显示播放进度；
     MPNowPlayingInfoPropertyPlaybackRate表示播放速率。通常情况下播放速率为1.0，即真是时间的1秒对应播放时间中的1秒；
     这里需要解释的是，NowPlayingCenter中的进度刷新并不是由app不停的更新nowPlayingInfo来做的，而是根据app传入的ElapsedPlaybackTime和PlaybackRate进行自动刷新。例如传入ElapsedPlaybackTime=120s，PlaybackRate=1.0，那么NowPlayingCenter会显示2:00并且在接下来的时间中每一秒把进度加1秒并刷新显示。如果需要暂停进度，传入PlaybackRate=0.0即可。
     
     所以每次播放暂停和继续都需要更新NowPlayingCenter并正确设置ElapsedPlaybackTime和PlaybackRate否则NowPlayingCenter中的播放进度无法正常显示。
     
     */
    
    
    //NowPlayingCenter的刷新时机
    //频繁的刷新NowPlayingCenter并不可取，特别是在有Artwork的情况下。所以需要在合适的时候进行刷新。
    
    //依照我自己的经验下面几个情况下刷新NowPlayingCenter比较合适：
    
    //当前播放歌曲进度被拖动时
    //当前播放的歌曲变化时
    //播放暂停或者恢复时
    //当前播放歌曲的信息发生变化时（例如Artwork，duration等）
    //在刷新时可以适当的通过判断app是否active来决定是否必须刷新以减少刷新次数。
    
    //MPMediaItemPropertyArtwork
    //这是一个非常有用的属性，我们可以利用歌曲的封面图来合成一些图片借此达到美化锁屏界面或者显示锁屏歌词。
}

- (void)p_remoteControl {
    /*
     RemoteControl
     RemoteComtrol可以用来在不打开app的情况下控制app中的多媒体播放行为，涉及的内容主要包括：
     
     锁屏界面双击Home键后出现的播放操作区域
     iOS7之后控制中心的播放操作区域
     iOS7之前双击home键后出现的进程中向左滑动出现的播放操作区域
     AppleTV，AirPlay中显示的播放操作区域
     耳机线控
     车载系统的设置
     …
     */
    
    /*
     iOS 7.1之后如何处理RemoteControl
     
     iOS 7.1之后Apple提供了MPRemoteCommandCenter类来统一管理RemoteControl，并且在MPRemoteCommandCenter定义了比之前更多的RemoteControl操作，我们除了可以操作播放还可以进行一些其他的交互操作，比如收藏、评分等等。
     
     使用过程中我们只要为其中需要用到的command添加一个方法就可以实现RemoteControl。
    
     */
    //例如对于播放和暂停来说只要进行如下设置就可以了：
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]
//    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTarget:self action:@selector(play)];
//    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTarget:self action:@selector(pause)];
//    [[MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand addTarget:self action:@selector(playOrPause)];

    //结束后removeTarget并调用endReceivingRemoteControlEvents
    //如果是-addTargetWithHandler:添加的，需要把返回的target记下来后调用-removeTarget:移除
    //如果是-addTarget:action:添加的，使用-removeTarget:action:移除
}

- (void)p_playingWhenCaching {
    /*
     思路1. 最直接的方式，自行实现音频数据的请求在请求的过程中把数据缓存到磁盘，然后基于磁盘的数据自己实现解码、播放等功能；这个方法作为直接也最为复杂，开发者需要对音频播放的原理、操作系统等知识有一定程度的理解。如果能够实现这种方式所达到的效果也将会是最好的，整个过程都由开发者掌控，出现问题也可以对症下药。开源播放器FreeStreamer就是一个很好的例子，使用带有cache功能开源播放器或在其基础上进行二次开发也是不错的选择；
     
     思路2. 请求拦截的方式，首先你需要一个能够进行流播放的播放器（如Apple提供的AVPlayer），通过拦截播放器发送的请求可以知道需要下载哪一段数据，于是就可以根据本地缓存文件的情况分段为播放器提供数据，如遇到已缓存的数据段直接从缓存中获取数据塞回给播放器，如遇到未缓存的数据段就发送请求获取数据，得到response和数据后保存到磁盘同时塞回给播放器。这种思路下有三个分支：
     思路2.1 流播放器 + LocalServer，首先在搭建一个LocalServer（例如使用GCDWebServer），然后将URL组织成类似这种形式：
     把组织好的URL交给播放器播放，播放器把请求发送到LocalServer上，LocalServer解析到实际的音频地址后发送请求或者读取已缓存的数据。
     
     思路2.2 流播放器 + NSURLProtocol，大家都知道NSURLProtocol可以拦截Cocoa平台下URL Loading System中的请求，如果播放器的请求是运行在URL Loading System下的话使用这个方法可以轻松的拦截到播放器所发送的请求然后自己再进行请求或者读取缓存数据。这里需要注意如果使用AVPlayer作为播放器的话这种方法只在模拟器上才work，真机上并不能拦截到任何请求。这也证明AVPlayer在真机上并没有运行在URL Loading System下，但模拟器上却是（不知道在OSX下是否能work，有兴趣的同学可以尝试一下）。
     
     注：如果播放器使用的是CFNetwork，也可以尝试拦截，例如使用FB的fishhook，这hook方法应该会遇上不少坑，请做好心理准备。。
     
     思路2.3 AVPlayer + AVAssetResourceLoader，AVAssetResourceLoader是iOS 6之后添加的类其主要作用是让开发者能够掌控AVURLAsset加载数据的整个过程。这正好符合我们的需求，AVAssetResourceLoader会通过delegate把AVAssetResourceLoadingRequest对象传递给开发者，开发者可以根据其中的一些属性得知需要加载的数据段。在得到数据后也可以通过AVAssetResourceLoadingRequest向AVPlayer传递response和数据。
     
     思路3. 取巧的方式，自行实现音频数据的请求在请求的过程中把数据缓存到磁盘，然后使用系统提供的播放器（如AVAudioPlayer、AVPlayer进行播放）。这种实现方式中需要注意的是要播放的音频文件需要预先缓存一定量之后才能够播放，具体缓存多少完全频个人感觉，并且有可能会产生播放失败或者播放错误。这种方式的另一个缺点是无法进行任意的seek；
     */
    
    /*
     上面提到了3种思路共5个方案，那么在实际开发过程中开发者应该可以根据各个方案的优劣结合自己的实际情况选择最适合自己的方案。
     
     思路1：优点在于整个播放过程可控，出现问题可调试，但开发复杂度较高，故选择有对应功能的开源播放器是一个比较好途径。在使用开源播放器之前最好能阅读其代码，掌握整个播放流程，出了问题才能迅速定位。推荐以播放为核心功能的app使用此方案；
     
     思路2：优点在于开发者不必关心播放的整个过程，对音频播放的相关知识也不必有太多的了解，整个开发过程只要关心请求的解析、缓存数据的读取和保存以及数据的回填即可；至于缺点，首先你的有一个靠谱的流播放器，如果使用AVPlayer那么请做踩坑准备；
     
     思路2.1：各类流播放器通吃，如果方案2.2和2.3不管用2.1是最好的选择；
     
     思路2.2：需要播放器有指定的请求方式，如运行在URL Loading System下；
     
     思路2.3：如果你用的就是AVPlayer那么可以尝试使用这个思路，但对于播放列表形式(M3U8)的音频这种方式是无效的；
     
     思路3：如果你选择这条路，那说明你真的懒得不行。。。
     
     */
    
    //思路2缓存和数据读取细节
    //一般音频流或者视频流都会支持HTTP协议中的Range request header，所以大部分的播放器都会对Range header 进行支持 在数据源支持Range的情况下拦截到请求时有必要注意播放器所请求的数据段并根据当前数据缓存的状态进行分段处理。
    
    //举个例子，播放器请求bytes=0-100，其中10-20、50-60已经被缓存，那么这个请求就应该被分为下面几段来处理：
    
   // 0-10，网络请求
    //10-20，本地缓存
    //20-50，网络请求
    //50-60，本地缓存
    //60-100，网络请求
    //以上几段数据请求按顺序执行并进行数据回填，其中通过网络请求的数据在收到之后加入缓存以便下一次请求再次使用。另外要注意的是由于播放器本身只发送了一个请求所以response还是只有一个并且Content-Range还是应该为0-100/FileLength。
    
    //AVAssetResourceLoader
    
    //shceme必须自定义
    //非自定义的URL Scheme不会触发AVAssetResourceLoader的delegate方法。这一点并不难发现，Stackoverflow上和github上都有提到这一点。所以在构造AVPlayItem时必须使用自定义Scheme的URL才行，这里我是在原有的Scheme后加上了-streaming，在收到AVAssetResourceLoader的回调之后实际发送请求时再把-streaming后缀去掉。
    
    //AVURLAsset.resourceLoader的delegate必须在AVPlayerItem生成前赋值
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url] options:options];
//    [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
//    AVPlayerItem *item = [self playerItemWithAsset:asset];
    
    //下面这种写法是无法接到回调的：
    //AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url] options:options];
    //AVPlayerItem *item = [self playerItemWithAsset:asset];
    //[[(AVURLAsset *)item.asset resourceLoader] setDelegate:self queue:dispatch_get_main_queue()];
    
    //AVAssetResourceLoadingContentInformationRequest的contentLength和contentType
    //AVAssetResourceLoadingContentInformationRequest是AVAssetResourceLoadingRequest的一个属性
    /*!
     @property       contentInformationRequest
     @abstract       An instance of AVAssetResourceLoadingContentInformationRequest that you should populate with information about the resource. The value of this property will be nil if no such information is being requested.
     */
    //@property (nonatomic, readonly, nullable) AVAssetResourceLoadingContentInformationRequest *contentInformationRequest NS_AVAILABLE(10_9, 7_0);
    //其作用是告诉AVPlayer当前加载的资源类型、文件大小等信息。
    
    //AVAssetResourceLoadingContentInformationRequest有这样一个属性：
    /*!
     @property       contentLength
     @abstract       Indicates the length of the requested resource, in bytes.
     @discussion Before you finish loading an AVAssetResourceLoadingRequest, if its contentInformationRequest is not nil, you should set the value of this property to the number of bytes contained by the requested resource.
     */
    //@property (nonatomic) long long contentLength;
    
    //乍看上去可以把当前所请求数据的Content-Length直接赋给这个属性，例如请求range=0-100的那么其Content-Length就是100。如果当前数据无缓存的话，就直接把NSURLResponse的expectedContentLength属性值赋值给了contentLength。
    
    //但经过实践发现上面的做法并不正确。对于支持Range的请求，如range=0-100，NSURLResponse的expectedContentLength属性值为100，但这里需要填入的是文件的总长。所以对于response header中包含Content-Range的请求，需要解析出其中的文件总长再赋值给AVAssetResourceLoadingContentInformationRequest的contentLength属性。
    
    //接下来是contentType：
    /*!
     @property       contentType
     @abstract       A UTI that indicates the type of data contained by the requested resource.
     @discussion Before you finish loading an AVAssetResourceLoadingRequest, if its contentInformationRequest is not nil, you should set the value of this property to a UTI indicating the type of data contained by the requested resource.
     */
    //@property (nonatomic, copy, nullable) NSString *contentType;
    //这里的contentType是UTI，和NSURLResponse的MIMEType并不相同。需要进行转换：

    //NSString *mimeType = [response MIMEType];
    //CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    //loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
}


@end
