//
//  Vektor3.m
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/9/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#import "Vektor3.h"

@implementation Vektor3

@synthesize x;
@synthesize y;
@synthesize z;

-(NSString *) description
{
    return [NSString stringWithFormat:@"< %f, %f, %f>", x, y, z];
}

//initializers
-(id) init
{
    x = 0.0;
    y = 0.0;
    z = 0.0;
    
    return self;
}

-(id) initWithX:(float)X Y:(float)Y Z:(float)Z
{
    x = X;
    y = Y;
    z = Z;
    
    return self;
}

//getters
-(float) getX
{
    return x;
}
-(float) Y
{
    return y;
}
-(float) Z
{
    return z;
}


//setters
-(void) setVector:(float *) vector
{
    x = vector[0];
    y = vector[1];
    z = vector[2];   
}

//math fcns
-(void) normalize
{
    //calc length
    float temp = sqrtf([self dotProduct:self]);
                        
    //normalize
    x /= temp;
    y /= temp;
    z /= temp;  
}

+(float) dotProduct:(Vektor3 *) vek1 with:(Vektor3 *) vek2
{
    return vek1.x*vek2.x + vek1.y*vek2.y + vek1.z*vek2.z;
}

-(float) dotProduct:(Vektor3 *) vek
{
    return x*vek.x + y*vek.y + z*vek.z;
}




@end
