
#import <SenTestingKit/SenTestingKit.h>
#import "CCMConnection.h"


@interface CCMConnectionTest : SenTestCase 
{
    CCMConnection   *connection;
    OCMockObject    *connectionMock;
    NSArray         *recordedInfos;
    NSString        *recordedError;
}

@end
