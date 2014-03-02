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
    
    f3GraphNode *plankNode;
}

- (id)initWithView:(f3ViewComponent *)_view Node:(f3GraphNode *)_node;

@end
