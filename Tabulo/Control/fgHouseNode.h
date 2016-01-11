//
//  fgTabuloNode.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GoalNode.h"
#import "../../../Framework/Framework/view/f3ViewAdaptee.h"
#import "../fgTabuloDirector.h"

@class f3GraphSchema;
@class fgPawnEdge;

@interface fgHouseNode : f3GoalNode {

    f3ViewAdaptee *houseView;
    int pawnType;
}

- (void)bindView:(f3ViewAdaptee *)_view;

- (void)buildHouseFeedback:(f3GraphSchema *)_schema edge:(fgPawnEdge *)_edge;
- (void)clearHouseFeedback:(f3GraphSchema *)_schema;

@end
