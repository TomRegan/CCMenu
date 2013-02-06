
#import "CCMNotificationAdaptorTest.h"

@interface CCMNotificationService()
    -(void)sendUserNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description;
    -(void)buildComplete:(NSNotification *)notification;
@end


@implementation CCMNotificationAdapterTest

-(void) setUp
{
    notificationServiceMock = [OCMockObject partialMockForObject:[[[CCMNotificationService alloc] init] autorelease]];

}

-(void) tearDown
{
    [notificationServiceMock verify];
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

    NSNotification *notification = [self
                                    notificationWithCurrentStatus:CCMSuccessStatus
                                    andActivity:CCMSleepingActivity
                                    andWithPreviousStatus:CCMSuccessStatus
                                    andActivity:CCMBuildingActivity];
    [[[notificationServiceMock stub]
      andReturnValue:OCMOCK_VALUE((NSInteger){NotificationCenter})]
     selectedNotificationService];

    [[[notificationServiceMock expect] andForwardToRealObject] buildComplete:notification];
    [[notificationServiceMock expect] sendUserNotification:@"Build successful"
                                               withSubject:@"connectfour"
                                            andDescription:@"Yet another successful build!"];

    [notificationServiceMock buildComplete:notification];
}

@end
