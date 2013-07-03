#import "AFIncrementalStore.h"
#import "AFHTTPClient.h"

@interface ZuzuAPIClient : AFHTTPClient <AFIncrementalStoreHTTPClient>

+ (ZuzuAPIClient *)sharedClient;

@end
