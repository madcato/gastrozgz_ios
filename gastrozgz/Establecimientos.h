//
//  Establecimientos.h
//  gastrozgz
//
//  Created by Daniel Vela on 8/9/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Establecimientos : NSManagedObject

@property (nonatomic, retain) NSString * carta;
@property (nonatomic, retain) NSString * cierre;
@property (nonatomic, retain) NSString * cod_postal;
@property (nonatomic, retain) NSString * contacto;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * especialidades;
@property (nonatomic, retain) NSString * estado;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * gps_lat;
@property (nonatomic, retain) NSString * gps_lng;
@property (nonatomic, retain) NSString * menu;
@property (nonatomic, retain) NSDate * modified_at;
@property (nonatomic, retain) NSString * movil;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * objectid;
@property (nonatomic, retain) NSString * poblacion;
@property (nonatomic, retain) NSString * telefono;
@property (nonatomic, retain) NSString * url_facebook;
@property (nonatomic, retain) NSString * url_foto;
@property (nonatomic, retain) NSString * url_twitter;
@property (nonatomic, retain) NSString * web;

@end
