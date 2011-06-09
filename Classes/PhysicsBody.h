//
//  PhysicsBody.h
//  BubbleBlitz
//
//  Created by Robert Backman on 6/7/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface PhysicsBody : NSObject 
{
    CCSprite* sprite;
    b2Body* b;
}

-(id)initWithPosition:(CGPoint)p;
+(id)bodyWithPosition:(CGPoint)p;
-(CGPoint)getPosition;
-(void)update;
-(void)addForce:(CGPoint)f;


@property(nonatomic,readonly) CCSprite* sprite;
@property(nonatomic,readonly) b2Body* b;

@end
