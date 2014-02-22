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
    
    f3ViewScene *lastScene;
}

@property (readonly) bool OrientationIsPortrait;

@property (readonly) CGSize Screen;
@property (readonly) CGSize Unit;

- (id)init:(EAGLContext *)_context;
- (void)deviceOrientationDidChange;

- (GLKTextureInfo *)getTexture:(NSInteger)_index;

@end
