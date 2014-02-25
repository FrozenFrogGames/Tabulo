//
//  fgPlankFeedbackCommand.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3AppendFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"

@interface fgPlankFeedbackCommand : f3AppendFeedbackCommand {
    
    enum f3TabuloPlankType plankType;
    f3GraphNode *plankNode;
}

- (id)initWithView:(f3ViewComponent *)_view Type:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node;

@end
