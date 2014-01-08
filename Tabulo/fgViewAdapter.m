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
#import "../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../Framework/Framework/View/f3TextureDecorator.h"

@implementation fgViewAdapter

@synthesize Next;

- (id)initWithView:(f3ViewAdaptee *)_view {
    
    self = [super init];
    
    if (self != Nil)
    {
        ressource = [[GLKBaseEffect alloc] init];
        view = _view;
        texture = nil;
        relativePosition = CGPointMake(0.f, 0.f);
        relativeScale = CGSizeMake(1.f, 1.f);
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
    else if ([_decorator isKindOfClass:[f3TextureDecorator class]])
    {
        texture = (f3TextureDecorator *)_decorator;
    }
}

- (void)updatePosition:(const CGSize)_resolution Scale:(const CGSize)_scale {

    CGPoint absolutePosition = CGPointMake((_resolution.width / 2.f) + (_scale.width * relativePosition.x),
                                           (_resolution.height / 2.f) - (_scale.height * relativePosition.y) );
    GLKMatrix4 translationMatrix = GLKMatrix4MakeTranslation(absolutePosition.x, _resolution.height - absolutePosition.y, 0.0f);
    
    CGSize absoluteScale = CGSizeMake(_scale.width * relativeScale.width, _scale.height * relativeScale.height);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(absoluteScale.width, absoluteScale.height, 0.0f);

    ressource.transform.projectionMatrix = GLKMatrix4MakeOrtho(0.0f, _resolution.width, 0.0f, _resolution.height, 0.0f, 1.0f);
    ressource.transform.modelviewMatrix = GLKMatrix4Multiply(translationMatrix, scaleMatrix);
}

- (void)drawItem:(NSObject<IViewCanvas> *)_canvas {

    if (texture != nil)
    {
        GLKTextureInfo *textureInfo = [((fgViewCanvas *)_canvas) getTextureByName:@"debug_DefaultPose"/*texture.Name*/];

        if (textureInfo != nil)
        {
            ressource.light0.enabled = GL_FALSE;
            ressource.texture2d0.enabled = GL_TRUE;
            ressource.texture2d0.name = textureInfo.name;
            ressource.texture2d0.target = GLKTextureTarget2D;
        }
        else
        {
            // TODO throw f3Exception
        }
    }

    [_canvas beginDraw];

    if (texture != nil)
    {
//      [_canvas bindTextureCoordinates:texture.Coordinates];
    }
    else
    {
        ressource.light0.enabled = GL_FALSE;
        ressource.useConstantColor = YES;
        ressource.constantColor = view.Color;
        ressource.texture2d0.enabled = GL_FALSE;
    }

    [ressource prepareToDraw];
    
    // TODO support others draw methods based on adaptee property

    [_canvas drawItem:view.Type Vertex:view.Vertex Indices:view.Indices Count:view.Count];

    [_canvas endDraw];
    
    texture = nil;
    relativePosition = CGPointMake(0.f, 0.f);
    relativeScale = CGSizeMake(1.f, 1.f);
}

@end
