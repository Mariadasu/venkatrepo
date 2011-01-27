//
//  WavePool.mm
//  BubbleBlitz
//
//  Created by Robert Backman on 1/22/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "WavePool.h"


@implementation Wave
@synthesize alive;

-(id)initWithPosition:(CGPoint)p waveHeight:(float)h decay:(float)d width:(float)w
{
	self = [super init];
	if( self ) 
	{
		origin = p;
		dist = 0;
		height = h;
		decayRate = d;
		waveWidth = w;
		alive = YES;
	}
	
	return self;
}
+(id)waveWithPosition:(CGPoint)p waveHeight:(float)h decay:(float)d width:(float)w
{
	return [[[Wave alloc] initWithPosition:p waveHeight:h decay:d width:w] autorelease];
}
-(void)update
{
	dist += 5;
	if (dist>2048) {
		alive = NO;
	}
	height *= decayRate;
}
-(float)heightAt:(CGPoint)p
{
	float pdist = ccpDistance(p, origin);
	float distFromWave = ABS(pdist - dist);
	if (distFromWave < waveWidth) 
	{
		return height*(distFromWave/waveWidth);
	}
	return 0;
}
@end

@implementation WavePool

+(id)poolWithImage:(CCSprite*) sprite size:(ccGridSize)gSize
{
	return [[ [WavePool alloc] initWithImage:sprite size:gSize] autorelease];
}
-(id)initWithImage:(CCSprite*)sprite size:(ccGridSize)gSize
{
	self = [super initWithSize:gSize duration:50000];
	if( self ) 
	{
		gridSize = gSize;
		image = sprite;
		waves = [[NSMutableArray alloc] init];
	}
	
	return self;
}
-(void)addRippleAt:(CGPoint)p
{
	[waves addObject:[Wave waveWithPosition:p waveHeight:20 decay:1.0f width:50]];
}
-(void)update:(ccTime)time
{
	
	NSMutableArray* discardedWaves = [NSMutableArray array];
	for (Wave* w in waves) 
	{
		[w update];
		if(![w alive])
		{
			NSLog(@"wave removed");
			[discardedWaves addObject:w];
		}
	}
	[waves removeObjectsInArray:discardedWaves];
	
	 int i, j;
	for( i = 0; i < (gridSize_.x+1); i++ )
	{
		for( j = 0; j < (gridSize_.y+1); j++ )
		{
			ccVertex3F	v = [self originalVertex:ccg(i,j)];
			float h = 0;
			for (Wave* w in waves) 
			{
				h += [w heightAt:ccp(v.x,v.y)];
			}
			v.z += h;
			[self setVertex:ccg(i,j) vertex:v];
		}
	}
	
}


@end
