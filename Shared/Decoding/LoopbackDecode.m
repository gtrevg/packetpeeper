/*
 * Packet Peeper
 * Copyright 2006, 2007, 2008, 2014 Chris E. Holloway
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "LoopbackDecode.h"
#include "../../PacketPeeper/UI Classes/pkt_compare.h"
#include "IPV4Decode.h"
#include "IPV6Decode.h"
#import <Foundation/NSArchiver.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSString.h>
#include <limits.h>
#include <sys/socket.h>
#include <sys/types.h>

@implementation LoopbackDecode

- (id)initWithData:(NSData*)dataVal parent:(id<PPDecoderParent>)parentVal
{
    if (dataVal == nil)
        return nil;

    if ((self = [super init]) != nil)
    {
        /* not enough data is represented by returning nil */
        if ([dataVal length] < sizeof(loopback_type))
            goto err;

        type = *(loopback_type*)[dataVal bytes];
    }
    return self;

err:
    [self dealloc];
    return nil;
}

- (void)setParent:(id<PPDecoderParent>)parentVal
{
    return;
}

- (size_t)frontSize
{
    return sizeof(loopback_type);
}

- (size_t)rearSize
{
    return 0;
}

- (Class)nextLayer
{
    switch (type)
    {
    /* AF_ defines are from sys/socket.h  */
    case AF_INET:
        return [IPV4Decode class];
        /* NOTREACHED */

    case AF_INET6:
        return [IPV6Decode class];
        /* NOTREACHED */

#ifdef __APPLE__
    case AF_PPP:
        return Nil; /* [PPPDecode class]*/
                    /* NOTREACHED */
#endif
    }
    return Nil;
}

+ (NSString*)shortName
{
    return @"Loopback";
}

+ (NSString*)longName
{
    return @"Null/Loopback";
}

- (NSString*)info
{
    return nil;
}

- (stacklev)level
{
    return SL_DATALINK;
}

/* ColumnIdentifier protocol methods */

+ (NSArray*)columnIdentifiers
{
    ColumnIdentifier* colIdent;
    NSArray* ret;

    colIdent = [[ColumnIdentifier alloc] initWithDecoder:[self class]
                                                   index:0
                                                longName:@"Protocol Type"
                                               shortName:@"Loopback Proto"];
    ret = [NSArray arrayWithObject:colIdent];
    [colIdent release];

    return ret;
}

- (NSString*)columnStringForIndex:(unsigned int)fieldIndex
{
    if (fieldIndex == 0)
        return [NSString stringWithFormat:@"0x%.8x", type];

    return nil;
}

- (NSComparisonResult)compareWith:(id)obj atIndex:(unsigned int)fieldIndex
{
    return val_compare(type, ((LoopbackDecode*)obj)->type);
}

/* OutlineViewItem protocol methods */

- (BOOL)expandable
{
    return YES;
}

- (size_t)numberOfChildren
{
    return 1;
}

- (id)childAtIndex:(int)fieldIndex
{
    OutlineViewItem* ret;
    NSString* str;

    ret = [[OutlineViewItem alloc] init];
    str = [[NSString alloc] initWithFormat:@"0x%.8x", type];

    [ret addObject:@"Protocol Type"];
    [ret addObject:str];

    [str release];
    return [ret autorelease];
}

- (size_t)numberOfValues
{
    return 1;
}

- (id)valueAtIndex:(int)anIndex
{
    return [[self class] longName];
}

/* NSCoding protocol methods */

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeValueOfObjCType:@encode(loopback_type) at:&type];
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super init]) != nil)
    {
        [coder decodeValueOfObjCType:@encode(loopback_type) at:&type];
    }
    return self;
}

@end
