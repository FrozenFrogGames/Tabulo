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

enum f3TabuloFlagIndex {
    
    TABULO_HavePawn        = 0,
    TABULO_HaveSmallPlank  = 1,
    TABULO_HaveMediumPlank = 2,
    TABULO_HaveLongPlank   = 3
};

@interface fgTabuloDirector : f3GameDirector {
    
    f3GraphNode *focusNode;
    fgTabuloController *gameController;
    bool displayFirstScene;
}

- (void)nextScene;

@end
