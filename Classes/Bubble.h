//
//  Bubble.h
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "IntegerNode.h"

@interface Bubble : CCNode <CCTargetedTouchDelegate, NSCoding>
{
	    
	CCSprite* glowSprite;
	
    NSMutableArray* bodies;

    
    bool alive;
	IntegerNode* intNode;
	CCLabelTTF* label;
	bool isTouchEnabled_;
	float glowScale;
	CGPoint centroid;
}

-(BOOL)active;
-(void)calculateCentroid;
-(void)activate;
-(void)destroy;
+(id)bubbleWithPosition:(CGPoint)p value:(int)v;
-(id)initWithPosition:(CGPoint)p value:(int)v;
-(void) update: (ccTime) dt;
-(void) setIsTouchEnabled:(BOOL)enabled priority:(int)pr;
-(void)addForce:(CGPoint)f;
-(int)val;
-(CGPoint)getPosition;
@property(nonatomic,readonly)bool alive;
@end
