//
//  fgRemoveFeedbackCommand.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3RemoveFeedbackCommand.h"
#import "fgHouseNode.h"

@interface fgRemoveFeedbackCommand : f3RemoveFeedbackCommand {
    
    NSMutableArray *feedbackOnNodes;
}

- (void)appendHouseNode:(fgHouseNode *)_node;

@end
