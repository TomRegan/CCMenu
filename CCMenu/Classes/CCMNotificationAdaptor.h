
#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "CCMUserDefaultsManager.h"


typedef enum CCMNotificationAdapterSelection : NSInteger CCMNotificationAdapterSelection;
enum CCMNotificationAdapterSelection : NSInteger {
    None,
    NotificationCenter,
    Growl
};

@interface CCMNotificationAdaptor : NSObject 
{
    IBOutlet CCMUserDefaultsManager *defaultsManager;
    
    BOOL isUserNotificationAvailable;
    BOOL isNotificationEnabled;
    
    enum CCMNotificationAdapterSelection  selectedNotificationAdapter;
}

- (void)start;
- (void)setDefaultsManager:(CCMUserDefaultsManager *)manager;

@end

extern NSString *CCMNotificationAdapterChanged;
