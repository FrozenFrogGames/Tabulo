//
//  fgTabuloState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloGame.h"
#import "../Editor/fgTabuloSceneBuilder.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/Control/f3MutableGraphNodeState.h"

@implementation fgTabuloGame

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        dataWriter = [[fgDataAdapter alloc] init];
        dataSymbols = [NSMutableArray array];
        scene = [[fgTabuloSceneBuilder alloc] init];
    }
    
    return self;
}

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgTabuloStrategy *)_strategy {

    [scene clearPoints];

    [_strategy resolveGraphPath:dataWriter];
}

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename {
    
    [dataWriter closeWithName:_filename];
    
    return dataWriter;
}

@end
