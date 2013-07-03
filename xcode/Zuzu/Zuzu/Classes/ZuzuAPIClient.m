#import "ZuzuAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kZuzuAPIBaseURLString = @"http://sleepy-mountain-9630.herokuapp.com/";

@implementation ZuzuAPIClient

+ (ZuzuAPIClient *)sharedClient {
    static ZuzuAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kZuzuAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
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
