//
//  f3CanvasItem.h
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-12.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "../../Framework/Framework/IViewAdapter.h"
#import "../../Framework/Framework/IViewCanvas.h"

@class f3TextureDecorator;

@interface fgViewAdapter : NSObject<IViewAdapter> {

    float angleDegree;
    CGSize relativeScale;
    CGPoint relativePosition;
    NSUInteger textureIndex;
    const float *textureCoordinates;
    GLKBaseEffect *ressource;
    f3ViewAdaptee *view;
}

- (void)updatePosition:(const CGSize)_resolution Scale:(const CGSize)_scale;
- (void)drawItem:(NSObject<IViewCanvas> *)_canvas;

@end
