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

#ifndef PPBPFPROGRAM_H_
#define PPBPFPROGRAM_H_

#import <Foundation/NSArchiver.h>
#include <net/bpf.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>

@class NSObject;
@protocol NSCoding;

@interface PPBPFProgram : NSObject <NSCoding>
{
    struct bpf_program m_program;
}

- (id)initWithProgram:(struct bpf_program*)program;
- (const struct bpf_program*)program;

@end

#endif
