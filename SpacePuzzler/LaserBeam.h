//
//  LaserBeam.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/13/13.
//
//

#import "GameObject.h"

@interface LaserBeam : GameObject

@property (assign) BOOL isColliding;
@property (assign) BOOL isOn;
@property (strong) CCSprite* emitterTopSprite;
@property (strong) CCSprite* emitterBotSprite;
@property (strong) CCSprite* switchSprite;
@property (strong) CCParticleSystemQuad* laserParticle;

- (id)initWithDictionary:(NSDictionary*)dict withWorld:(b2World*)world;
- (b2Body*)getLaserBody;
- (b2Body*)getSwitchBody;
- (void)setSwitches:(NSDictionary*)dict withWorld:(b2World*)world;
- (void)toggleSwitch;

@end
