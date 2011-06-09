//
//  HelloWorldScene.h
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

@class Bubble;
@class WavePool;
@class SoundLayer;
// HelloWorld Layer
@interface GameScene : CCLayer
{
    SoundLayer* sound;
    
	int difficulty;
	bool first;
	CCSprite* background;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	CGSize screenSize;
	int maxBubbles;
	WavePool* waves;
	bool addition;
	bool subtraction;
	bool multiplication;
	bool remainder;
	bool division;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void)addBubble;
-(void) addBubbleAtPosition:(CGPoint)p value:(int)v;
-(void)newGame;
-(CCArray*)bubbles;
-(int)numBubbles;
-(Bubble*)getBubble:(int)i;
-(int)getBubbleValue:(int)i;
-(void)addRippleAt:(CGPoint)p;
@property (nonatomic,readonly) b2World* world;
@property (nonatomic,readwrite)int difficulty;
@property (nonatomic,readwrite)bool addition;
@property (nonatomic,readwrite)bool subtraction;
@property (nonatomic,readwrite)bool multiplication;
@property (nonatomic,readwrite)bool remainder;
@property (nonatomic,readwrite)bool division;
@end
