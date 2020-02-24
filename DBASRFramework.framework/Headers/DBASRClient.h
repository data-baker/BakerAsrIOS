//
//  DBASRClient.h
//  DBASRFramework
//
//  Created by linxi on 2019/12/31.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBPublicEumerte.h"

NS_ASSUME_NONNULL_BEGIN

// @protocol - MVoiceRecognitionClientDelegate
// @brief - 语音识别工作状态通知
@protocol DBVoiceRecognizeDelgate<NSObject>
@optional
// MARK: 语音识别的接口

/// 返回音量大小
/// @param volume 音量大小
/// @param data 音频数据
- (void)onVolumeChanged:(NSInteger)volume data:(NSData *)data;

/// 识别 结果
/// @param nBest 识别到的最好的结果
/// @param uncertain 识别到的不确定的结果
/// @param isLast 是否是最后的识别结果
- (void)onResult:(NSArray<NSString *> *)nBest uncertain:(NSArray<NSString *> *)uncertain isLast:(BOOL)isLast;

/// 此回调表示，sdk内部录音机已经准备好了，用户可以开始语音输入
- (void)onBeginOfSpeech;

/// 此回调表示，检测到语音的尾断点，已经进入识别过程，不再接受语音输入
- (void)onEndOfSpeech;


/// 识别发生错误
/// @param code 错误码
/// @param message 错误信息，格式traceId + sid
- (void)onError:(NSInteger)code message:(NSString *)message;


@end


@interface DBASRClient : NSObject

///超时时间,默认30s
@property(nonatomic,assign)NSInteger  timeOut;

/// 1.打印日志 0:不打印日志
@property(nonatomic,assign,getter = isLog)BOOL log;
// --类方法
+ (DBASRClient *)sharedInstance;

// 初始化SDK的clientId，和clientSecret
- (void)setupClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;


// 私有化部署时不需要设置clientId和clientSecret,直接设置url即可
- (void)setupPrivateDeploymentURL:(NSString *)url;

/// 开始录音
- (int)startVoiceRecognition:(id<DBVoiceRecognizeDelgate>)delegate;

/// 结束录音
- (void)stopVoiceRecognition;

///TODO:  设置录音的采样率，默认为16k,目前仅支持16K
//- (void)setSampleRate:(DBAudioSampleRate)rate;

/// 获取设置的采样率
- (int)getCurrentSampleRate;

/*
 key:
 add_pct,1：添加表0：不带标点，默认不带标点；
 enable_itn,1:支持ITN，0：不支持ITN
 */
//- (void)setParamsKey:(NSString *)paramsKey paramsValue:(NSNumber *)paramsValue;



@end

NS_ASSUME_NONNULL_END
