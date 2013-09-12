//
//  glViewController.h
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/8/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Vektor3.h"
#import "Quaternion.h"

@interface glViewController : GLKViewController
<GLKViewDelegate, UIGestureRecognizerDelegate>
{
    GLuint vertxBuffer;
    GLuint indexBuffer;
    
    GLuint modelNormalBuffer;
    GLuint modelVertexBuffer;
    
    GLKBaseEffect *effect;
    EAGLContext *context;
    
    
    ///////////////////////
    //gesture recognizers//
    ///////////////////////

    ///camera position vectors
    Vektor3 *upVektor;
    Vektor3 *leftVektor;
    Vektor3 *position;
    
    //////////////////////
    ///pan gesture things
    UIPanGestureRecognizer *panRec;
    
    float xDis;
    float yDis;
    
    /////////////////
    ///pinch gesture
    UIPinchGestureRecognizer *pinchRec;
    
    float pinchScale;
    float prevScale;
    
    ///////////////////
    ///rotation gesture 
    UIRotationGestureRecognizer *rotRec;
    
    float prevRotAngle;
    
    
    //touches vars
    float xStart;
    float yStart;
    
    float xEnd;
    float yEnd;

}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)destroyGL;


@end
