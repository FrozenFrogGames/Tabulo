//
//  fgTabuloNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgHouseNode.h"
#import "fgPawnEdge.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"
#import "../../../Framework/Framework/View/f3TextureDecorator.h"

@implementation fgHouseNode

- (id)init:(CGPoint)_position extend:(CGSize)_extend flag:(uint8_t)_flag {

    self = [super init:_position extend:_extend flag:_flag];

    if (self != nil)
    {
        houseView = nil;
    }

    return self;
}

- (id)init:(CGPoint)_position radius:(float)_radius flag:(uint8_t)_flag {

    self = [super init:_position radius:_radius];

    if (self != nil)
    {
        houseView = nil;
    }

    return self;
}

- (void)bindView:(f3ViewAdaptee *)_view {
    
    houseView = _view;
}

- (void)buildHouseFeedback:(f3GraphSchema *)_schema edge:(fgPawnEdge *)_edge {

    bool isPawnMatches = [_schema getNodeFlag:_edge.OriginKey flag:goalFlag];
    
    [self replaceHouseTexture:isPawnMatches];
}

- (void)clearHouseFeedback:(f3GraphSchema *)_schema {
    
    if (_schema == nil)
    {
        [self replaceHouseTexture:false];
    }
    else
    {
        bool isPawnMatches = [_schema getNodeFlag:nodeKey flag:goalFlag];

        [self replaceHouseTexture:isPawnMatches];
    }
}

- (void)replaceHouseTexture:(bool)_result {

    if (houseView != nil)
    {
        f3ViewDecorator *textureDecorator = [(f3ViewAdaptee *)houseView getDecorator:[f3TextureDecorator class]];
        
        if (textureDecorator != nil)
        {
            f3TextureDecorator *decorator = [self buildTextureDecorator:[textureDecorator getComponent] result:_result];
            
            [houseView.ViewLayer replaceComponent:textureDecorator byComponent:decorator];
        }
    }
}

- (f3TextureDecorator *)buildTextureDecorator:(f3ViewComponent *)_component result:(bool)_home {
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    float houseX1 = (128.f +(goalFlag *384.f)) /2048.f;
    float houseX2 = (512.f +(goalFlag *384.f)) /2048.f;
    float houseY1 = _home ? 0.334201390f : 0.222222222f;
    float houseY2 = _home ? 0.444444444f : 0.333333333f;
    
    f3FloatArray *houseCoordonate = [f3FloatArray buildHandleForFloat32:16, FLOAT_BOX(houseX1), FLOAT_BOX(0.f), // 0
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.f),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(0.222222222f), // 2
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.222222222f),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(houseY1), // 4
                                     FLOAT_BOX(houseX2), FLOAT_BOX(houseY1),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(houseY2), // 6
                                     FLOAT_BOX(houseX2), FLOAT_BOX(houseY2), nil];
    
    [director.Builder push:_component];
    [director.Builder push:houseCoordonate];
    [director.Builder push:[director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [director.Builder buildDecorator:4];
    
    return (f3TextureDecorator *)[director.Builder popComponent];
}

@end
