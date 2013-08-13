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

+ (NSString*)catEstURL {
    NSString* banner = [NSString stringWithFormat:CAT_EST_URL];
    return banner;
}

+ (NSString*)imageListURL:(NSString*)ido {
    NSString* images = [NSString stringWithFormat:IMAGES_URL,ido];
    NSString* url = [NSString stringWithFormat:@"%@%@",[self baseURL],images];
    return url;
}

@end
