//
//  fgTabuloDirector.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Model/f3IntegerArray.h"
#import "../../../Framework/Framework/Model/f3FloatArray.h"
#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/IDataAdapter.h"

enum f3TabuloPawnType {

    TABULO_PawnOne   = 0,
    TABULO_PawnTwo   = 1,
    TABULO_PawnThree = 2,
    TABULO_PawnFour  = 3,
    TABULO_PawnFive  = 4,

    TABULO_PAWN_MAX  = 5
};

enum f3TabuloPlankType {

    TABULO_HaveSmallPlank  = 5,
    TABULO_HaveMediumPlank = 6,
    TABULO_HaveLongPlank   = 7,

    TABULO_PLANK_MAX = 8
};

enum f3TabuloHoleType {

    TABULO_OneHole_One              = 8,
    TABULO_OneHole_Two              = 9,
    TABULO_OneHole_Three            = 10,
    TABULO_OneHole_Four             = 11,
    TABULO_OneHole_Five             = 12,

    TABULO_TwoHoles_OneTwo          = 13,
    TABULO_TwoHoles_OneThree        = 14,
    TABULO_TwoHoles_OneFour         = 15,
    TABULO_TwoHoles_OneFive         = 16,
    TABULO_TwoHoles_TwoThree        = 17,
    TABULO_TwoHoles_TwoFour         = 18,
    TABULO_TwoHoles_TwoFive         = 19,
    TABULO_TwoHoles_ThreeFour       = 20,
    TABULO_TwoHoles_ThreeFive       = 21,
    TABULO_TwoHoles_FourFive        = 22,

    TABULO_ThreeHoles_OneTwoThree   = 23,
    TABULO_ThreeHoles_OneTwoFour    = 24,
    TABULO_ThreeHoles_OneTwoFive    = 25,
    TABULO_ThreeHoles_OneThreeFour  = 26,
    TABULO_ThreeHoles_OneThreeFive  = 27,
    TABULO_ThreeHoles_OneFourFive   = 28,
    TABULO_ThreeHoles_TwoThreeFour  = 29,
    TABULO_ThreeHoles_TwoThreeFive  = 30,
    TABULO_ThreeHoles_TwoFourFive   = 31,
    TABULO_ThreeHoles_ThreeFourFire = 32,
    
    TABULO_HOLE_MAX = 33
};

enum f3TabuloResource {
    
    RESOURCE_SpritesheetMenu,
    RESOURCE_SpritesheetLevel,
    RESOURCE_BackgroundMenu,
    RESOURCE_BackgroundLevel
};

enum fgTabuloGrade {
    
    GRADE_none,
    GRADE_bronze,
    GRADE_silver,
    GRADE_gold
};

@class fgViewCanvas;

@interface fgTabuloDirector : f3GameDirector {

    fgViewCanvas *gameCanvas;
    f3IntegerArray  *spritesheetLevel, *spritesheetMenu, *backgroundLevel, *backgroundMenu;
    NSMutableArray *levelFlags;
    NSUInteger lockedLevelIndex, sceneLayerCount;
}

- (f3IntegerArray *)getResourceIndex:(enum f3TabuloResource)_resource;

- (enum fgTabuloGrade)getGradeForLevel:(NSUInteger)_level;
- (void)setGrade:(enum fgTabuloGrade)_grade level:(NSUInteger)_level;
- (bool)isLevelLocked:(NSUInteger)_level;
- (NSUInteger)getLevelCount;

- (void)loadSceneFromFile:(NSObject<IDataAdapter> *)_data state:(f3GameState *)_state;

@end
