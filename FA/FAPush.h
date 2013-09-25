/*
 
 */

#import "FAGlobal.h"
#import "FACloud.h"
#import "FAObservable.h"


//FA_VERSION_INTERFACE(FAPushVersion)

/**
 * 
 *
 */


/**
 * Protocol to be implemented by push notification clients. All methods are optional.
 */
@protocol FAPushNotificationDelegate<NSObject>

@optional

/**
 * Called when an alert notification is received.
 * @param alertMessage a simple string to be displayed as an alert
 */
- (void)displayNotificationAlert:(NSString *)alertMessage;

/**
 * Called when an alert notification is received with additional localization info.
 * @param alertDict a dictionary containing the alert and localization info
 */
- (void)displayLocalizedNotificationAlert:(NSDictionary *)alertDict;

/**
 * Called when a push notification is received with a sound associated
 * @param sound the sound to play
 */
- (void)playNotificationSound:(NSString *)sound;

/**
 * Called when a push notification is received with a custom payload
 * @param notification basic information about the notification
 * @param customPayload user-defined custom payload
 */
- (void)handleNotification:(NSDictionary *)notification withCustomPayload:(NSDictionary *)customPayload;

/**
 * Called when a push notification is received with a badge number
 * @param badgeNumber the badge number to display
 */
- (void)handleBadgeUpdate:(int)badgeNumber;

/**
 * Called when a push notification is received when the application is in the background
 * @param notification the push notification
 */
- (void)handleBackgroundNotification:(NSDictionary *)notification;
- (void)saveSystemMessage:(NSString *)message formatid:(int)fid keyValue:(NSString *)key ;
- (void)saveChatMessage:(NSString *)message freindId:(int)fid ;
- (void)saveGroupChatMessage:(NSString *)message gid:(int)gid freindId:(int)fid ;
- (void)saveGroupInvite:(NSString *)message gid:(int)gid groupname:(NSString *)name freindId:(int)fid ;
- (void)saveFreindInvite:(NSString *)message freindname:(NSString *)name freindId:(int)fid ;
- (void)addFreindToGroupId:(int)gid  freindname:(NSString *)name freindId:(int)fid ;
- (void)addFreindToListId:(int)fid  freindname:(NSString *)name ;
@end

@protocol FAPushNotificationObserver<NSObject>

@optional
- (void)saveSystemMessage:(NSDictionary *)aps;
- (void)saveChatMessage:(NSDictionary *)aps;
- (void)saveGroupChatMessage:(NSDictionary *)aps;
- (void)saveGroupInvite:(NSDictionary *)aps;
- (void)saveFreindInvite:(NSDictionary *)aps;
- (void)addFreindToGroup:(NSDictionary *)aps;
- (void)addGroupAndFriendToList:(NSDictionary *)aps;
- (void)addFreindToList:(NSDictionary *)aps;
@end
/**
 * 
 */
@interface FAPush : FAObservable {
    
@private
    id<FAPushNotificationDelegate> delegate; /* Push notification delegate. Handles incoming notifications */
    NSObject<FAPushNotificationDelegate> *defaultPushHandler; /* A default implementation of the push notification delegate */
    
    BOOL pushEnabled; /* Push enabled flag. */
    BOOL autobadgeEnabled;
    UIRemoteNotificationType notificationTypes; /* Requested notification types */
    NSString *alias; /* Device token alias. */
    NSDictionary *aps;
    //NSMutableArray *tags; /* Device token tags */
    //NSMutableDictionary *quietTime; /* Quiet time period. */
    //NSString *tz; /* Timezone, for quiet time */
}

@property (nonatomic, retain) id<FAPushNotificationDelegate> delegate;
@property (nonatomic, assign) BOOL pushEnabled;
@property (nonatomic, retain) NSString *alias;
//@property (nonatomic, retain) NSMutableArray *tags;
//@property (nonatomic, retain) NSMutableDictionary *quietTime;
//@property (nonatomic, retain) NSString *tz;
@property (nonatomic, retain,readwrite) NSDictionary *pushaps;
@property (nonatomic, readonly) UIRemoteNotificationType notificationTypes;

SINGLETON_INTERFACE(FAPush);


+ (void)land;

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;
/*- (void)registerDeviceToken:(NSData *)token;
- (void)updateRegistration;*/

// Change tags for current device token
//- (void)addTagToCurrentDevice:(NSString *)tag;
//- (void)removeTagFromCurrentDevice:(NSString *)tag;

// Update (replace) token attributes
- (void)updateAlias:(NSString *)value userId:(NSString *)userId;
//- (void)updateTags:(NSMutableArray *)value;



- (void)enableAutobadge:(BOOL)enabled;
- (void)setBadgeNumber:(NSInteger)badgeNumber;
- (void)resetBadge;

//Handle incoming push notifications
- (void)handleNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state;

-(void)showInviteMessage;

@end
