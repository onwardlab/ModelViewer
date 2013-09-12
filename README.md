ModelViewer
===========

OpenGL Model Viewer


Blender
=======
export as "Objective C Header (.h)"
--Uses blender/objc_Export.py

Obj C Model Gen Fcns
====================
*****in geometric shapes -- Uses the fcns to makes arrays then...****
+(NSMutableArray *) makeRingWithRadius:(float)radius width:(float)width segments:(int)segs;

+(NSMutableArray *) makeStructureWithRingConstruct:(float *)radii 
                                        andHeights:(float *)heights
                                        numOfRings:(int) rCount
                                      withSegments:(int) segs;

+(NSMutableArray *) makeEllipsoidWithXRadius:(float) xRadius
                                     yRadius:(float) yRadius
                                     zRadius:(float) zRadius
                                  xySegments:(int) xySegs
                                   zSegments:(int) zSegs;

+(NSMutableArray *) makeSphereWithRadius:(float) radius
                             andSegments:(int) segs;


***Uses this fcn to load the model array data in openGL
+(void) extractShapeInfo:(NSMutableArray *) shape
                 vertexs:(Vertex **) vertexs
                  indexs:(GLushort **) indexs
             vertexCount:(int *) vCount
              indexCount:(int *) iCount;
