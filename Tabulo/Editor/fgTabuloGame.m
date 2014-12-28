//
//  fgTabuloState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloGame.h"
#import "../Editor/fgTabuloScene.h"
#import "../../../Framework/Framework/Control/f3GraphPath.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"

@implementation fgTabuloGame

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        dataWriter = [[fgDataAdapter alloc] init];
        dataSymbols = [NSMutableArray array];
        scene = [[fgTabuloScene alloc] init];
    }
    
    return self;
}

- (void)loadScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state {

    [_director loadScene:scene state:_state];

    [_state resolveGraphPath:dataWriter];

/*
    f3GraphPath *resolver = [_state buildGraphResolver];
    
    while ([resolver computeAllConfig:_state])
    {
        NSLog(@"%@", resolver);
    }
    
    unsigned int *solutionIndexes;
    NSUInteger solutionCount = [resolver getSolutionIndexes:&solutionIndexes];
    NSMutableArray *bestSolutions = [NSMutableArray array];
    NSUInteger pathLength, shortestPathLength = 0;
    
    for (NSUInteger i = 0; i < solutionCount; ++i)
    {
        f3GraphState *solution = [resolver resolve:solutionIndexes[i] initial:0];
        
        if (solution != nil)
        {
            pathLength = solution.PathLength;
            
            if (shortestPathLength == 0 || pathLength < shortestPathLength)
            {
                shortestPathLength = pathLength;
                
                [bestSolutions removeAllObjects];
            }
            
            if (pathLength == shortestPathLength)
            {
                [bestSolutions addObject:solution];
            }
        }
        else
        {
            // TODO throw f3Exception
        }
    }
    
    if (solutionIndexes != nil)
    {
        free(solutionIndexes);
    }
    
    for (f3GraphState *solution in bestSolutions)
    {
        [dataWriter writeMarker:0x0B];
        [solution serialize:dataWriter];
        
        [(fgLevelState *)_state bindSolution:solution];
    }
 */
}

- (NSObject<IDataAdapter> *)closeWriter:(NSString *)_filename {
    
    [dataWriter closeWithName:_filename];
    
    return dataWriter;
}

@end
