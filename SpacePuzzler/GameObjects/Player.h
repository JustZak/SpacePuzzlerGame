//
//  Player.h
//  SpaceCollector
//
//  Created by Zachary Reik on 6/7/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "Shot.h"
#import "Box2D.h"

@interface Player : GameObject

@property (strong) CCSprite* weaponSprite;
@property (strong) CCParticleSystemQuad* engineEffect;
@property (assign) NSInteger shotsRemaining;
@property (assign) NSInteger lifeRemaining;
@property (assign) NSInteger maxLife;
@property (assign) NSInteger weapon;

-(id)initWithWorld:(b2World*)world;
-(id)initWithWorld:(b2World*)world withDict:(NSDictionary*)dict;
-(b2Body*)getBody;

@end
