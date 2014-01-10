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

@interface fgViewAdapter : NSObject<IViewAdapter> {

    GLKBaseEffect *ressource;
    f3ViewDecorator *texture;
    f3ViewAdaptee *view;
    CGPoint relativePosition;
    CGSize relativeScale;
    float angleDegree;
}

- (void)updatePosition:(const CGSize)_resolution Scale:(const CGSize)_scale;
- (void)drawItem:(NSObject<IViewCanvas> *)_canvas;

@end
