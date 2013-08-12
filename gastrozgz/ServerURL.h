//
//  ServerURL.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/8/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL_FORMAT @"%@://%@/%@/%@"
#define PROTOCOL @"http"
#define SERVER @"services.planogastronomicozaragoza.com"
#define SERVICE @"RestSvcPlanoZGZ"

#define BANNERS_URL @"banners/%@"
#define CATEGORIAS_URL @"lst_categorias/%@"
#define ESTABLECIMIENTOS_URL @"lst_establecimientos/%@"
#define CAT_EST_URL @"categorias_establecimientos"

@interface ServerURL : NSObject

+ (NSString*)serverURL;
+ (NSString*)baseURL;
+ (NSString*)bannersURL:(NSString*)language;
+ (NSString*)categoriasURL:(NSString*)language;
+ (NSString*)establecimientosURL:(NSString*)language;
+ (NSString*)catEstURL;

@end
