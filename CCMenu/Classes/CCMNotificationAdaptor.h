
#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface CCMNotificationAdaptor : NSObject 
{
    BOOL isUserNotificationAvailable;
    BOOL isNotificationEnabled;
}

- (void)start;

@end
