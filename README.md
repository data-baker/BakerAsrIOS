# XCode集成Framework（参考demo） 
##兼容性
iOS 8以上版本

## 将framework添加到项目project的目录下面
添加依赖库：`libc++.tbd`

### 引用SDK的头文件
`#import<DBASRFramework/DBASRClient.h>`// 识别器的头文件
### 实例化DBASRClient
实例化DBASRClient对象，包含设置clientId和clientSecret；（可以设置是否log日志，默认为NO);
注：如果是私有化部署此处不需要设置clientId和clientSecret，直接通过setupPrivateDeploymentURL方法设置私有化url即可。

### 语音识别控制
// 设置开始识别的回调对象并开始语音识别,
`-(int)startVoiceRecognition:(id<DBVoiceRecognizeDelgate>)delegate;`

// 结束语音识别
`- (void)stopVo``iceRecognition;`

### 在代理的回调中处理相关的逻辑，回传数据或处理异常

## 调用说明

1. 初始化DBASRClient类，得到DBASRClient的实例；
1. 设置clientId,和clIentSecret参数；
1. 设置clIent单例的回调对象，并遵守相关语音回调协议,实现相关的代理方法，开启语音识别；
1. 处理相关的识别结果，如果发生错误，可以在错误回调方法中查看错误信息；

## 参数说明

### `DBVoiceRecognizeDelgate` 回调类方法说明

| 方法名称| 参数说明| 使用说明|
|--------|--------|--------|
|-(void)onBeginOfSpeech|开始进行语音识别|语音识别开始，与云端识别服务建立连接|
|-(void)onVolumeChanged:(NSInteger)volume data:(NSData *)data | Volume: 当前说话音量 data:当前回调的录音数据 | 当开启识别后，会将识别的语音和音量通过该接口回调出来 |
|-(void)onResult:(NSArray *)nBest uncertain:(NSArray *)uncertain isLast:(BOOL)isLast |	nBest：识别结果，Uncertain：推测的识别结，果isLast:最后一句的标识 |	回调云端服务器返回的识别结果|
|-(void)onEndOfSpeech|识别完成 |语音识别完成，与云端识别服务断开|
|-(void)onError:(NSInteger)code message:(NSString *)message|Code:错误码,Message：错误信息| 返回识别过程中的错误信息 |
### 失败时返回的msg格式
| 参数名称 | 类型 |描述 |
|--------|--------|--------|
|     code   |   int     |错误码9xxxx表示SDK相关错误，3xxxx识别引擎相关错误，4xxxx授权及其他错误|
|message|string|错误描述|
|trace_id|string|引擎内部识别任务id|
### 错误码说明
| 错误码 | 含义 |备注 |
|--------|--------|--------|
|91000|识别SDK初始化失败|
|91001|	识别文本内容为空|	
|91002|	网络连接失败	|
|91003|	声音太短	|
|91004|	没有说话	|
|91005|	录音出现未知错误|	
|91006|	VAD初始化错误	|
|1001|	未获取录音权限	|
|1002	|录音过程被打断	|
|30001	|HTTP 请求参数错误	|
|30002	|服务内部错误	|
|30003	|识别结果解析出错	|
|30004	|应用包名未知	|
|30005	|语音质量问题	|
|30006	|输入语音过长	|
|30007	|连接识别引擎失败	|
|30008	|会话id不存在	|
|30009	|Rpc调用非法	|
|30010	|redis rpop操作返回空|	
|30011	|redis rpop值不合法	|
|30012	|rpc调用识别引擎失败|	
|30013	|Redis rpop操作失败	|
|30014	|redis lpush操作失败|
|30015	|单个语音分片过长	|
|30016	|回调url失败	|
|40001	|json解析失败|	将请求序列化为json结构|
|40002	|json字段不全	|检查对应的参数是否正确|
|40003	|版本错误	|
|40004	|json字段值类型错误|	
|40005	|参数错误	|
|40006	|idx超时	|相邻idx间隔超过设置超时值（默认60s）|
|40007	|idx顺序错误	|idx乱序|
|40008	|token校验失败	|偶现忽略，重复出现可反馈trace_id给开发|
|40009	|token处于未激活状态|	检查相应的client_id|
|40010	|token已过期	|重新获取token|
|40011	|使用量已超过购买量|	检查相应的client_id|
|40012	|qps错误	|增大qps|
|40008	|token校验失败	|偶现忽略，重复出现可反馈trace_id给开发|
|50001	|处理超时	   |偶现忽略，重复出现可反馈trace_id给开发|
|50002	|内部rpc调用失败| |
|50003	|服务端繁忙|	 |
|50004	|其他内部错误| |	



