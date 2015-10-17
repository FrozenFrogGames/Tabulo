//
//  f3DirectorAdapter.h
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "../../Framework/Framework/IViewCanvas.h"
#import "../../Framework/Framework/View/f3DrawScene.h"

@protocol IViewScene;

@interface fgViewCanvas : GLKView<IViewCanvas> {

    bool haveTextureCoordinates;
    NSMutableArray *textureLoaded;
    CGSize screenSize, unitSize;
}

- (id)init:(EAGLContext *)_context;
- (GLKTextureInfo *)getTexture:(NSInteger)_index;

@end
