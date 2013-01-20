
#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "CCMUserDefaultsManager.h"


typedef enum CCMNotificationServices : NSInteger CCMNotificationAdapterSelection;
enum CCMNotificationServices : NSInteger {
    None,
    NotificationCenter,
    Growl
};

@interface CCMNotificationAdaptor : NSObject 
{
    IBOutlet CCMUserDefaultsManager *defaultsManager;
    
    BOOL isUserNotificationAvailable;
    
    enum CCMNotificationServices  selectedNotificationService;
}

- (void)start;
- (void)setDefaultsManager:(CCMUserDefaultsManager *)manager;

@end

extern NSString *CCMNotificationServiceChanged;
