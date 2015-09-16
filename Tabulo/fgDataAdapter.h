//
//  DataAdapter.h
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-21.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "../../Framework/Framework/IDataAdapter.h"

@interface fgDataAdapter : NSObject<IDataAdapter> {

    NSString *filename;
    NSMutableData *data;
    uint8_t *marker;
    NSUInteger cursor;
}

- (id)init:(NSString *)_filename bundle:(bool)_bundle;

- (void)close:(NSString *)_filename;

@end
