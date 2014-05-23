//
//  f3CanvasItem.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-12.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgViewAdapter.h"
#import "fgViewCanvas.h"
#import "../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../Framework/Framework/View/f3ViewDecorator.h"
#import "../../Framework/Framework/View/f3TextureDecorator.h"
#import "../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../Framework/Framework/View/f3TransformDecorator.h"
#import "../../Framework/Framework/View/f3ScaleDecorator.h"
#import "../../Framework/Framework/View/f3AngleDecorator.h"

@implementation fgViewAdapter

#define degreeToRadian( degree ) ( ( degree ) / 180.0 * M_PI )

@synthesize Next;

- (id)initWithView:(f3ViewAdaptee *)_view {
    
    self = [super init];
    
    if (self != Nil)
    {
        angleDegree = 0;
        relativeScale = CGSizeZero;
        relativePosition = CGPointZero;
        textureIndex = NSUIntegerMax;
        textureCoordinates = nil;
        ressource = [[GLKBaseEffect alloc] init];
        view = _view;
    }

    return self;
}

- (f3ViewAdaptee *)View {
    
    return view;
}

- (void)bindDecorator:(f3ViewDecorator *)_decorator {

    if ([_decorator isKindOfClass:[f3OffsetDecorator class]])
    {
        f3OffsetDecorator *decorator = (f3OffsetDecorator *)_decorator;

        if (decorator.Offset != nil)
        {
            relativePosition.x += decorator.Offset[0];
            relativePosition.y += decorator.Offset[1];
        }
    }
    else if ([_decorator isKindOfClass:[f3TransformDecorator class]])
    {
        f3TransformDecorator *decorator = (f3TransformDecorator *)_decorator;
        
        if (decorator.Offset != nil)
        {
            relativePosition.x += decorator.Offset[0];
            relativePosition.y += decorator.Offset[1];
        }
    }
    else if ([_decorator isKindOfClass:[f3ScaleDecorator class]])
    {
        f3ScaleDecorator *decorator = (f3ScaleDecorator *)_decorator;
        
        if (decorator.Scale != nil)
        {
            relativeScale.width += decorator.Scale[0];
            relativeScale.height += decorator.Scale[1];
        }
    }
    else if ([_decorator isKindOfClass:[f3AngleDecorator class]])
    {
        f3AngleDecorator *decorator = (f3AngleDecorator *)_decorator;
        angleDegree = decorator.Angle;
    }
    else if ([_decorator isKindOfClass:[f3TextureDecorator class]])
    {
        f3TextureDecorator *decorator = (f3TextureDecorator *)_decorator;
        textureIndex = decorator.Index;
        textureCoordinates = decorator.Coordinates;
    }
}

- (void)dealloc {

    textureCoordinates = nil;
    ressource = nil;
    view = nil;

    [self setNext:nil];
}

- (void)updatePosition:(const CGSize)_resolution Scale:(const CGSize)_scale {

    ressource.transform.projectionMatrix = GLKMatrix4MakeOrtho(0.0f, _resolution.width, 0.0f, _resolution.height, 0.0f, 1.0f);

    if (CGSizeEqualToSize(relativeScale, CGSizeZero))
    {
        ressource.transform.modelviewMatrix = GLKMatrix4Identity;
    }
    else
    {
        CGPoint absolutePosition = CGPointMake((_resolution.width / 2.f) + (_scale.width * relativePosition.x),
                                               (_resolution.height / 2.f) - (_scale.height * relativePosition.y) );

        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(absolutePosition.x, _resolution.height - absolutePosition.y, 0.0f);

        if (angleDegree > 0)
        {
            modelMatrix = GLKMatrix4Multiply(modelMatrix, GLKMatrix4MakeRotation(degreeToRadian(angleDegree), 0.f, 0.f, -1.f));
        }

        CGSize absoluteScale = CGSizeMake(_scale.width * relativeScale.width, _scale.height * relativeScale.height);
    
        modelMatrix = GLKMatrix4Multiply(modelMatrix, GLKMatrix4MakeScale(absoluteScale.width, absoluteScale.height, 0.0f));

        ressource.transform.modelviewMatrix = modelMatrix;
    }
}

- (void)drawItem:(NSObject<IViewCanvas> *)_canvas {

    [_canvas beginDraw];
    
    ressource.light0.enabled = GL_FALSE;
    ressource.useConstantColor = YES;
    ressource.constantColor = view.Color;
    
    if (textureIndex != NSUIntegerMax)
    {
        GLKTextureInfo *textureInfo = [((fgViewCanvas *)_canvas) getTexture:textureIndex];

        if (textureInfo != nil)
        {
            ressource.texture2d0.enabled = GL_TRUE;
            ressource.texture2d0.name = textureInfo.name;
            ressource.texture2d0.target = GLKTextureTarget2D;
            ressource.texture2d0.envMode = GLKTextureEnvModeModulate;
        }
        else
        {
            // TODO throw f3Exception
        }
    }

    if (textureCoordinates != nil)
    {
        [_canvas bindTextureCoordinates:textureCoordinates];
    }
    else
    {
        ressource.texture2d0.enabled = GL_FALSE;
    }

    [ressource prepareToDraw];

    [_canvas drawItem:view.Type Vertex:view.Vertex Indices:view.Indices Count:view.Count];

    [_canvas endDraw];

    angleDegree = 0;
    relativeScale = CGSizeZero;
    relativePosition = CGPointZero;
    textureIndex = NSUIntegerMax;
}

@end
