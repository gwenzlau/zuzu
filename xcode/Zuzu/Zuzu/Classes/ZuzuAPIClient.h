
#import <Foundation/Foundation.h>
#import "AFIncrementalStore.h"
#import "AFHTTPClient.h"
#import "AFOAuth2Client.h"

@interface ZuzuAPIClient : AFHTTPClient <AFIncrementalStoreHTTPClient>

@property (nonatomic, assign) BOOL isAuthenticated;

+ (ZuzuAPIClient *)sharedClient;

- (void)setAuthorizationHeaderWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;

- (void)authenticateUsingOAuthWithUsername:(NSString *)signature
                                  password:(NSString *)password
                                   success:(void (^)(AFOAuthCredential *credential))success
                                   failure:(void (^)(NSError *error))failure;

// Credentials 
#define oClientBaseURLString @"http://sleepy-mountain-9630.herokuapp.com/"
#define oClientID            @"68b65f135d79ed04369777b999b107d6"
#define oClientSecret        @"47d98c8aaa90f27522a07b002c73552b"

@end
