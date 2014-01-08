//
//  DataAdapter.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-21.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgDataAdapter.h"

@implementation fgDataAdapter

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        data = [NSMutableData data];
        marker = malloc(sizeof(uint8_t));
        cursor = 0;
    }
    
    return self;
}

- (id)initWithName:(NSString *)_filename {
    
    self = [super init];
    
    if (self != nil)
    {
        data = [NSMutableData dataWithContentsOfFile:[_filename stringByExpandingTildeInPath]];
        
        cursor = 0;
        
        NSLog(@"read binary file : %@", _filename);
    }
    
    return self;
}

- (void)dealloc {
    
    free(marker);
}

- (void)closeWithName:(NSString *)_filename {
    
    [data writeToFile:[_filename stringByExpandingTildeInPath] atomically:true];
    
    NSLog(@"write binary file : %@", _filename);
}

- (uint8_t)readMarker {

    [self readBytes:marker length:sizeof(uint8_t)];

    return *marker;
}

- (void)readBytes:(void *)_bytes length:(NSUInteger)_length {
    
    if (cursor >= [data length])
    {
        *(uint8_t *)_bytes = 0xff;
    }
    else
    {
        [data getBytes:_bytes range:NSMakeRange(cursor, _length)];
        
        cursor += _length;
    }
}

- (void)writeMarker:(uint8_t)_marker {
    
    [self writeBytes:&_marker length:sizeof(uint8_t)];
}

- (void)writeBytes:(const void *)_bytes length:(NSInteger)_length {
    
    if (cursor >= [data length])
    {
        [data appendBytes:_bytes length:_length];
        
        cursor = [data length];
    }
    else
    {
        NSUInteger lengthDiff = [data length] - cursor;
        
        if (lengthDiff < _length)
        {
            [data increaseLengthBy:lengthDiff];
        }
        
        [data replaceBytesInRange:NSMakeRange(cursor, _length) withBytes:_bytes];
        
        cursor += _length;
    }
}

@end
