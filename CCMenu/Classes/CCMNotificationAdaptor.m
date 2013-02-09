//
//  CCMNotificationAdapter.m
//  CCMenu
//
//  Created by Tom Regan on 06/02/2013.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "CCMNotificationAdaptor.h"
#import "CCMNotificationService.h"

@implementation CCMNotificationAdaptor

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


- (void)sendNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NotificationService"] == NotificationCenter) {
        [self sendUserNotification:title withSubject:subject andDescription:description];
    } else  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NotificationService"] == Growl) {
        [self sendGrowlNotification:title withSubject:subject andDescription:description];
    }
}

@end
