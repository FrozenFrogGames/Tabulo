//
//  fgPawnFeedbackCommand.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3AppendFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"

@interface fgPawnFeedbackCommand : f3AppendFeedbackCommand {
    
    enum f3TabuloPawnType pawnType;
    f3GraphNode *pawnNode;
}

- (id)initWithView:(f3ViewComponent *)_view Type:(enum f3TabuloPawnType)_type Node:(f3GraphNode *)_node;

@end
