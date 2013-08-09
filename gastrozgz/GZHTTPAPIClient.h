//
//  GZHTTPAPIClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//
//
// Sample implementation

#import <Foundation/Foundation.h>
#import "HTTPAPIClient.h"

@interface GZHTTPAPIClient : AFHTTPClient <HTTPAPIClient>

+ (GZHTTPAPIClient *)sharedClient;

@end
