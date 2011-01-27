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

// HelloWorld Layer
@interface GameScene : CCLayer
{
	bool first;
	CCSprite* background;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	CGSize screenSize;
	int maxBubbles;
	WavePool* waves;
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
@end
