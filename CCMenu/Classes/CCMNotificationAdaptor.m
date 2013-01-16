
#import "CCMNotificationAdaptor.h"
#import "CCMServerMonitor.h"


struct {
	NSString *key;
	NSString *name;
	NSString *description;
} notificationDescriptions[4];


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

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSMutableArray *names = [NSMutableArray array];
	for(int i = 0; notificationDescriptions[i].key != nil; i++)
		[names addObject:notificationDescriptions[i].name];
	return [NSDictionary dictionaryWithObject:names forKey:GROWL_NOTIFICATIONS_ALL];
}

- (void)start
{
    isUserNotificationAvailable = [NSUserNotificationCenter class] != nil;
    if (!isUserNotificationAvailable) {
        [GrowlApplicationBridge setGrowlDelegate:(id)self];
    }
	[[NSNotificationCenter defaultCenter]
		addObserver:self selector:@selector(buildComplete:) name:CCMBuildCompleteNotification object:nil];
}

- (void)sendUserNotification:(int)i aboutProject:(NSString*)projectName
{
    NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
    [notification setTitle:notificationDescriptions[i].name];
    [notification setSubtitle:projectName];
    [notification setInformativeText:notificationDescriptions[i].description];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)sendGrowlNotification:(int)i aboutProject:(NSString *)projectName
{
    [GrowlApplicationBridge 	
     notifyWithTitle:[NSString stringWithFormat:@"%@: %@", projectName, notificationDescriptions[i].name]
     description:notificationDescriptions[i].description
     notificationName:notificationDescriptions[i].name
     iconData:nil
     priority:0
     isSticky:NO
     clickContext:nil];
}

- (void)buildComplete:(NSNotification *)notification
{
	NSString *projectName = [[notification object] name];
	NSString *buildResult = [[notification userInfo] objectForKey:@"buildResult"];

	for(int i = 0; notificationDescriptions[i].key != nil; i++)
	{
		if([buildResult isEqualToString:notificationDescriptions[i].key])
		{
            /* TODO:
             * I don't like indexing into a struct; it doesn't seem very
             * good in terms of type-semantics.
             */
            if (isUserNotificationAvailable) {
                [self sendUserNotification:i aboutProject:projectName];
            } else {
                [self sendGrowlNotification:i aboutProject:projectName];
            }
			break;
		}
	}
}

@end
