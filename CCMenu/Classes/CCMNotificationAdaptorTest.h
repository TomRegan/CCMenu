//
//  CCMNotificationAdapterTest.h
//  CCMenu
//
//  Created by Tom Regan on 04/02/2013.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#import "CCMNotificationService.h"
#import "CCMBuildNotificationFactory.h"
#import "CCMProjectStatus.h"
#import "CCMProjectBuilder.h"


@interface CCMNotificationAdapterTest : SenTestCase
{
    id notificationAdaptorMock;
}

@end
