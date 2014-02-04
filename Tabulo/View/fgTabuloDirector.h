//
//  fgTabuloDirector.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Model/f3IntegerArray.h"
#import "../../../Framework/Framework/Model/f3FloatArray.h"
#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/View/f3RotationDecorator.h"
#import "../Control/fgTabuloController.h"
#import "fgViewCanvas.h"

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

enum f3TabuloResource {
    
    RESOURCE_UserInterface,
    RESOURCE_SpriteSheet,
    RESOURCE_Background
};

enum f3TabuloDialogOptions {
    
    DIALOG_Play = 0,
    DIALOG_Next,
    DIALOG_Pause
};

@interface fgTabuloDirector : f3GameDirector {

    fgViewCanvas *gameCanvas;
    f3IntegerArray  *userinterface, *spritesheet, *background;
    f3RotationDecorator *backgroundRotation;
    NSUInteger levelIndex;
}

- (f3IntegerArray *)getResourceIndex:(enum f3TabuloResource)_resource;

- (void)showDialog:(enum f3TabuloDialogOptions)_options forScene:(NSUInteger)_index;
- (void)showDialog:(enum f3TabuloDialogOptions)_options;

@end
