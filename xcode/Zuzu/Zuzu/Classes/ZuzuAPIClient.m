#import "ZuzuAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFOAuth2Client.h"

static NSString * const kZuzuAPIBaseURLString = @"http://sleepy-mountain-9630.herokuapp.com/";

@implementation ZuzuAPIClient

@synthesize isAuthenticated = _isAuthenticated;

+ (ZuzuAPIClient *)sharedClient {
    static ZuzuAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kZuzuAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)authenticateUsingOAuthWithUsername:(NSString *)signature
                                  password:(NSString *)password
                                   success:(void (^)(AFOAuthCredential *credential))success
                                   failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:@"http://sleepy-mountain-9630.herokuapp.com/"];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:oClientID secret:oClientSecret];
    
    [oauthClient authenticateUsingOAuthWithPath:@"/oauth/token"
                                       username:@"signature"
                                       password:@"password"
                                          scope:@"email"
                                        success:^(AFOAuthCredential *credential) {
                                            NSLog(@"I have a token! %@", credential.accessToken);
                                            [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"No Token Error: %@", error);
                                        }];
    
//    NSURL *url = [NSURL URLWithString:oClientBaseURLString];
//    AFOAuth2Client *oauthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];
//    
//    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//
//    [oauthClient authenticateUsingOAuthWithPath:@"oauth/token.json"
//                                      signature:signature
//                                       password:password
//                                       clientID:oClientID
//                                         secret:oClientSecret
//                                        success:^(AFOAuthAccount *account) {
//        [self setAuthorizationHeaderWithToken:account.credential.accessToken refreshToken:account.credential.refreshToken];
//        success(account);
//    } failure:^(NSError *error) {
//        failure(nil);
//    }];
}

- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken{
    
    if (![accessToken isEqualToString:@""]) {
        self.isAuthenticated = YES;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"kaccessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"krefreshToken"];
        [self setAuthorizationHeaderWithToken:accessToken];
    }
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kaccessToken"];
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"krefreshToken"];
    
    [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
    
    return self;
}
#pragma mark - AFIncrementalStore
//
//- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
//    return responseObject;
//}
//
//- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation 
//                                     ofEntity:(NSEntityDescription *)entity 
//                                 fromResponse:(NSHTTPURLResponse *)response 
//{
//    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
//    
//    // Customize the response object to fit the expected attribute keys and values  
//    
//    return mutablePropertyValues;
//}
//
//- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
//                                 inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return NO;
//}
//
//- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
//                               forObjectWithID:(NSManagedObjectID *)objectID
//                        inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return NO;
//}

@end
