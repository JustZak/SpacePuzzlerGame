//
//  GravityBomb.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/27/13.
//
//

#import "GravityBomb.h"
#import "GameLayer.h"

@interface GravityBomb(){
    b2Body* _gravityBody;
}

@end

@implementation GravityBomb

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)pos{
    if (self = [super init]){
        b2BodyDef gravBodyDef;
        gravBodyDef.type = b2_staticBody;
        gravBodyDef.position.Set(pos.x, pos.y);
        _gravityBody = world->CreateBody(&gravBodyDef);
        _gravityBody->SetGravityScale(0);
        
        b2FixtureDef gravFixDef;
        b2CircleShape circle;
        circle.m_radius = 200/PTM_RATIO;
        
        gravFixDef.shape = &circle;
        gravFixDef.isSensor = YES;
        gravFixDef.filter.categoryBits = BOUNDARY;
        gravFixDef.filter.maskBits = ENEMY;
        gravFixDef.userData = (void*)TAGS_GRAVITY_BOMB;
        _gravityBody->CreateFixture(&gravFixDef);
        
        self.gravParticle = [CCParticleSystemQuad particleWithFile:@"gravityBomb.plist"];
        self.gravParticle.position = ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO);

    }
    
    return self;
}

-(b2Body*)getBody{
    return _gravityBody;
}

@end
