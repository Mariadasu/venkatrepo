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
	CCSprite* mySprite;
	CCSprite* glowSprite;
	b2Body* b;
	IntegerNode* intNode;
	CCLabelTTF* label;
	bool isTouchEnabled_;
	float glowScale;
	
}
-(BOOL)active;
-(void)activate;
-(void)destroy;
+(id)bubbleWithPosition:(CGPoint)p value:(int)v;
-(id)initWithPosition:(CGPoint)p value:(int)v;
-(void) setIsTouchEnabled:(BOOL)enabled priority:(int)pr;
-(int)val;
@end
