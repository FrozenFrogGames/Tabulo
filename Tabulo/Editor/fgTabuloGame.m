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

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene copyLayersTo:_director.Scene];

    [_strategy resolveGraphPath:dataWriter];
    
    [scene clearPoints];
}

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename {
    
    [dataWriter closeWithName:_filename];
    
    return dataWriter;
}

@end
