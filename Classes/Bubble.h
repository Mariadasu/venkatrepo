//
//  PhysicsBody.h
//  BubbleBlitz
//
//  Created by Robert Backman on 6/7/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

enum bubble_colors
{
  RED_BUBBLE,
  BLUE_BUBBLE
};

@interface Bubble : NSObject 
{
    CCSprite* sprite;
    b2Body* b;
    int val; 
    float radius;
}

-(id)initWithPosition:(CGPoint)p color:(int)col val:(int)v;
+(id)bubbleWithPosition:(CGPoint)p color:(int)col val:(int)v;
-(CGPoint)position;
-(void)update;
-(void)addForce:(CGPoint)f;


@property(nonatomic,readonly)float radius;
@property(nonatomic,readonly) CCSprite* sprite;
@property(nonatomic,readonly) b2Body* b;

@end
