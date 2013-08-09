//
//  ServerURL.m
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "ServerURL.h"

@implementation ServerURL

+ (NSString*)serverURL {
    return [NSString stringWithFormat:@"%@://%@/",PROTOCOL,SERVER];
}

+ (NSString*)baseURL {
    return [NSString stringWithFormat:@"%@://%@/%@/",PROTOCOL,SERVER,SERVICE];
}

+ (NSString*)bannersURL:(NSString*)language {
    if (([language isEqualToString:@"en"] == NO) &&
        ([language isEqualToString:@"es"] == NO)) {
        language = @"es";
    }
    NSString* banner = [NSString stringWithFormat:BANNERS_URL,language];
    return banner;
}

+ (NSString*)categoriasURL:(NSString*)language {
    if (([language isEqualToString:@"en"] == NO) &&
        ([language isEqualToString:@"es"] == NO)) {
        language = @"es";
    }
    NSString* banner = [NSString stringWithFormat:CATEGORIAS_URL,language];
    return banner;
}

+ (NSString*)establecimientosURL:(NSString*)language {
    if (([language isEqualToString:@"en"] == NO) &&
        ([language isEqualToString:@"es"] == NO)) {
        language = @"es";
    }
    NSString* banner = [NSString stringWithFormat:ESTABLECIMIENTOS_URL,language];
    return banner;
}

@end
