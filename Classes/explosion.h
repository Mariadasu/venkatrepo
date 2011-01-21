//
//  explosion.h
//  SolAPG
//
//  Created by Robert Backman on 10/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"

//! An explosion particle system
@interface BlockExplosion : ARCH_OPTIMAL_PARTICLE_SYSTEM
{
}
-(id)initAtPosition:(CGPoint)p;

+(id)explosionAtPosition:(CGPoint)p ;

@end



@interface RingExplosion : ARCH_OPTIMAL_PARTICLE_SYSTEM
{
}
-(id)initAtPosition:(CGPoint)p;

+(id)explosionAtPosition:(CGPoint)p ;

@end
