//
//  GravityBomb.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/27/13.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"

@interface GravityBomb : NSObject

@property (strong) CCParticleSystemQuad* gravParticle;

-(b2Body*)getBody;
-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)pos;

@end
