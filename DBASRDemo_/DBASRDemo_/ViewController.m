//
//  ViewController.m
//  DBASRDemo
//
//  Created by linxi on 2019/12/25.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import "ViewController.h"
#import <DBASRFramework/DBASRClient.h>
#import <AVFoundation/AVFoundation.h>
#import "PCMDataPlayer.h"

@interface ViewController ()<DBVoiceRecognizeDelgate>
@property(nonatomic,strong)DBASRClient * client;
@property(nonatomic,strong)PCMDataPlayer * pcmPlayer;
@property(nonatomic,strong)NSMutableData * recordData;
@property(nonatomic,assign)NSInteger pcmIndex;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [DBASRClient sharedInstance];
    self.client.timeOut = 15;
    
     #error 请设置授权信息，按照以下TODO操作（设置完成后删除本行注释即可运行）
    //TODO: 授权信息，@1和@2 只能选择一个；
    //@1 公有云设置，请联系标贝（北京）科技有限公司获取ClientId和ClientSecret;
    
    [self.client setupClientId:@"" clientSecret:@"" failureHandler:^(DBFailureModel * _Nullable error) {
           [self appendLogMessage:[NSString stringWithFormat:@"error:%@",error.message]];
       }];
    
        //@2 私有化部署,请联系标贝（北京）科技有限公司获取私有化URL
    //    [self.client setupPrivateDeploymentURL:@""];
    self.pcmIndex = 0;
    self.recordData = [NSMutableData data];
    self.pcmPlayer = [[PCMDataPlayer alloc]init];
    [self addBorderOfView:self.resultTextView];
    [self addBorderOfView:self.statusTextView];
}


- (IBAction)recordAction:(id)sender {
    [self startRecognize];
}
- (IBAction)endRecord:(id)sender {
    [self.client stopVoiceRecognition];
    self.statusTextView.text = @"";
    self.resultTextView.text = @"";
}
- (IBAction)playAction:(id)sender {
    if (!self.recordData) {
        return ;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    [_pcmPlayer play:self.recordData];
}


//MARK: DBVoiceRecognizeDelgate

- (void)onBeginOfSpeech {
    [self appendLogMessage:@"开始语音识别"];
}


- (void)onResult:(NSArray<NSString *> *)nBest uncertain:(NSArray<NSString *> *)uncertain isLast:(BOOL)isLast {
  if (uncertain.count > 1) {
        [self showRecognizeMessag:[NSString stringWithFormat:@"nBestFisrt:%@ uncertainFirst:%@ end:%@",nBest[0],uncertain[0],@(isLast)]];
    }else {
        [self showRecognizeMessag:[NSString stringWithFormat:@"%@",nBest[0]]];

    }
    
}
- (void)onVolumeChanged:(NSInteger)volume data:(NSData *)data {
    [self.recordData appendData:data];
    [self writeDataToCacheFileWithData:data fileName:@(self.pcmIndex).stringValue];
    self.pcmIndex++;
    static NSInteger count = 0;
    count++;
    if (count == 10) {
        [self appendLogMessage:[NSString stringWithFormat:@"音量:%@",@(volume)]];
        count=0;
    }
}
- (void)onEndOfSpeech {
    [self appendLogMessage:@"结束语音识别"];
}

- (void)onError:(NSInteger)code message:(NSString *)message {
    [self appendLogMessage:[NSString stringWithFormat:@"code:%@,message:%@",@(code),message]];

}

// MARK: Private Methods

- (void)writeDataToCacheFileWithData:(id)data fileName:(NSString *)fileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachePaths = [NSString stringWithFormat:@"%@/data%@.pcm",path,fileName];
    [data writeToFile:cachePaths atomically:YES];
}

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}

-  (void)startRecognize {
    [self.recordData resetBytesInRange:NSMakeRange(0, self.recordData.length)];
    [self.recordData setLength:0];
    self.pcmIndex= 0;
    self.statusTextView.text = @"";
    self.resultTextView.text = @"";
    //    [self.client setParamsKey:@"add_pct" paramsValue:@1];
    
    NSInteger ret = [self.client startVoiceRecognition:self];
    
    if (ret != 500) {
        NSLog(@"初始化识别失败 错误码%@",@(ret));
        NSString *errorMsg = [self paraseErrorMessageByCode:ret];
        NSString *msg= [NSString stringWithFormat:@"%@ 错误码%@",errorMsg,@(ret)];
        [self appendLogMessage:msg];
    }else {
        [self appendLogMessage:@"初始化识别环境成功"];
    }
}

- (NSString *)paraseErrorMessageByCode:(NSInteger)code {
    NSDictionary *parameters = @{
    @(DBErrorNetworkUnusabel):@"本地网络不可用",
    @(DBErrorStateRecordPermission):@"没有录音权限",
};
    return parameters[@(code)];
   }

- (void)appendLogMessage:(NSString *)message {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakself) strongSelf = weakself;
        NSString *text = self.statusTextView.text;
        NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@:%@",[strongSelf currentFormatTime],message]];
        strongSelf.statusTextView.text = appendText;
        [strongSelf.statusTextView scrollRangeToVisible:NSMakeRange(strongSelf.statusTextView.text.length, 1)];
    });
}

- (void)showRecognizeMessag:(NSString *)message {
   __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakself) strongSelf = weakself;
        strongSelf.resultTextView.text = message;
        [strongSelf.resultTextView scrollRangeToVisible:NSMakeRange(strongSelf.resultTextView.text.length, 1)];
    });
}

- (NSString *)currentFormatTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc]init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    NSString *dataString = [dateFormatter stringFromDate:date];
    return dataString;
}

@end
