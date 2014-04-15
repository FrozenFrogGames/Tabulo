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

- (id)initWithName:(NSString *)_filename fromBundle:(bool)_fromBundle {

    self = [super init];

    if (self != nil)
    {
        NSError *fileError = nil;
        NSString *path;

        @try
        {
            if (_fromBundle)
            {
                path = [[NSBundle mainBundle] pathForResource:_filename ofType:@".F3G" inDirectory:@"Content"];
                // TODO fix for iOS 5.1
            }
            else
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

                path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:_filename] stringByAppendingPathExtension:@"F3G"];
            }

            data = [NSMutableData dataWithContentsOfFile:[path stringByExpandingTildeInPath] options:NSDataReadingMappedAlways error:&fileError];

            if (fileError != nil)
            {
                NSLog(@"Read failed with error: %@", fileError);

                return nil;
            }
        }
        @catch (NSException* exception)
        {
            NSLog(@"Read failed with exception: %@", exception);
            
            return nil;
        }

        NSLog(@"Read filename: %@", _filename);

        marker = malloc(sizeof(uint8_t));
        cursor = 0;
    }
    
    return self;
}

- (void)closeWithName:(NSString *)_filename {

    NSError *fileError;
    NSString *path;

    @try
    {
//      NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Content"];
//      NSString *path = [[resourcePath stringByAppendingPathComponent:_filename] stringByAppendingPathExtension:@"F3G"];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:_filename] stringByAppendingPathExtension:@"F3G"];

        if ([data writeToFile:path options:NSDataWritingAtomic error:&fileError])
        {
            NSLog(@"Write filename: %@", _filename);
        }
        else if (fileError != nil)
        {
            NSLog(@"Write failed with error: %@", fileError);
        }
    }
    @catch (NSException* exception)
    {
        NSLog(@"Write failed with exception: %@", exception);
    }
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

- (void)dealloc {
    
    free(marker);
}

@end
