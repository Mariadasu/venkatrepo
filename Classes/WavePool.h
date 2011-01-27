//
//  WavePool.h
//  BubbleBlitz
//
//  Created by Robert Backman on 1/22/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"


@interface Wave : NSObject
{
	CGPoint origin;
	float dist;
	float height;
	float decayRate;
	float waveWidth;
	bool alive;
} 
-(void)update;
-(id)initWithPosition:(CGPoint)p waveHeight:(float)h decay:(float)d width:(float)w;
+(id)waveWithPosition:(CGPoint)p waveHeight:(float)h decay:(float)d width:(float)w;
-(float)heightAt:(CGPoint)p;
@property(nonatomic,readonly)bool alive;

@end


@interface WavePool : CCGrid3DAction 
{
	NSMutableArray* waves;
	ccGridSize gridSize;
	CCSprite* image;
}

+(id)poolWithImage:(CCSprite*)sprite size:(ccGridSize)gSize;
-(id)initWithImage:(CCSprite*)sprite size:(ccGridSize)gSize;
-(void)update:(ccTime)time;
-(void)addRippleAt:(CGPoint)p;
@end
