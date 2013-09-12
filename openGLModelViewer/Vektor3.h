//
//  Vektor3.h
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/9/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vektor3 : NSObject
{
    float x;
    float y;
    float z;
}

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float z;


//nsobject
-(NSString *) description;

//initializers
-(id) init;
-(id) initWithX:(float)X Y:(float)Y Z:(float)Z;

//setters
-(void) setVector:(float *) vector;

//math fcns
-(void) normalize;

+(float) dotProduct:(Vektor3 *) vek1 with:(Vektor3 *) vek2;
-(float) dotProduct:(Vektor3 *) vek;

@end
