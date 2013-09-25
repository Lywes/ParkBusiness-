/*
*/

#import "FAGlobal.h"
#import "FAObservable.h"
#import "FAServerURL.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "APXML.h"


FA_VERSION_INTERFACE(FACloudVersion)

/**
 * The takeOff options key for setting custom CloudConfig options. The value
 * must be an NSDictionary.
 */
extern NSString * const FACloudTakeOffOptionsCloudConfigKey;

/**
 * The takeOff options key for passing in the options dictionary provided
 * by [UIApplication application:didFinishLaunchingWithOptions]. This key/value
 * pair should always be included in the takeOff options.
 */
extern NSString * const FACloudTakeOffOptionsLaunchOptionsKey;

/**
 * The takeOff options key for setting custom analytics options. The value must be
 * an NSDictionary with keys for UAAnalytics. This value is typically not used.
 */
//extern NSString * const FACloudTakeOffOptionsAnalyticsKey;

/**
 * The takeOff options key for setting a pre-exising UAUAser username. The value must be
 * an NSString.
 */
extern NSString * const FACloudTakeOffOptionsDefaultUsernameKey;

/**
 * The takeOff options key for setting a pre-exising UAUser password. The value must be
 * an NSString.
 */
extern NSString * const FACloudTakeOffOptionsDefaultPasswordKey;

@protocol FARegistrationObserver
@optional
- (void)registerDeviceTokenSucceededAndSaveUserId:(NSString*)userId;
- (void)registerDeviceTokenFailedAndShowFailureReason:(NSString*)reason;
/*- (void)unRegisterDeviceTokenSucceeded;
- (void)unRegisterDeviceTokenFailed:(ASIHTTPRequest *)request;
- (void)addTagToDeviceSucceeded;
- (void)addTagToDeviceFailed:(ASIHTTPRequest *)request;
- (void)removeTagFromDeviceSucceeded;
- (void)removeTagFromDeviceFailed:(ASIHTTPRequest *)request;*/
@end

@interface FACloud : FAObservable<UIAlertViewDelegate,UIApplicationDelegate>{

    
@private
    NSString *server;
    NSString *appId;
    NSString *appSecret;
    UIAlertView *wifiAlert;
    NSString *deviceToken_;
    BOOL deviceTokenHasChanged;
    BOOL ready;
    FAServerURL *serverUrl;
    NSString *userId;
    
}

/**
 * The current APNS/remote notification device token.
 */
@property (nonatomic, retain,readwrite) NSString *deviceToken;

@property (nonatomic, copy) NSString *userId;
/**
 * The FACloud API server. Defaults to https://go.5asys.com.
 */
@property (nonatomic, copy) NSString *server;

/**
 * The current FACloud app key. This value is loaded from the CloudConfig.plist file or
 * an NSDictionary passed in to [FACloud takeOff:] with the
 * FATakeOffOptionsCloudConfigKey. If APP_STORE_OR_AD_HOC_BUILD is set to YES, the value set
 * in PRODUCTION_APP_KEY will be used. If APP_STORE_OR_AD_HOC_BUILD is set to NO, the value set in
 * DEVELOPMENT_APP_KEY will be used.
 */
@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *parkno;
/**
 * The current FACloud app key. This value is loaded from the CloudConfig.plist file or
 * an NSDictionary passed in to [FACloud takeOff:] with the
 * FATakeOffOptionsCloudConfigKey. If APP_STORE_OR_AD_HOC_BUILD is set to YES, the value set
 * in PRODUCTION_APP_KEY will be used. If APP_STORE_OR_AD_HOC_BUILD is set to NO, the value set in
 * DEVELOPMENT_APP_KEY will be used.
 */
@property (nonatomic, copy) NSString *appSecret;

/**
 * This flag is set to YES if the device token has been updated. It is intended for use by
 * FAUser and should not be used by implementing applications. To receive updates when the
 * device token changes, applications should implement a FARegistrationObserver.
 */
@property (nonatomic, assign) BOOL deviceTokenHasChanged;

/**
 * This flag is set to YES if the shared instance of
 * FACloud has been initialized and is ready for use.
 */
@property (nonatomic, assign) BOOL ready;

@property (nonatomic, retain,readonly) FAServerURL *serverUrl;
/**
 * Initializes FACloud and performs all necessary setup. This creates the shared instance, loads
 * configuration values, initializes the analytics/reporting
 * module and creates a UAUser if one does not already exist.
 * 
 * This method must be called from your application delegate's
 * application:didFinishLaunchingWithOptions: method, and it may be called
 * only once. The options passed in on launch must be included in this method's options
 * parameter with the FACloudTakeOffOptionsLaunchOptionsKey.
 *
 * Configuration are read from the CloudConfig.plist file. You may overrride the
 * CloudConfig.plist values at runtime by including an NSDictionary containing the override
 * values with the FACloudTakeOffOptionsCloudConfigKey.
 *
 * @see FACloudTakeOffOptionsCloudConfigKey
 * @see FACloudTakeOffOptionsLaunchOptionsKey
 * 
 * @see FACloudTakeOffOptionsDefaultUsernameKey
 * @see FACloudTakeOffOptionsDefaultPasswordKey
 *
 * @param options An NSDictionary containing FACloudTakeOffOptions[...] keys and values. This
 * dictionary must contain the launch options.
 *
 */
+ (void)takeOff:(NSDictionary *)options;

/**
 * Perform teardown on the shared instance. This should be called when an application
 * terminates.
 */
+ (void)land;

SINGLETON_INTERFACE(FACloud);

/**
 * Register a device token with UA. This will register a device token without an alias or tags.
 * If an alias is set on the device token, it will be removed. Tags will not be changed.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 */
- (void)registerDeviceToken:(NSData *)token;

/**
 * Register the current device token with UA.
 *
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 */
- (void)registerDeviceTokenWithExtraInfo:(NSDictionary *)info;

/**
 * Register a device token and alias with UA.  An alias should only have a small
 * number (< 10) of device tokens associated with it. Use the tags API for arbitrary
 * groupings.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param alias The alias to register for this device token.
 */
- (void)registerDeviceToken:(NSData *)token withAlias:(NSString *)alias;

/**
 * Register a device token with a custom API payload.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 */
- (void)registerDeviceToken:(NSData *)token withExtraInfo:(NSDictionary *)info;

/**
 * Remove this device token's registration from the server.
 * This call is equivalent to an API DELETE call, as described here:
 * http://urbanairship.com/docs/push.html#registration
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 */
- (void)unRegisterDeviceToken;

-(void)validateAppKey;
-(void)showValidateAlert:(NSString *)xmlStr;
@end
