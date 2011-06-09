//
//  PhysicsBody.m
//  BubbleBlitz
//
//  Created by Robert Backman on 6/7/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "PhysicsBody.h"
#import "GameScene.h"

@implementation PhysicsBody
@synthesize  sprite;
@synthesize b;

-(void)dealloc
{
     [[GameScene scene] world]->DestroyBody(b);
    
    [super dealloc];
}

+(id)bodyWithPosition:(CGPoint)p
{
   return  [[[PhysicsBody alloc] initWithPosition:p] autorelease];
}

-(void)addForce:(CGPoint)f
{
    b->ApplyForce(b2Vec2(f.x, f.y), b->GetPosition());
}
-(id)initWithPosition:(CGPoint)p
{
    if( (self=[super init])) {
        
    sprite = [CCSprite spriteWithFile:@"Bubble.png"];
    sprite.position=p;
   [sprite setScale:0.5f];
    
    // Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b = [[GameScene scene] world]->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = 32/PTM_RATIO;
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.0f;
	fixtureDef.restitution = 0.05f;
	
	b->CreateFixture(&fixtureDef);
    }
    return self;
}
-(CGPoint)getPosition
{
    return CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
}
-(void)update
{
    sprite.position = [self getPosition];
}

@end
