
#import <Cocoa/Cocoa.h>


@interface CCMConnection : NSObject <NSURLConnectionDelegate>
{
	NSURL			*serverUrl;
	
	NSURLConnection *urlConnection;
	NSMutableData	*receivedData;
	
	id delegate;
}

- (id)initWithServerURL:(NSURL *)theServerUrl;
- (id)initWithURLString:(NSString *)theServerUrlAsString;

- (NSURL *)serverURL;

- (void)setDelegate:(id)aDelegate;
- (id)delegate;

- (BOOL)testConnection;
- (NSArray *)retrieveServerStatus;

- (void)requestServerStatus;
- (void)cancelStatusRequest;

@end


@interface NSObject(CCMConnectionDelegate)

- (void)connection:(CCMConnection *)connection didReceiveServerStatus:(NSArray *)projectInfoList;
- (void)connection:(CCMConnection *)connection hadTemporaryError:(NSString *)errorString;

@end
