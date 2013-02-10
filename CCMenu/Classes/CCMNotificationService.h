
#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

#import "CCMUserDefaultsManager.h"
#import "CCMNotificationAdaptor.h"


typedef enum CCMNotificationServices : NSInteger CCMNotificationAdapterSelection;
enum CCMNotificationServices : NSInteger {
    None,
    NotificationCenter,
    Growl
};

@interface CCMNotificationService : NSObject 
{
    IBOutlet CCMUserDefaultsManager *defaultsManager;
}

@property (strong, nonatomic) CCMNotificationAdaptor *notificationAdaptor;

- (void)start;
- (void)setDefaultsManager:(CCMUserDefaultsManager *)manager;

@end