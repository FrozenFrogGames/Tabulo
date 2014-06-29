//
//  fgTabuloNode.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/view/f3ViewAdaptee.h"
#import "../View/fgTabuloDirector.h"

@interface fgHouseNode : f3GraphNode {

    f3ViewAdaptee *houseView;
    enum f3TabuloPawnType houseType;
}

- (void)bindView:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type;
- (void)buildHouseFeedback:(enum f3TabuloPawnType)_type;

@end
