
#import "CCMNotificationAdaptorTest.h"

@interface CCMNotificationService()
    -(void)sendUserNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description;
    -(void)buildComplete:(NSNotification *)notification;
@end


@implementation CCMNotificationServiceTest

-(void) setUp
{
    notificationServiceMock = [OCMockObject partialMockForObject:[[[CCMNotificationService alloc] init] autorelease]];
    notificationAdaptorMock = [OCMockObject partialMockForObject:[[[CCMNotificationAdaptor alloc] init] autorelease]];
    [notificationServiceMock setNotificationAdapter:notificationAdaptorMock];
}

-(void) tearDown
{
    [notificationServiceMock verify];
    [notificationAdaptorMock verify];
}

-(NSNotification *)notificationWithCurrentStatus:(NSString *)currentStatus andActivity:(NSString *)currentActivity andWithPreviousStatus:(NSString *)oldStatus andActivity:(NSString *)oldActivity
{
    CCMBuildNotificationFactory *factory = [[[CCMBuildNotificationFactory alloc] init] autorelease];
    CCMProjectBuilder *builder = [[[CCMProjectBuilder alloc] init] autorelease];
   	CCMProjectStatus *status = [[[builder status] withActivity:oldActivity] withBuildStatus:oldStatus];
    CCMProject *project = [[[builder project] withActivity:currentActivity] withBuildStatus:currentStatus];
    return [factory notificationForProject:project withOldStatus:status];
}


-(void)testSuccessfulBuildCompleteTriggersUserNotification
{
//TODO mock user defaults; fix send userNotification
    NSNotification *notification = [self
                                    notificationWithCurrentStatus:CCMSuccessStatus
                                    andActivity:CCMSleepingActivity
                                    andWithPreviousStatus:CCMSuccessStatus
                                    andActivity:CCMBuildingActivity];

    [[[notificationServiceMock expect] andForwardToRealObject] buildComplete:notification];
    [[[notificationAdaptorMock expect] andForwardToRealObject]
     sendUserNotification:@"Build successful"
     withSubject:@"connectfour"
     andDescription:@"Yet another successful build!"];

    [notificationServiceMock buildComplete:notification];
}

@end
