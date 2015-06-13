//
//  fgTabuloState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../fgDataAdapter.h"
#import "../Control/fgLevelStrategy.h"
#import "../View/fgTabuloDirector.h"
#import "../Editor/fgTabuloScene.h"

// TODO implement as an operation using visitor on scene root node
@interface fgTabuloGame : NSObject {
    
    fgDataAdapter *dataWriter;
    NSMutableArray *dataSymbols;
    fgTabuloScene *scene;
}

- (void)loadScene:(fgTabuloDirector *)_director strategy:(fgLevelStrategy *)_strategy;

- (void)buildScene:(fgTabuloDirector *)_director strategy:(fgLevelStrategy *)_strategy;

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename;

@end
