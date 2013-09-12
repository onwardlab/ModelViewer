//
//  Quaternion.h
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/10/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vektor3.h"

@interface Quaternion : NSObject
{
    float s;
    float i;
    float j;
    float k;
}

@property (nonatomic) float s;
@property (nonatomic) float i;
@property (nonatomic) float j;
@property (nonatomic) float k;

//nsobject
-(NSString *) description;


//initializers
-(Quaternion *) init;

-(Quaternion *) initWithVektor:(Vektor3 *) vek;

-(Quaternion *) initWithS:(float)S I:(float)I J:(float)J andK:(float)K;



  /////////////
 //math fcns//
/////////////
//3d rotation
+(Vektor3 *) rotatePoint:(Vektor3 *) point aboutAxis:(Vektor3 *) axis byAngle:(float) theta;

//conjugation
+(Quaternion *) conjugate:(Quaternion *) quat;

-(Quaternion *) conjugacy;

-(void) conjugate;

//multiplication
+(Quaternion *) multiply:(Quaternion *) quat1 by:(Quaternion *) quat2;

-(Quaternion *) postMultiplyBy:(Quaternion *) quat;

-(Quaternion *) preMultiplyBy:(Quaternion *) quat;

//inverse
+(Quaternion *) inverse:(Quaternion *) quat;

-(Quaternion *) inverse;

-(void) invert;

//normalization
-(void) normalize;

//length
-(float) norm;



@end
