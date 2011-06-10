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
	int radius;
	int height;
    int waveWidth;
    int maxRadius; //this is the maximum size of the ripple
    int value;  //this is the value of the object that made the ripple.. 
    
	float decayRate;
	bool alive;
} 
-(void)update;
-(id)initWithPosition:(CGPoint)p waveHeight:(int)h decay:(float)d width:(int)w  radius:(int)r value:(int)v;
+(id)waveWithPosition:(CGPoint)p waveHeight:(int)h decay:(float)d width:(int)w  radius:(int)r value:(int)v;
-(float)heightAt:(CGPoint)p;
@property(nonatomic,readonly)bool alive;
@property(nonatomic,readonly)int radius;
@property(nonatomic,readonly)CGPoint origin;
@property(nonatomic,readonly)int value;
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
-(void)addRippleAt:(CGPoint)p radius:(int)r val:(int)v;
-(void)removeAllWaves;
@property(nonatomic,readonly)NSMutableArray* waves;
@end
