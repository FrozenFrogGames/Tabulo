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

@class f3IntegerArray;
@class f3FloatArray;

enum f3TabuloPawnType {

    TABULO_CirclePawn   = 0,
    TABULO_PentagonPawn = 1,
    TABULO_TrianglePawn = 2,
    TABULO_StarPawn     = 3,
    TABULO_SquarePawn   = 4,
};

enum f3TabuloPlankType {

    TABULO_HaveSmallPlank  = 5,
    TABULO_HaveMediumPlank = 6,
    TABULO_HaveLongPlank   = 7
};

enum f3TabuloHoleType {

    TABULO_CircleHole   = 8,
    TABULO_PentagonHole = 9,
    TABULO_TriangleHole = 10,
    TABULO_StarHole     = 11,
    TABULO_SquareHole   = 12
};

@interface fgTabuloDirector : f3GameDirector {

    f3GraphNode *focusNode;
    fgTabuloController *gameController;
    f3IntegerArray *indicesHandle, *spritesheet, *background;
    f3FloatArray *vertexHandle;
    unsigned int levelIndex;
}

- (void)nextScene;

@end
