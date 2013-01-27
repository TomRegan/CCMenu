
#import "CCMNotificationAdaptor.h"
#import "CCMServerMonitor.h"
#import "CCMPreferencesController.h"

const size_t NOTIFICATION_COUNT = 4;
struct {
	NSString *key;
	NSString *name;
	NSString *description;
} notificationDescriptions[NOTIFICATION_COUNT];

NSString *CCMNotificationServiceChanged = @"CCMNotificationServiceChanged";

@implementation CCMNotificationAdaptor

+ (void)initialize
{
	notificationDescriptions[0].key = CCMSuccessfulBuild;
	notificationDescriptions[0].name = NSLocalizedString(@"Build successful", "Growl notification for successful build");
	notificationDescriptions[0].description = NSLocalizedString(@"Yet another successful build!", "For Growl notificiation");

	notificationDescriptions[1].key = CCMStillFailingBuild;
	notificationDescriptions[1].name = NSLocalizedString(@"Build still failing", "Growl notification for successful build");
	notificationDescriptions[1].description = NSLocalizedString(@"The build is still broken.", "For Growl notificiation");
	
	notificationDescriptions[2].key = CCMBrokenBuild;
	notificationDescriptions[2].name = NSLocalizedString(@"Broken build", "Growl notification for successful build");
	notificationDescriptions[2].description = NSLocalizedString(@"Recent checkins have broken the build.", "For Growl notificiation");

	notificationDescriptions[3].key = CCMFixedBuild;
	notificationDescriptions[3].name = NSLocalizedString(@"Fixed build", "Growl notification for successful build");
	notificationDescriptions[3].description = NSLocalizedString(@"Recent checkins have fixed the build.", "For Growl notificiation");
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(buildComplete:)
         name:CCMBuildCompleteNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(notificationServiceChanged:)
         name:CCMNotificationServiceChanged object:nil];
    }
    return self;
}

- (void)setDefaultsManager:(CCMUserDefaultsManager *)manager
{
	defaultsManager = manager;
}

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSMutableArray *names = [NSMutableArray array];
	for(int i = 0; i < NOTIFICATION_COUNT; i++) {
		[names addObject:notificationDescriptions[i].name];
    }
	return [NSDictionary dictionaryWithObject:names forKey:GROWL_NOTIFICATIONS_ALL];
}

- (void)start
{
    selectedNotificationService = [defaultsManager notificationService];
    isUserNotificationAvailable = [NSUserNotificationCenter class] != nil;
    if (selectedNotificationService == Growl) {
        [GrowlApplicationBridge setGrowlDelegate:(id)self];
    }
}

- (BOOL)userNotificationCenter:(NSNotificationCenter*)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)sendUserNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description
{
    NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
    [notification setTitle:title];
    [notification setSubtitle:subject];
    [notification setInformativeText:description];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)sendGrowlNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description
{
    [GrowlApplicationBridge 	
     notifyWithTitle:[NSString stringWithFormat:@"%@: %@", subject, title]
     description:description
     notificationName:title
     iconData:nil
     priority:0
     isSticky:NO
     clickContext:nil];
}

- (void)buildComplete:(NSNotification *)notification
{
    if (selectedNotificationService == None) {
        return;
    }

    NSString *projectName = [[notification object] name];
    NSString *buildResult = [[notification userInfo] objectForKey:@"buildResult"];
	for(int i = 0; notificationDescriptions[i].key != nil; i++)
	{
		if([buildResult isEqualToString:notificationDescriptions[i].key])
		{
            if (isUserNotificationAvailable && selectedNotificationService == NotificationCenter) {
                [self sendUserNotification:notificationDescriptions[i].name
                      withSubject:projectName
                      andDescription:notificationDescriptions[i].description];
            } else  if (selectedNotificationService == Growl) {
                [self sendGrowlNotification:notificationDescriptions[i].name
                      withSubject:projectName
                      andDescription:notificationDescriptions[i].description];
            }
			break;
		}
	}
}

- (void)notificationServiceChanged:(NSNotification *)notification
{
    selectedNotificationService = [notification.object selectedNotificationService];
}

@end
