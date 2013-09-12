//
//  glViewController.m
//  openGLModelViewer
//
//  Created by Tim Flanagan on 2/8/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//


#import "glViewController.h"
#import "geoVertex.h"
#import "geometricShapes.h"
#import "vertexTypes.h"

//models
#import "pawn2.h"


#define PI 3.1415

#define panHandlerDebug NO
#define pinchHandlerDebug NO
#define rotationHandlerDebug NO
#define touchesDebug NO

#define modelData YES


@implementation glViewController

@synthesize effect;
@synthesize context;

Vertex tetrahedron[] = {
    {{0, 0, 1} , {1, 0, 0, 0}},
    {{0.943, 0, -0.333}, {0, 1, 0, 0}},
    {{-0.471, 0.816, -0.333}, {0, 0, 1, 0}},
    {{-0.471, -0.816, -0.333}, {0, 0.5, 0.5, 0}}
};

GLushort tetraIndicies[] = {
    0, 1, 2, 3, 1, 0};

Vertex *drawVertexs;
GLushort *drawIndexs;

int vertexCount;
int indexCount;


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    ///////////////
    //setup gl es//
    ///////////////
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
//    //tetrahedron
//    drawVertexs = tetrahedron;
//    drawIndexs = tetraIndicies;
//    
//    vertexCount = 4;
//    indexCount = 6;
    

//    //wormhole shape
//    float radii[] =   {4.0, 2.0, 1.0, 0.5, 1.0, 2.0, 4.0};
//    float heights[] = {0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0};
//    
//    NSMutableArray *shapeInfo = [geometricShapes makeStructureWithRingConstruct:radii 
//                                                                     andHeights:heights 
//                                                                     numOfRings:7 
//                                                                   withSegments:6];
    
    
//    ////cylinder
//    float radii[] = {0.0, 1.0, 1.0, 0.0};
//    float height[] = {0.0, 0.0, 2.0, 2.0};
    
    
    
    ////simple pawn --- complex pawn loaded from .h
    float radii[] =  {0.0, 4.0, 4.0*sqrtf(2.0), 5.0, 4.0*sqrtf(2.0), 4.0, 4.0, 4.0*sqrtf(2.0)-0.3, 5.0-0.3, 4.0*sqrtf(2.0)-0.3, 4.0, 2.0, 1.0,    0.5, 
        sqrtf(2.0), 2.0 , sqrtf(2.0), 0.0};
    float height[] = {0.0, 0.0, 1.5,            2.5, 3.5,            4.0, 5.0, 6.0,                7.0,     8.0,                9.0, 10.0, 12.0, 15.0, 
        16.0,       17.0, 18.0,      19.0};
    
    NSMutableArray *shapeInfo = [geometricShapes makeStructureWithRingConstruct:radii
                                                                     andHeights:height
                                                                     numOfRings:(sizeof(radii) / sizeof(float))
                                                                   withSegments:4];
   
    [geometricShapes extractShapeInfo:shapeInfo 
                              vertexs:&drawVertexs indexs:&drawIndexs 
                          vertexCount:&vertexCount indexCount:&indexCount];
     
//    NSLog(@"%@", drawVertexs);
    
    [self setupGL];
    
    
    /////////////////////////////
    //setup gesture recognizers//
    /////////////////////////////
    self.view.userInteractionEnabled = YES;
    
    panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panRec.delegate = self;
    [self.view addGestureRecognizer:panRec];
    
    pinchRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    pinchRec.delegate = self;
    [self.view addGestureRecognizer:pinchRec];
    
    rotRec = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationHandler:)];
    rotRec.delegate = self;
    [self.view addGestureRecognizer:rotRec];
    
    /////////////////// 
    ///init some vars//
    ///////////////////
    
    upVektor = [[Vektor3 alloc] initWithX:0.0 Y:1.0 Z:0.0];
    leftVektor = [[Vektor3 alloc] initWithX:-1.0 Y:0.0 Z:0.0];
    position = [[Vektor3 alloc] initWithX:0.0 Y:0.0 Z:1.0];
    
    pinchScale = 8.0;
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self destroyGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

////////////////////////////////
/// ////**********************//
/// ////*   openGL & GLKit   *//
/// ////**********************//
////////////////////////////////
////////////////////////////////

#pragma mark - openGL & GLKit
#pragma mark - openGL Setup

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
//    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.effect = [[GLKBaseEffect alloc] init];
    
      ///************///***********///
     ///   camera   ///   setup   ///
    /// ********** /// ********* ///
    self.effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 1.0, 50.0);
    self.effect.transform.modelviewMatrix= GLKMatrix4MakeTranslation(0.0, 0.0, -3.0);
    
    
    if (modelData)
    {
        glGenVertexArraysOES(1, &modelVertexBuffer);
        glBindVertexArrayOES(modelVertexBuffer);
        
        glGenBuffers(1, &modelVertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, modelVertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(PawnVertexData), PawnVertexData, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vec3)*2, 0);
        
