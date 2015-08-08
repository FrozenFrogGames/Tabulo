//
//  fgTabuloNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgHouseNode.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"
#import "../../../Framework/Framework/View/f3TextureDecorator.h"
#import "../../../Framework/Framework/View/f3ViewSearch.h"

@implementation fgHouseNode

- (id)initPosition:(CGPoint)_position extend:(CGSize)_extend {

    self = [super initPosition:_position extend:_extend];

    if (self != nil)
    {
        houseView = nil;
        houseType = TABULO_PAWN_MAX;
    }

    return self;
}

- (id)initPosition:(CGPoint)_position radius:(float)_radius {

    self = [super initPosition:_position radius:_radius];

    if (self != nil)
    {
        houseView = nil;
        houseType = TABULO_PAWN_MAX;
    }

    return self;
}

- (void)bindView:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type {
    
    houseView = _view;
    houseType = _type;
}

- (void)buildHouseFeedback:(enum f3TabuloPawnType)_type {

    if (_type == houseType)
    {
        [self replaceHouseTexture:true];
    }
    else
    {
        [self replaceHouseTexture:false];
    }
}

- (void)replaceHouseTexture:(bool)_result {

    if (houseView != nil)
    {
        f3ViewSearch *searchDecorator = [[f3ViewSearch alloc] initSearch:houseView forType:[f3TextureDecorator class]];
        
        [houseView.ViewLayer accept:searchDecorator];
        
        if (searchDecorator.Result != nil)
        {
            f3ViewSearch *searchComponent = [[f3ViewSearch alloc] initSearch:houseView ownedBy:searchDecorator.Result];
            
            [searchDecorator.Result accept:searchComponent]; // check for decorator between the texture and the view
            
            if (searchComponent.Result != nil)
            {
                f3TextureDecorator *decorator = [self buildTextureDecorator:searchComponent.Result result:_result];
                
                [houseView.ViewLayer replaceComponent:searchDecorator.Result byComponent:decorator];
            }
            else
            {
                f3TextureDecorator *decorator = [self buildTextureDecorator:houseView result:_result];
                
                [houseView.ViewLayer replaceComponent:searchDecorator.Result byComponent:decorator];
            }
        }
    }
}

- (f3TextureDecorator *)buildTextureDecorator:(f3ViewComponent *)_component result:(bool)_home {
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    float houseX1 = (128.f +(houseType *384.f)) /2048.f;
    float houseX2 = (512.f +(houseType *384.f)) /2048.f;
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
