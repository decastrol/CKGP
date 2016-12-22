//
//  RKObjectManager+PutQueryParams.h
//
//

//#import <RestKit/RestKit.h>
//
//@interface RKObjectManager (PutQueryParams)
//
///** 
// By default, RestKit 0.20 (as if this writing 0.20.2) will send parameters
// in the HTTP body of the request for PUTs.
// This method is a wrapper around putObject:path:parameters:success:failure:
// that allows query parameters to be sent.
// 
// ( See https://groups.google.com/forum/#!topic/restkit/LzzplJKYowQ )
// 
// @param path If nil, defaults to the path specified by the router for PUTting the object. Can also be a path pattern.
// @param queryParameters Dictionary of values to append as query parameters
//*/
//- (void)putObject:(id)object path:(NSString *)path queryParameters:(NSDictionary *)queryParameters success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;
//
///**
// By default, RestKit 0.20 (as if this writing 0.20.2) will send parameters
// in the HTTP body of the request for POSTs.
// This method is a wrapper around postObject:path:parameters:success:failure:
// that allows query parameters to be sent.
// 
// ( See https://groups.google.com/forum/#!topic/restkit/LzzplJKYowQ )
// 
// @param path If nil, defaults to the path specified by the router for POSTing the object. Can also be a path pattern.
// @param queryParameters Dictionary of values to append as query parameters
// */
//- (void)postObject:(id)object path:(NSString *)path queryParameters:(NSDictionary *)queryParameters success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;
//
//@end
