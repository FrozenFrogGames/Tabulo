//
//  f3DirectorAdapter.h
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "../../Framework/Framework/IViewCanvas.h"
#import "../../Framework/Framework/View/f3ViewScene.h"

@protocol IViewScene;

@interface fgViewCanvas : GLKView<IViewCanvas> {

    bool currentOrientationIsPortrait, targetOrientationIsPortrait, haveTextureCoordinates;

    NSMutableArray *textureLoaded;
    CGSize screenSize, unitSize;
    f3ViewScene *scene;
}

@property (readonly) CGSize Screen;
@property (readonly) CGSize Unit;
@property (readonly) bool OrientationIsPortrait;

- (id)init:(EAGLContext *)_context scene:(f3ViewScene *)_scene;
- (void)deviceOrientationDidChange;

- (GLKTextureInfo *)getTexture:(NSInteger)_index;

@end
