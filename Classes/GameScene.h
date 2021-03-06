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
#import "GameConfig.h"
#import "GameLogic.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

//static int OUTMASK = 0xFF;


@class MatchObject;
@class WavePool;
@class SoundLayer;
// HelloWorld Layer
@interface GameScene : CCLayer
{
    SoundLayer* sound;
    int level;
	int difficulty;
	bool first;
	CCSprite* background;
   
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	CGSize screenSize;
	int maxMatchObjects;
    int minMatches;
    
	WavePool* waves;
    bool symbols;
	bool addition;
	bool subtraction;
	bool multiplication;
	bool remainder;
	bool division;
    bool fraction;
    
    float levelUpScale;
    bool levelUp;
    CCLabelTTF* levelUpLabel; 
    CCLabelTTF* scoreLabel;
    int score;
    
    CCArray* selectedObjects;
}

// returns a singelton instance of the GameScene if it hasnt been created then it will make one
//so any object can access the GameScene by importing "GameScene.h" and calling [GameScene scene] .. ex [[GameScene scene] addition];
+(id) scene;

-(void)objectPressed:(MatchObject*)obj;
-(void)objectReleased:(MatchObject*)obj;

// adds a new sprite at a given coordinate
-(void)addMatchObject:(CGPoint)p;

-(void)addRippleAt:(CGPoint)position radius:(int)r value:(int)v;
-(void)addBonusLabelAt:(CGPoint)p value:(int)v;


-(CCArray*)MatchObjects;
-(int)numMatchObjects;
-(MatchObject*)getMatchObject:(int)i;
-(int)getMatchObjectValue:(int)i;
-(void)removeAllMatchObjects;
-(void)removeMatchObject:(MatchObject*)m;
-(void)setDifficulty:(int)dif;
-(void)setLevel:(int)lev;

/*
+(int)genNum;
+(int)getVal:(int)i;
+(int)getValExprOp:(int)i expr:(NSString**)str op:(operators*)op;
+(NSString*)getExpr:(int)i mode:(int)m;
+(operators)getOp:(int)i; 
*/

@property (nonatomic,readonly) SoundLayer* sound;
@property (nonatomic,readonly) b2World* world;

@property(nonatomic,readwrite)int score;
@property (nonatomic,readonly)int difficulty;
@property (nonatomic,readwrite)bool addition;
@property (nonatomic,readwrite)bool subtraction;
@property (nonatomic,readwrite)bool multiplication;
@property (nonatomic,readwrite)bool remainder;
@property (nonatomic,readwrite)bool division;
@property (nonatomic,readwrite)bool symbols;
@property (nonatomic,readwrite)bool fraction;
@end
