//
//  fgTabuloDirector.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../Control/fgTabuloController.h"
#import "fgViewCanvas.h"

@class f3IntegerArray;
@class f3FloatArray;

enum f3TabuloPawnType {

    TABULO_PawnOne   = 0,
    TABULO_PawnTwo   = 1,
    TABULO_PawnThree = 2,
    TABULO_PawnFour  = 3,
    TABULO_PawnFive  = 4
};

enum f3TabuloPlankType {

    TABULO_HaveSmallPlank  = 5,
    TABULO_HaveMediumPlank = 6,
    TABULO_HaveLongPlank   = 7
};

enum f3TabuloHoleType {

    TABULO_HoleOne   = 8,
    TABULO_HoleTwo   = 9,
    TABULO_HoleThree = 10,
    TABULO_HoleFour  = 11,
    TABULO_HoleFive  = 12
};

@interface fgTabuloDirector : f3GameDirector {

    f3GraphNode *focusNode;
    fgTabuloController *gameController;
    f3IntegerArray *indicesHandle, *spritesheet, *background;
    f3FloatArray *vertexHandle;

    unsigned int levelIndex;
    fgViewCanvas *gameCanvas;
}

- (void)nextScene;

@end
