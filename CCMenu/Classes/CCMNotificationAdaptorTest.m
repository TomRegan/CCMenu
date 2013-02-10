
#import "CCMNotificationAdaptorTest.h"

@interface CCMNotificationService()
    -(void)sendUserNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description;
    - (void)sendGrowlNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description;
    -(void)buildComplete:(NSNotification *)notification;
@end

@implementation CCMNotificationServiceTest

-(void) setUp
{
    mockUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    notificationServiceMock = [OCMockObject partialMockForObject:[[[CCMNotificationService alloc] init] autorelease]];
    notificationAdaptorMock = [OCMockObject partialMockForObject:[[[CCMNotificationAdaptor alloc] init] autorelease]];
    [notificationServiceMock setValue:notificationAdaptorMock forKey:@"notificationAdaptor"];
    [notificationAdaptorMock setValue:mockUserDefaults forKey:@"userDefaults"];
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


- (NSNotification *)successNotification
{
    return [self
            notificationWithCurrentStatus:CCMSuccessStatus
            andActivity:CCMSleepingActivity
            andWithPreviousStatus:CCMSuccessStatus
            andActivity:CCMBuildingActivity];
}

-(void)testSuccessfulBuildCompleteTriggersUserNotification
{
    NSNotification *notification = [self successNotification];
    [[[mockUserDefaults stub]
       andReturnValue:OCMOCK_VALUE((NSInteger) {NotificationCenter})]
       integerForKey:@"NotificationService"];

    [[[notificationServiceMock expect] andForwardToRealObject] buildComplete:notification];
    [[notificationAdaptorMock expect]
     sendUserNotification:@"Build successful"
     withSubject:@"connectfour"
     andDescription:@"Yet another successful build!"];

    [notificationServiceMock buildComplete:notification];
}

-(void)testSuccessfulBuildCompleteTriggersGrowlNotification
{
    NSNotification *notification = [self successNotification];
    [[[mockUserDefaults stub]
      andReturnValue:OCMOCK_VALUE((NSInteger) {Growl})]
     integerForKey:@"NotificationService"];

    [[[notificationServiceMock expect] andForwardToRealObject] buildComplete:notification];
    [[notificationAdaptorMock expect]
     sendGrowlNotification:@"Build successful"
     withSubject:@"connectfour"
     andDescription:@"Yet another successful build!"];

    [notificationServiceMock buildComplete:notification];
}

@end
