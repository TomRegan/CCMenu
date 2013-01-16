
#import <Cocoa/Cocoa.h>
#import "CCMPreferencesController.h"
#import "CCMServerMonitor.h"
#import "CCMNotificationAdaptor.h"
#import "CCMImageFactory.h"
#import "CCMBuildTimer.h"
#import "CCMSoundPlayer.h"


@interface CCMAppController : NSObject
{
	IBOutlet CCMPreferencesController	*preferencesController;
	IBOutlet CCMImageFactory			*imageFactory;
	IBOutlet CCMServerMonitor			*serverMonitor;
	IBOutlet CCMNotificationAdaptor		*notificationAdapter;
}

@end
