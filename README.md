# 小晖付SDK集成说明文档
## 业务说明
- 余额、小辉宝、小辉付、小辉贷、小辉钱包、小辉支付

## pod依赖  （目前防止包名冲突只能外部工程也使用pod管理，不能使用use_frameworks!，第三方库最新即可）
- AFNetworking
- SDWebImage
- Masonry
- MBProgressHUD
- WebViewJavascriptBridge

## 需要手动导入framworks
- [LFLivenessSDK.framework](http://devdoc.cloud.linkface.cn/iOS活体检测介绍.html)（在目录 ./SDK/LIb/LFMultipleLiveness ,把LFMultipleLiveness文件直接拖入工程，加入所需要的本地库，详情需要查看LFLivenessSDK.framework的集成文档）
-  [QMapKit.framework](https://lbs.qq.com/ios_v1/index.html)

## api接口 microPayManager.h

```
/**
 - SDKInitStatusSuccess  成功
 - SDKInitStatusFail     失败
 */
typedef NS_ENUM(NSInteger, SDKInitStatus) {
    SDKInitStatusSuccess = 1,
    SDKInitStatusFail
};
/**
 打开页面回调状态
 
 - SDKOpenPagePaySucess 支付成功
 - SDKOpenPagePaying 支付中
 - SDKOpenPagePayFail, 支付失败
 - SDKOpenPageClose html5关闭回调
 - SDKOpenPageCancel 取消收银台
 - SDKOpenPageStatusFail  启动失败
 
 */
typedef NS_ENUM(NSInteger, SDKOpenPageStatus) {
    SDKOpenPagePaySucess = 1,
    SDKOpenPagePaying ,
    SDKOpenPagePayFail,
    SDKOpenPageClose,//html关闭回调
    SDKOpenPageCancel,
    SDKOpenPageStatusFail,
};


/**
 SDK初始化状态
 
 @param status SDKInitStatus
 @param msgInfo 描述信息
 */
typedef void(^SDKInitResp)(SDKInitStatus status, NSDictionary *msgInfo);
/**
 SDK初始化状态
 
 @param status SDKOpenPageStatus
 @param msgInfo 描述信息
 */
typedef void(^OpenPageResp)(SDKOpenPageStatus status, NSDictionary *msgInfo);




@interface microPayManager : NSObject




/**
 * 关闭页面或支付回调
 */
@property (nonatomic, copy)OpenPageResp openPageBlock;

/**
 * 单利管理器
 */
+ (instancetype)shareMicroPayManager;

/**
 初始化SDK
 
 @param merchantId 商户ID
 @param appsecret  商户密钥
 @param respBlock  回调Block
 */
- (void)start:(NSString *)merchantId appsecret:(NSString *)appsecret  resBack:(SDKInitResp)respBlock;

/**
 开启页面
 
 @param dictInfo  入参
 @param respBlock 回调Block
 */
- (void)openAuthorizePage:(NSDictionary*)dictInfo resBack:(OpenPageResp)respBlock;


/// NOTE: 9.0以后使用新API接口 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
///NOTE: 9.0之前 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
///
/// @param url 上面两个方法返回
+(void)applicationOpenURL:(NSURL *)url;
//appScheme 传值
+(void)setPayAppScheme:(NSString*)appScheme;

-(void)openCheckStandWithPresentViewController:(UIViewController*)presentViewController withParam:(NSDictionary*)params;

@end
```
## 使用说明

### 初始化
```
 __weak __typeof(&*self)weakSelf = self;
     [[microPayManager shareMicroPayManager] start:self.merchantId appsecret:self.appsecret resBack:^(SDKInitStatus status, NSDictionary * _Nonnull msgInfo) {
         YHLog(@"SDK初始化结果 == %ld",status);
         if(status == SDKInitStatusSuccess){
             weakSelf.isInitSucess = YES;
             complete?complete(true):nil;
         }else {
             complete?complete(false):nil;
             MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
             hub.mode = MBProgressHUDModeText;
             hub.label.text = msgInfo[@"msg"];
             [hub hideAnimated:YES afterDelay:2];
         }
}];
//请求商户号和SDK初始化
-(void)initInfoComplete:(void (^)(BOOL successed))complete
{
    if (self.merchantId.length&&self.appsecret.length&&self.isInitSucess) {
        //已存在商户号和验签 初始化成功
        complete?complete(YES):nil;
        return;
    }else if(self.merchantId.length&&self.appsecret.length&&!self.isInitSucess){
        //已存在商户号和验签 初始化不成功
        [self starInitComplete:complete];
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    [self initInfoRequestBack:^(BOOL requestSuccess, NSString *loginToken, id  _Nullable response, NSString * _Nullable responseJson, NSDictionary * _Nullable requestDic, NSString * _Nullable errorMessage) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (requestSuccess) {
            NSDictionary*responseDic = (NSDictionary*)response;
            if ([responseDic[@"code"] intValue] == 200000&&responseDic[@"result"]&&[responseDic[@"result"] isKindOfClass:NSDictionary.class]) {
                NSDictionary*resultDic = responseDic[@"result"];
                strongSelf.merchantId = resultDic[@"merchantId"];
                strongSelf.appsecret = resultDic[@"appSecretIos"];
                [strongSelf starInitComplete:complete];
            }else{
                complete?complete(false):nil;
            }
        }else{
              complete?complete(false):nil;
              YHLog(@"商户号请求失败");
        }
    }];
}
//initInfo
-(void)initInfoRequestBack:(YHClientRequestBack)requestBack
{
    [self.dataRequest POST:Pay_initInfo inView:self.presentedVC.view parameters:@{} requestBack:requestBack];
}
```
###  打开余额、小辉宝、小辉付、小辉贷、小辉钱包

```
//打开页面

-(void)openRepPageNoType:(RepPageNoType)repPageNoType presentedVC:(UIViewController*)presentedVC resBack:(OpenPageResp)respBlock
{

    self.presentedVC = presentedVC;
    __weak __typeof(&*self)weakSelf = self;
    [self initInfoComplete:^(BOOL successed) {
        if (!successed) {
            return ;
        }
          __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        [strongSelf userCenterDataParams:@{@"reqPageNo":[self getPageNoString:repPageNoType]} requestBack:^(BOOL requestSuccess, NSString *loginToken, id  _Nullable response, NSString * _Nullable responseJson, NSDictionary * _Nullable requestDic, NSString * _Nullable errorMessage) {
            if (requestSuccess) {
                NSDictionary*responseDic = (NSDictionary*)response;
                if ([responseDic[@"code"] intValue] == 200000&&responseDic[@"result"]&&[responseDic[@"result"] isKindOfClass:NSDictionary.class])
                {
                  [strongSelf openAuthorizePage:[self changeDicWithDic:responseDic[@"result"]] resBack:respBlock];
                }
            }else{
                YHLog(@"加验参 错误 = %@",errorMessage);
            }
        }];
    }];
    
}
//个人中心接口  请求跳转参数
-(void)userCenterDataParams:(NSDictionary*)params requestBack:(YHClientRequestBack)requestBack
{
    [self.dataRequest POST:Pay_userCenter inView:self.presentedVC.view parameters:params requestBack:requestBack];
}
//key 转变

-(NSString*)getPageNoString:(RepPageNoType)repPageNoType
{
    switch (repPageNoType) {
        case RepPageNoType_Balance:
            return @"btnBalance";
        case RepPageNoType_XiaoHuibao:
            return @"btnXiaoHuibao";
            case RepPageNoType_XiaoHuiPay:
            return @"btnXiaoHuiPay";
            case RepPageNoType_btnXiaoHuiLoan:
            return @"btnXiaoHuiLoan";
            case RepPageNoType_XiaoHuiMoney:
            return @"btnXiaoHuiMoney";
            case RepPageNoType_PayTool:
            return @"btnPayTool";
            case RepPageNoType_MemberCode:
            return @"btnMemberCode";
            
        default:
            return @"";
    }
}
-(NSDictionary*)changeDicWithDic:(NSDictionary*)reqDic
{
    if (!reqDic) {
        return @{};
    }
    NSMutableDictionary*paramDic = [NSMutableDictionary new];
    paramDic[@"merchant_id"] = reqDic[@"merchantId"]?:@"";
    paramDic[@"mobile"] = reqDic[@"mobile"]?:@"";
    paramDic[@"user_id"] = reqDic[@"userId"]?:@"";
    paramDic[@"sign"] = reqDic[@"sign"]?:@"";
    paramDic[@"data"] = reqDic[@"data"]?:@"";
    paramDic[@"extend_json"] = @"";
    paramDic[@"state"] = reqDic[@"repPageNo"]?:@"";
    paramDic[@"storeName"] = reqDic[@"storeName"]?:@"";
    return paramDic;
}
```
### 发起支付

```
-(void)openPayWithOrderNo:(NSString*)orderNo presentedVC:(UIViewController*)presentedVC resBack:(OpenPageResp)respBlock
{

    self.presentedVC = presentedVC;
    __weak __typeof(&*self)weakSelf = self;
    [self initInfoComplete:^(BOOL successed) {
        if (!successed) {
             return ;
            }
          __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        [strongSelf checkStandDataParams:@{@"reqPageNo":[self getPageNoString:RepPageNoType_PayTool],@"orderNo":orderNo} requestBack:^(BOOL requestSuccess, NSString *loginToken, id  _Nullable response, NSString * _Nullable responseJson, NSDictionary * _Nullable requestDic, NSString * _Nullable errorMessage) {
            if (requestSuccess) {
                NSDictionary*responseDic = (NSDictionary*)response;
                if ([responseDic[@"code"] intValue] == 200000&&responseDic[@"result"]&&[responseDic[@"result"] isKindOfClass:NSDictionary.class])
                {
                  [strongSelf openAuthorizePage:[self changeDicWithDic:responseDic[@"result"]] resBack:respBlock];
                }
            }else{
                
            }
        }];
    }];
}
-(void)openAuthorizePage:(NSDictionary*)dataDic resBack:(OpenPageResp)respBlock
{
    [[microPayManager shareMicroPayManager] openAuthorizePage:dataDic resBack:respBlock];
}
//收银台接口
-(void)checkStandDataParams:(NSDictionary*)params requestBack:(YHClientRequestBack)requestBack
{
    [self.dataRequest PUT:Pay_checkStand inView:[UIApplication sharedApplication].keyWindow parameters:params requestBack:requestBack];
}
```
###  支付宝充值回调

- 添加 URL Types（在工程targets info下面）如：Identifier ：alipay1  URL SAchemes :ap2019122311221916

```
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [microPayManager setPayAppScheme:ap2019122311221916];
 }
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
 {
  [microPayManager applicationOpenURL:url];
  returen YES
 }
 ///NOTE: 9.0之前 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
  [microPayManager applicationOpenURL:url];
  returen YES
 }

```
