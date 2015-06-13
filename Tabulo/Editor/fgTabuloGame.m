//
//  fgTabuloState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloGame.h"
#import "../Editor/fgTabuloScene.h"
#import "../../../Framework/Framework/Control/f3GraphPath.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"

@implementation fgTabuloGame

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        dataWriter = [[fgDataAdapter alloc] init];
        dataSymbols = [NSMutableArray array];
        scene = [[fgTabuloScene alloc] init];
    }
    
    return self;
}

- (void)loadScene:(fgTabuloDirector *)_director strategy:(fgLevelStrategy *)_strategy {

    f3GameState *gameState = [[f3GameState alloc] initWithStrategy:_strategy];
    
    [self buildScene:_director strategy:_strategy];

    [gameState loadScene:scene];

    [_strategy resolveGraphPath:dataWriter];
}

- (void)buildScene:(fgTabuloDirector *)_director strategy:(fgLevelStrategy *)_strategy {

    // visitor abstract class - subclass implement level init
}

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename {
    
    [dataWriter closeWithName:_filename];
    
    return dataWriter;
}

@end
