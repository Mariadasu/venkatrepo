//
//  PhysicsBody.m
//  BubbleBlitz
//
//  Created by Robert Backman on 6/7/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "Bubble.h"
#import "GameScene.h"

@implementation Bubble
@synthesize  sprite;
@synthesize b;
@synthesize radius;

-(void)dealloc
{
     [[GameScene scene] world]->DestroyBody(b);
    
    [super dealloc];
}

+(id)bubbleWithPosition:(CGPoint)p color:(int)col val:(int)v
{
   return  [[[Bubble alloc] initWithPosition:p color:col val:v] autorelease];
}

-(void)addForce:(CGPoint)f
{
    b->ApplyForce(b2Vec2(f.x, f.y), b->GetPosition());
}
-(id)initWithPosition:(CGPoint)p color:(int)col val:(int)v
{
    if( (self=[super init])) {
        val = v;
        
        switch (col) {
            case RED_BUBBLE:
                sprite = [CCSprite spriteWithFile:@"RedBubble.png"];
            break;
            case BLUE_BUBBLE:
            default:
                sprite = [CCSprite spriteWithFile:@"BlueBubble.png"];
            break;
        }
    radius = val*[sprite contentSize].width/3.0f;
    sprite.position=p;
    
    
    // Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b = [[GameScene scene] world]->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2CircleShape dynamicCircle;
      

    [sprite setScale:0.75f*val];   
    dynamicCircle.m_radius = radius/PTM_RATIO;  
        
        
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
-(CGPoint)position
{
    return CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
}
-(void)update
{
    sprite.position = [self position];
}

@end
