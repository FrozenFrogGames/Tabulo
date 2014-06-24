//
//  fgTabuloState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../fgDataAdapter.h"
#import "../Control/fgLevelState.h"
#import "../View/fgTabuloDirector.h"
#import "../Editor/fgTabuloScene.h"

@interface fgTabuloGame : NSObject {
    
    fgDataAdapter *dataWriter;
    NSMutableArray *dataSymbols;
    fgTabuloScene *scene;
}

- (void)buildScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state;

- (NSObject<IDataAdapter> *)closeWriter:(NSInteger)_level;

@end