//        glEnableVertexAttribArray(GLKVertexAttribNormal);
//        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(vec3), (GLvoid *) offsetof(vertexDataV3N3, normal));
        
        glBindVertexArrayOES(0);
    }
    else
    {
        glGenVertexArraysOES(1, &vertxBuffer);
        glBindVertexArrayOES(vertxBuffer);
        
        glGenBuffers(1, &vertxBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertxBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*vertexCount, drawVertexs, GL_STATIC_DRAW);
        
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*indexCount, drawIndexs, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *) offsetof(Vertex, Color));
        
        glBindVertexArrayOES(0);
    }
}

-(void)destroyGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if(modelData)
    {
        glDeleteBuffers(1, &modelVertexBuffer);
        glDeleteBuffers(1, &modelNormalBuffer);
    }
    else
    {
        glDeleteBuffers(1, &vertxBuffer);
        glDeleteBuffers(1, &indexBuffer);
    }
        
    self.effect = nil;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    if(modelData)
    {
        
        glBindVertexArrayOES(modelVertexBuffer);
        
        [self.effect prepareToDraw];
        
//        glDrawArrays(GL_TRIANGLES, 0, sizeof(PawnVertexData)/(2* sizeof(vec3)) );
        glDrawArrays(GL_TRIANGLES, 0, 14832);
    }
    else
    {
        glBindVertexArrayOES(vertxBuffer);
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLE_STRIP, indexCount, GL_UNSIGNED_SHORT, 0);
    }
}

#pragma mark - GLKViewControllerDelegate

- (void)update
{                                          
      ////////////////////////////////
     // //calc spherical coords//  //
    ////////////////////////////////
    
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    effect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(pinchScale*position.x, pinchScale*position.y, pinchScale*position.z, //eye position 
                                                            0.0, 0.0, 0.0, ///look at point
                                                            upVektor.x, upVektor.y, upVektor.z); ///camera up vector
    
}

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [[touches anyObject] locationInView:nil];
    if(touchesDebug)
    {
        NSLog(@"Touches Began at (%f,%f)", pos.x, pos.y);
    }
    
    xStart = pos.x;
    yStart = pos.y;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [[touches anyObject] locationInView:nil];
    if(touchesDebug)
    {
        NSLog(@"Touches Ended at (%f,%f)", pos.x, pos.y);
    }
    
    xEnd = pos.x;
    yEnd = pos.y;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchesDebug)
    {
        NSLog(@"touches cancelled");
    }
}


////////////////////////////////
/// ////**********************//
/// ////* Gestures and stuff *//
/// ////**********************//
////////////////////////////////
////////////////////////////////

#pragma mark - Gesture Recognition
#pragma mark - Gesture Delegate
//// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        xDis = 0.0;
        yDis = 0.0;
    }
    else if([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        prevScale = pinchScale;
    }
    else if([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]])
    {
        prevRotAngle = 0.0; 
    }
    
    return YES;
}

//// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
//// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
////
//// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] && 
       [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        return YES;
    }
    else if([otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] && 
            [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    
//}

     ///////////////////////////
    /// /// gesture handlers //
   ///////////////////////////

#pragma mark - Gesture Handlers

- (void) panHandler: (UIPanGestureRecognizer *) rec//screen coords start in top-left
{   
    float normX = PI * (xDis - [rec translationInView:self.view].x) / self.view.frame.size.width;
    float normY = PI * ([rec translationInView:self.view].y - yDis) / self.view.frame.size.height;
    
    
    if(normY != 0.0)
    {
        position = [Quaternion rotatePoint:position aboutAxis:leftVektor byAngle:normY];
        upVektor = [Quaternion rotatePoint:upVektor aboutAxis:leftVektor byAngle:normY];
    }
    
    if(normX != 0.0)
    {
        position = [Quaternion rotatePoint:position aboutAxis:upVektor byAngle:normX];
        leftVektor = [Quaternion rotatePoint:leftVektor aboutAxis:upVektor byAngle:normX];
    }

    if(panHandlerDebug)
    {
        NSLog(@"Start panHandler");
        NSLog(@"transX: %f    transY: %f", [rec translationInView:self.view].x - xDis, [rec translationInView:self.view].y - yDis);
        NSLog(@"xDis: %f    yDis: %f", xDis, yDis);
        NSLog(@"position: %@", position);
        NSLog(@"upVektor: %@", upVektor);
        NSLog(@"leftVektor: %@", leftVektor);
    }
    
    xDis = [rec translationInView:self.view].x;
    yDis = [rec translationInView:self.view].y;
    

}

- (void) pinchHandler: (UIPinchGestureRecognizer *) rec
{
    pinchScale = prevScale/rec.scale;
    if(pinchHandlerDebug)
    {
        NSLog(@"Start pinchHandler");
        NSLog(@"scale: %f    velocity: %f", rec.scale, rec.velocity);
    }
}

- (void) rotationHandler: (UIRotationGestureRecognizer *) rec
{
    prevRotAngle = rec.rotation - prevRotAngle;
    if(prevRotAngle != 0){
        upVektor = [Quaternion rotatePoint:upVektor aboutAxis:position byAngle:prevRotAngle]; 
        leftVektor = [Quaternion rotatePoint:leftVektor aboutAxis:position byAngle:prevRotAngle];
    }
    
    prevRotAngle = rec.rotation;
    
    if(rotationHandlerDebug)
    {
        NSLog(@"Start rotationHandler");
        NSLog(@"angle: %f    velocity: %f", rec.rotation, rec.velocity);
    }
}
@end

