//
//  Quaternion.m
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/10/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#import "Quaternion.h"

@implementation Quaternion

@synthesize s;
@synthesize i;
@synthesize j;
@synthesize k;

/////////////////////////////////////////////////
/////////////////////////////////////////////////
///// f*s ||  1  ||  i  ||  j  ||  k  ////second
//////////============================///////////
/////  1  ||  1  ||  i  ||  j  ||  k  ////
//////////----------------------------////
/////  i  ||  i  || -1  ||  k  || -j  ////
//////////----------------------------////
/////  j  ||  j  || -k  ||  -1 ||  i  ////
//////////----------------------------////
/////  k  ||  k  ||  j  || -i  ||  -1 ////
/////////////////////////////////////////////////
/////first///////////////////////////////////////

//nsobject
-(NSString *) description
{
    return [NSString stringWithFormat:@"Q< %f, %f, %f, %f>", s, i, j, k];
}


//initializers
-(Quaternion *) init
{
    s = 0.0;
    i = 0.0;
    j = 0.0;
    k = 0.0;
    
    return self;
}

-(Quaternion *) initWithVektor:(Vektor3 *) vek
{
    s = 0.0;
    i = vek.x;
    j = vek.y;
    k = vek.z;
    
    return self;
}

-(Quaternion *) initWithS:(float)S I:(float)I J:(float)J andK:(float)K
{
    s = S;
    i = I;
    j = J;
    k = K;
    
    return self;
}



/////////////
//math fcns//
/////////////

//3d rotation
//P = q*p*conj(q)
//
//q = cos(a/2) + i ( x * sin(a/2)) + j (y * sin(a/2)) + k ( z * sin(a/2))

+(Vektor3 *) rotatePoint:(Vektor3 *) point aboutAxis:(Vektor3 *) axis byAngle:(float) theta
{
    Quaternion *Point4D = [[Quaternion alloc] initWithVektor:point];
    Quaternion *axis4D = [[Quaternion alloc] initWithS: cosf(0.5*theta)
                                                     I: axis.x * sinf(0.5*theta) 
                                                     J: axis.y * sinf(0.5*theta) 
                                                  andK: axis.z * sinf(0.5*theta)];
    [axis4D normalize]; 
    
    Quaternion *conjAxis4D = [axis4D conjugacy];
    
    Point4D = [[Point4D preMultiplyBy:axis4D] postMultiplyBy:conjAxis4D];
    
    return [[Vektor3 alloc] initWithX:Point4D.i 
                                    Y:Point4D.j 
                                    Z:Point4D.k];
}

//conjugation
+(Quaternion *) conjugate:(Quaternion *) quat
{
    return [[Quaternion alloc] initWithS:quat.s I:quat.i*-1 J:quat.j*-1 andK:quat.k*-1 ];
}

-(Quaternion *) conjugacy
{
    return [[Quaternion alloc] initWithS:s I:i*-1 J:j*-1 andK:k*-1 ];
}

-(void) conjugate
{
    i *= -1;
    j *= -1;
    k *= -1;
}



//multiplication
//(a + i b + j c + k d)*(e + i f + j g + k h) =  a*e - b*f - c*g- d*h + i (b*e + a*f + c*h - d*g) + j (a*g - b*h + c*e + d*f) + k (a*h + b*g - c*f + d*e)

+(Quaternion *) multiply:(Quaternion *) quat1 by:(Quaternion *) quat2
{
    return [[Quaternion alloc] initWithS:(quat1.s * quat2.s) - (quat1.i * quat2.i) - (quat1.j * quat2.j) - (quat1.k * quat2.k)
                                       I:(quat1.i * quat2.s) + (quat1.s * quat2.i) + (quat1.j * quat2.k) - (quat1.k * quat2.j)
                                       J:(quat1.s * quat2.j) - (quat1.i * quat2.k) + (quat1.j * quat2.s) + (quat1.k * quat2.i) 
                                    andK:(quat1.s * quat2.k) + (quat1.i * quat2.j) - (quat1.j * quat2.i) + (quat1.k * quat2.s)];
}

-(Quaternion *) postMultiplyBy:(Quaternion *) quat
{
    return [[Quaternion alloc] initWithS:(s * quat.s) - (i * quat.i) - (j * quat.j) - (k * quat.k)
                                       I:(i * quat.s) + (s * quat.i) + (j * quat.k) - (k * quat.j)
                                       J:(s * quat.j) - (i * quat.k) + (j * quat.s) + (k * quat.i) 
                                    andK:(s * quat.k) + (i * quat.j) - (j * quat.i) + (k * quat.s)];
}

-(Quaternion *) preMultiplyBy:(Quaternion *) quat
{
    return [[Quaternion alloc] initWithS:(quat.s * s) - (quat.i * i) - (quat.j * j) - (quat.k * k)
                                       I:(quat.i * s) + (quat.s * i) + (quat.j * k) - (quat.k * j)
                                       J:(quat.s * j) - (quat.i * k) + (quat.j * s) + (quat.k * i) 
                                    andK:(quat.s * k) + (quat.i * j) - (quat.j * i) + (quat.k * s)];
}



//inverse
+(Quaternion *) inverse:(Quaternion *) quat
{
    return [[Quaternion alloc] init];
}

-(Quaternion *) inverse;
{
    return [[Quaternion alloc] init];
}

-(void) invert
{
    return;
}

-(void) normalize
{
    float temp = [self norm];
    
    s /= temp;
    i /= temp;
    j /= temp;
    k /= temp;
}

//length
-(float) norm
{
    return sqrtf(s*s + i*i + j*j + k*k);
}

@end
