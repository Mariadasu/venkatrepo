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
@synthesize radius;
@synthesize origin;
@synthesize value;

-(id)initWithPosition:(CGPoint)p waveHeight:(int)h decay:(float)d width:(int)w radius:(int)r value:(int)v
{
	self = [super init];
	if( self ) 
	{
        radius = 0;
        maxRadius = r;
        value = v;
		origin = p;
		height = h;
		decayRate = d;
		waveWidth = w;
		alive = YES;
	}
	
	return self;
}

+(id)waveWithPosition:(CGPoint)p waveHeight:(int)h decay:(float)d width:(int)w  radius:(int)r value:(int)v

{
	return [[[Wave alloc] initWithPosition:p waveHeight:h decay:d width:w radius:r value:v] autorelease];
}
-(void)update
{
	radius += 5;
	if (radius>maxRadius) 
    {
		alive = NO;
	}
	height *= decayRate;
}
-(float)heightAt:(CGPoint)p
{
	int pdist = (int)ccpDistance(p, origin);
	int distFromWave = ABS(pdist - radius);
	if (distFromWave < waveWidth) 
	{
		return height*((float)distFromWave/(float)waveWidth);
	}
	return 0;
}
@end

@implementation WavePool

@synthesize waves;

-(void)removeAllWaves
{
    [waves removeAllObjects];   
}
-(void)dealloc
{
    [waves release];
    [super dealloc];
}
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
-(void)addRippleAt:(CGPoint)p radius:(int)r val:(int)v
{
	[waves addObject:[Wave waveWithPosition:p waveHeight:20 decay:1.0f width:50 radius:r value:v]];

}
-(void)update:(ccTime)time
{
	
	NSMutableArray* discardedWaves = [NSMutableArray array];
	for (Wave* w in waves) 
	{
		[w update];
		if(![w alive])
		{
		//	NSLog(@"wave removed");
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
