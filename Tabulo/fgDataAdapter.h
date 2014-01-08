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

- (id)initWithName:(NSString *)_filename;

- (void)closeWithName:(NSString *)_filename;

@end
