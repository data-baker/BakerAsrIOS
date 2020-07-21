//
//  DBPublicEumerte.h
//  DBASRFramework
//
//  Created by linxi on 2020/2/12.
//  Copyright © 2020 biaobei. All rights reserved.
//

#ifndef DBPublicEumerte_h
#define DBPublicEumerte_h

// 枚举 - 语音识别状态
typedef NS_ENUM (NSUInteger,DBVoiceRecognitionClientStatus){
    DBVoiceRecognitionClientStatusNone = 0,                  // 空闲
    DBVoiceRecognitionClientStatusStartWorking,           // 1 识别工作开始，开始采集及处理数据
    DBVoiceRecognitionClientStatusStart,                  // 2 检测到用户开始说话
    DBVoiceRecognitionClientStatusSentenceEnd,            // 3 输入模式下检测到语音说话完成
    DBVoiceRecognitionClientStatusEnd,                    // 4 本地声音采集结束结束，等待识别结果返回并结束录音
    DBVoiceRecognitionClientStatusNewRecordData,          // 5 录音数据回调
    DBVoiceRecognitionClientStatusReceiveData,            // 6 输入模式下有识别结果返回
    DBVoiceRecognitionClientStatusFinish,                 // 7 语音识别功能完成，服务器返回正确结果
    DBVoiceRecognitionClientStatusCancel,                 // 8 用户取消
    DBVoiceRecognitionClientStatusError,                  // 9 发生错误，详情见VoiceRecognitionClientErrorStatus接口通知
};

enum TVoiceRecognitionStartWorkResult
{
    EVoiceRecognitionStartWorking = 500,                    // 开始工作
};


typedef NS_ENUM (NSUInteger,DBNetwokingState) {
    DBNetwokingStateConnected=1000, // 已经建立网络连接
    DBNetwokingStateClosed, // 网络连接关闭
    DBNetwokingStateFailed, // 网络连接失败
    DBNetwokingStateUnknowed //网络连接状态未知
};


// 设置采样率
typedef NS_ENUM(NSUInteger, DBAudioSampleRate){
    DBAudioSampleRate16K=16000, // 16k的采样率
    DBAudioSampleRate8K=8000, // 8K的采样率
};


// 设置采样率
typedef NS_ENUM(NSUInteger, DBErrorState){
    // SDK本地错误
    DBErrorFailedCodeInitial=91000, // 初始化失败
    DBErrorNetworkUnusabel= 91001, // 本地网络不可用
    DBErrorNotConnectToServer=91002, // 网络连接失败
    DBErrorStateSpeechShort=91003, //声音太短
    DBErrorStateNoSpeech=91004, // 没有说话
    DBErrorStateSpeechUnKnown=91005, //录音出现未知错误
    DBErrorStateVADInit = 91006, // VAD初始化错误
    DBErrorStateRecordPermission = 1001,
    DBErrorStateRecordInterruption =1002,
    
    //服务端错误
    DBErrorStateHttpParameters = 30001, //HTTP 请求参数错误
    DBErrorStateService = 30002,// 服务内部错误
    DBErrorStateVoiceQuality = 30005, // 语音质量问题
    DBErrorStateVoiceTooLong = 30006, //输入语音过长
    DBErrorStateSessionId  = 30008, // 会话id不存在
    DBErrorStateRecognizeEngine = 3101, //连接识别引擎失败
    DBErrorStateRPC = 3103,// rpc调用非法
    DBErrorStateRedisRpopEmptyOperation = 3104, //Redis rpop操作返回空 3104
    DBErrorStateRedisRpopValue = 3105  ,//Redis rpop值不合法 3105
    DBErrorStateRPCRecognizeEngine = 3106,// rpc调用识别引擎失败 3106
    DBErrorStateRedisRpopOperation  = 3107, //Redis rpop操作失败
    DBErrorStateRedisIpushOperation = 3108, //  Redis ipush操作失败 3108
    DBErrorStateFragmentationTooLong  = 3109,  //单个语音分片过长 3109
    DBErrorStateCallBackUrl = 3110,// 回调url失败 3110
};

#endif /* DBPublicEumerte_h */
