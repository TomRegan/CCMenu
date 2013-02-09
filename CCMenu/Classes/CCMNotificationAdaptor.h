//
//  CCMNotificationAdapter.h
//  CCMenu
//
//  Created by Tom Regan on 06/02/2013.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>


@interface CCMNotificationAdaptor : NSObject

- (void)sendNotification:(NSString*)title withSubject:(NSString*)subject andDescription:(NSString*) description;

@end
