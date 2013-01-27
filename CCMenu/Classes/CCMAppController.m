
#import "CCMAppController.h"
#import "CCMNotificationAdaptor.h"
#import "CCMBuildNotificationFactory.h"
#import "CCMBuildStatusTransformer.h"
#import "CCMRelativeDateTransformer.h"
#import "CCMTimeIntervalTransformer.h"


@implementation CCMAppController

- (void)setupRequestCache
{
	NSURLCache *cache = [NSURLCache sharedURLCache];
	[cache setDiskCapacity:0];
	[cache setMemoryCapacity:5*1024*1024];
}

- (void)registerValueTransformers
{
	CCMBuildStatusTransformer *statusTransformer = [[[CCMBuildStatusTransformer alloc] init] autorelease];
	[statusTransformer setImageFactory:imageFactory];
	[NSValueTransformer setValueTransformer:statusTransformer forName:CCMBuildStatusTransformerName];
	
	CCMRelativeDateTransformer *relativeDateTransformer = [[[CCMRelativeDateTransformer alloc] init] autorelease];
	[NSValueTransformer setValueTransformer:relativeDateTransformer forName:CCMRelativeDateTransformerName];

	CCMTimeIntervalTransformer *timeIntervalTransformer = [[[CCMTimeIntervalTransformer alloc] init] autorelease];
	[NSValueTransformer setValueTransformer:timeIntervalTransformer forName:CCMTimeIntervalTransformerName];
}

- (void)startServices
{
    [CCMBuildTimer start];
    [CCMSoundPlayer start];
	[notificationAdapter start];

	[serverMonitor setNotificationCenter:[NSNotificationCenter defaultCenter]];
	[serverMonitor setNotificationFactory:[[[CCMBuildNotificationFactory alloc] init] autorelease]];
	[serverMonitor start];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	@try
	{
		[self setupRequestCache];
		[self registerValueTransformers];
        [self startServices];
		if([[serverMonitor projects] count] == 0) {
			[preferencesController showWindow:self];
        }
	}
	@catch(NSException *exception)
	{
		NSLog(@"Exception: %@\nReason: %@\nStack: %@",
              [exception name], [exception reason], [exception callStackSymbols]);
	}
}

@end
