//
//  LaserBeam.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/13/13.
//
//

#import "LaserBeam.h"
#import "Box2D.h"
#import "GameLayer.h"

@interface LaserBeam(){
    b2Body* _laserBody;
    b2Body* _switchBody;
}

@end

@implementation LaserBeam

- (id)initWithDictionary:(NSDictionary *)dict withWorld:(b2World*)world{
    if (self = [super init]){
        self.isColliding = NO;
        self.isOn = YES;
        
        float x = [dict[@"x"] floatValue];
        float y = [dict[@"y"] floatValue];
        float width = [dict[@"width"] floatValue];
        float height = [dict[@"height"] floatValue];
        
        self.emitterTopSprite = [CCSprite spriteWithFile:@"laserEmitter.png"];
        self.emitterTopSprite.position = ccp(x, y);
        self.emitterTopSprite.rotation = 180;
        
        self.emitterBotSprite = [CCSprite spriteWithFile:@"laserEmitter.png"];
        self.emitterBotSprite.position = ccp(x, y + height);
        
        b2BodyDef laserBodyDef;
        laserBodyDef.type = b2_staticBody;
        laserBodyDef.position.Set(x/PTM_RATIO, (y + height/2)/PTM_RATIO);
        _laserBody = world->CreateBody(&laserBodyDef);
        _laserBody->SetGravityScale(0);
        
        b2PolygonShape polygon;
        polygon.SetAsBox(width/2/PTM_RATIO, height/2/PTM_RATIO);
        
        b2FixtureDef laserFixDef;
        laserFixDef.shape = &polygon;
        laserFixDef.filter.categoryBits = BOUNDARY;
        laserFixDef.filter.maskBits = ENEMY | PROJECTILE | SHIP;
        laserFixDef.userData = (void*)TAGS_LASER_BEAM;
        _laserBody->CreateFixture(&laserFixDef);
        
        //CCParticleSystemQuad* laserParticle = [CCParticleSystemQuad particleWithFile:@"laser0.plist"];
        CCParticleSystemQuad* laserParticle = [[CCParticleSystemQuad alloc] initWithTotalParticles:height*2];
        
        laserParticle.positionType = kCCPositionTypeGrouped;
        laserParticle.position = ccp(x, y);
        [laserParticle setSpeed:height/2];
        [laserParticle setLife:2];
        [laserParticle setStartSize:16];
        [laserParticle setEndSize:16];
        [laserParticle setEmitterMode:kCCParticleModeGravity];
        [laserParticle setAngle:90];
        [laserParticle setDuration:-1];
        [laserParticle setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA, GL_ONE}];
        [laserParticle setBlendAdditive:YES];
        [laserParticle setEmissionRate:height * 0.8];
        [laserParticle setStartColor:(ccColor4F){0.20, 0.20, 0.30, 1.0}];
        [laserParticle setEndColor:(ccColor4F){0.20, 0.20, 0.30, 1.0}];
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"smallYellowLazer.png"];
        [laserParticle setTexture:tex];
        
        self.laserParticle = laserParticle;

    }
    
    return self;
}

- (void)setSwitches:(NSDictionary*)dict withWorld:(b2World*)world{
    float x = [dict[@"x"] floatValue];
    float y = [dict[@"y"] floatValue];
    
    self.switchSprite = [CCSprite spriteWithFile:@"laserButtonOn.png"];
    self.switchSprite.position = ccp(x, y);
    
    b2BodyDef switchBodyDef;
    switchBodyDef.type = b2_staticBody;
    switchBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    _switchBody = world->CreateBody(&switchBodyDef);
    _switchBody->SetGravityScale(0);
    _switchBody->SetUserData((__bridge void*) self);
    
    b2PolygonShape polygon;
    polygon.SetAsBox(self.switchSprite.contentSize.width/2/PTM_RATIO, self.switchSprite.contentSize.height/2/PTM_RATIO);
    
    b2FixtureDef  switchFixDef;
    switchFixDef.shape = &polygon;
    switchFixDef.isSensor = YES;
    switchFixDef.userData = (void*) TAGS_LASER_SWITCH;
    _switchBody->CreateFixture(&switchFixDef);
}

- (void)toggleSwitch{
    self.isOn = !self.isOn;
    [self.switchSprite removeFromParentAndCleanup:YES];
    if (self.isOn){
        self.switchSprite = [CCSprite spriteWithFile:@"laserButtonOn.png"];
        b2Filter filter = _laserBody->GetFixtureList()->GetFilterData();
        filter.maskBits = ENEMY | PROJECTILE | SHIP;
        _laserBody->GetFixtureList()->SetFilterData(filter);
    } else {
        self.switchSprite = [CCSprite spriteWithFile:@"laserButtonOff.png"];
        b2Filter filter = _laserBody->GetFixtureList()->GetFilterData();
        filter.maskBits = NULL;
        _laserBody->GetFixtureList()->SetFilterData(filter);
    }
    self.switchSprite.position = ccp(_switchBody->GetPosition().x * PTM_RATIO, _switchBody->GetPosition().y * PTM_RATIO);
}

- (b2Body*)getLaserBody{
    return _laserBody;
}

- (b2Body*)getSwitchBody{
    return _switchBody;
}


@end
