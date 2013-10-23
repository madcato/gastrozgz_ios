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
#define SERVER2 @"www.planogastronomicozaragoza.com"

#define BANNERS_URL @"banners/%@"
#define CATEGORIAS_URL @"lst_categorias/%@"
#define ESTABLECIMIENTOS_URL @"lst_establecimientos/%@"
#define CAT_EST_URL @"categorias_establecimientos"
#define IMAGES_URL @"fotos_establecimiento/%@"
#define CATEGORY_IMAGES_URL @"images/icons/%@.png"

@interface ServerURL : NSObject

+ (NSString*)serverURL;
+ (NSString*)baseURL;
+ (NSString*)bannersURL:(NSString*)language;
+ (NSString*)categoriasURL:(NSString*)language;
+ (NSString*)establecimientosURL:(NSString*)language;
+ (NSString*)catEstURL;
+ (NSString*)imageListURL:(NSString*)ido;
+ (NSString*)categoryImageURL:(NSString*)ido;

@end
