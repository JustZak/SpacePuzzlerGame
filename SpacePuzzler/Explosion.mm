//
//  Explosion.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 7/20/13.
//
//

#import "Explosion.h"
#import "GameLayer.h"

@implementation Explosion

-(id)initWithWorld:(b2World*)world withCenter:(b2Vec2)center explosionType:(NSString*)type {
    if (self = [super init]){
        NSString* path = [[NSBundle mainBundle] pathForResource:@"explosions" ofType:@"plist"];
        NSDictionary* rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDictionary* explosionDict = rootDict[type];
        NSInteger lifespan = [explosionDict[@"lifespan"] integerValue];
        NSInteger density = [explosionDict[@"lifespan"] integerValue];
        NSInteger numRays = [explosionDict[@"lifespan"] integerValue];
        NSInteger blastPower = [explosionDict[@"lifespan"] integerValue];
        
        self.length = lifespan;
        self.explosionBodies = [NSMutableArray array];
        NSValue* point;
        for (int i = 0; i < numRays; i++) {
            float angle = (i / (float)numRays) * 360 * M_PI / 180;
            b2Vec2 rayDir( sinf(angle), cosf(angle) );
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            bodyDef.fixedRotation = true; // rotation not necessary
            bodyDef.bullet = true; // prevent tunneling at high speed
            bodyDef.linearDamping = 10; // drag due to moving through air
            bodyDef.gravityScale = 0; // ignore gravity
            bodyDef.position = center; // start at blast center
            bodyDef.linearVelocity = blastPower * rayDir;
            b2Body* body = world->CreateBody(&bodyDef);
            
            b2CircleShape circleShape;
            circleShape.m_radius = 0.2; // very small
            
            b2FixtureDef fixDef;
            fixDef.filter.categoryBits = PROJECTILE;
            fixDef.filter.maskBits = ENEMY | BOUNDARY;
            fixDef.shape = &circleShape;
            fixDef.density = density / (float)numRays; // very high - shared across all particles
            fixDef.friction = 0; // friction not necessary
            fixDef.restitution = 0.99f; // high restitution to reflect off obstacles
            fixDef.filter.groupIndex = -1; // particles should not collide with each other
            body->CreateFixture(&fixDef);
            point = [NSValue valueWithPointer:body];
            [self.explosionBodies addObject:point];
        }
    }
    
    return self;
}

@end
