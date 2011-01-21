//
//  explosion.mm
//  SolAPG
//
//  Created by Robert Backman on 10/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "explosion.h"


@implementation BlockExplosion

+(id) explosionAtPosition:(CGPoint)p 
{
	return [[[BlockExplosion alloc] initAtPosition:p] autorelease];
}

-(id)initAtPosition:(CGPoint)p;
{
	self= [super initWithTotalParticles:100];
	if( self ) 
	{
		
		//positionType = kCCPositionTypeFree;
		
		self.positionType = kCCPositionTypeGrouped;
		
		// duration
		duration = 0.03f;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
		
		// Gravity Mode: speed of particles
		self.speed = 110;
		self.speedVar = 230;
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// angle
		angle = 90;
		angleVar = 360;
		
		// emitter position
		self.position = p;
		posVar = CGPointZero;
		
		// life of particles
		life = 0.0;
		lifeVar = 0.7;
		
		// size, in pixels
		startSize = 26.0f;
		startSizeVar = 20.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
		
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
		startColor.r = 0.9f;
		startColor.g = 0.5f;
		startColor.b = 0.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.0f;
		endColor.r = 0.5f;
		endColor.g = 0.2f;
		endColor.b = 0.2f;
		endColor.a = 0.3f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"smoke.png"];
		
		// additive
		self.blendAdditive = YES; //NO;
	}
	
	return self;
}


@end


@implementation RingExplosion

+(id) explosionAtPosition:(CGPoint)p 
{
	return [[[RingExplosion alloc] initAtPosition:p] autorelease];
}

-(id)initAtPosition:(CGPoint)p;
{
	self= [super initWithTotalParticles:200];
	if( self ) 
	{
		
		//positionType = kCCPositionTypeFree;
		
		self.positionType = kCCPositionTypeGrouped;
		
		// duration
		duration = 0.01f;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
		
		// Gravity Mode: speed of particles
		self.speed = 240;
		self.speedVar = 1;
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// angle
		angle = 90;
		angleVar = 360;
		
		// emitter position
		self.position = p;
		posVar = CGPointZero;
		
		// life of particles
		life = 0.0;
		lifeVar = 1.118;
		
		// size, in pixels
		startSize = 34.0f;
		startSizeVar = 38.0f;
		endSize = 14; //kCCParticleStartSizeEqualToEndSize;
		
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
		startColor.r = 0.9f;
		startColor.g = 0.5f;
		startColor.b = 0.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.0f;
		endColor.r = 0.5f;
		endColor.g = 0.2f;
		endColor.b = 0.2f;
		endColor.a = 0.3f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"smoke.png"];
		
		// additive
		self.blendAdditive = YES; //NO;
	}
	
	return self;
}


@end
