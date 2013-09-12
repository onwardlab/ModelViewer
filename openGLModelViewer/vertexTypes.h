//
//  vertexTypes.h
//  openGLModelViewer
//
//  Created by Tim Flanagan on 4/14/12.
//  Copyright (c) 2012 Boredom. All rights reserved.
//

#ifndef openGLModelViewer_vertexTypes_h
#define openGLModelViewer_vertexTypes_h



#endif

struct vec3
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
};

struct vec2
{
    GLfloat x;
    GLfloat y;
};

typedef struct vec2 vec2;
typedef struct vec3 vec3;

struct vertexDataV3N3
{
    vec3 vertex;
    vec3 normal;
};

typedef struct vertexDataV3N3 vertexDataV3N3;


