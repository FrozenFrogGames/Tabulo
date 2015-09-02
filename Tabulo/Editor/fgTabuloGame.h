//
//  fgTabuloState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../fgDataAdapter.h"
#import "../Control/fgTabuloStrategy.h"
#import "../fgTabuloDirector.h"
#import "../Editor/fgTabuloSceneBuilder.h"

// TODO implement as an operation using visitor on scene root node
@interface fgTabuloGame : NSObject {
    
    fgDataAdapter *dataWriter;
    NSMutableArray *dataSymbols;
    fgTabuloSceneBuilder *scene;
}

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgTabuloStrategy *)_strategy;

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename;

@end
