//
//  RKObjectManager+PutQueryParams.m
//
//

//#import "RKObjectManager+PutQueryParams.h"
//#import <AFNetworking/AFNetworking.h>
//#import <RestKit/RestKit.h>
//
//@implementation RKObjectManager (PutQueryParams)
//
//- (void)putObject:(id)object path:(NSString *)path queryParameters:(NSDictionary *)queryParameters success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
//    [self putObject:object
//               path:[self pathForObject:object path:path method:RKRequestMethodPUT queryParameters:queryParameters]
//         parameters:nil
//            success:success
//            failure:failure];
//}
//
//- (void)postObject:(id)object path:(NSString *)path queryParameters:(NSDictionary *)queryParameters success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
//    [self postObject:object
//                path:[self pathForObject:object path:path method:RKRequestMethodPOST queryParameters:queryParameters]
//          parameters:nil
//             success:success
//             failure:failure];
//}
//
//// Returns the correponding path for the given object with the query parameters appended
//// If path is nil, defaults to the path specified by the router for the object/method combination
//- (NSString *)pathForObject:(id)object path:(NSString *)path method:(RKRequestMethod)method queryParameters:(NSDictionary *)queryParameters {
//    NSString *actualPath;
//    if (queryParameters) {
//        // If necessary, get the path specified by the router for the given object and method
//        actualPath = path ? path : [[[[self.router URLForObject:object method:method] absoluteString] componentsSeparatedByString:self.baseURL.absoluteString] objectAtIndex:1];
//        // Append ?queryParameters or &queryParameters to path
//        actualPath = RKPathFromPatternWithObject(actualPath, object);
//        actualPath = [actualPath stringByAppendingFormat:[actualPath rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@",AFQueryStringFromParametersWithEncoding(queryParameters, self.HTTPClient.stringEncoding)];
//    }
//    else {
//        actualPath = path;
//    }
//    return actualPath;
//}
//
//@end
