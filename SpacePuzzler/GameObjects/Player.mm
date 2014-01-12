//
//  Player.m
//  SpaceCollector
//
//  Created by Zachary Reik on 6/7/13.
//
//

#import "Player.h"
#import "cocos2d.h"
#import "GameLayer.h"
#import "Constants.h"

@interface Player(){
    b2Body* _playerBody;
}

@end

@implementation Player

-(id)initWithWorld:(b2World*)world{
    if (self = [super init]){
        self.shotsRemaining = 10;
        self.lifeRemaining = 2;
        self.maxLife = 2;
        self.weapon = MISSILE;
        self.sprite = [CCSprite spriteWithFile:@"player.png"];
        self.engineEffect = [CCParticleSystemQuad particleWithFile:@"engine.plist"];
        self.engineEffect.positionType = kCCPositionTypeGrouped;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float x = winSize.width/2;
        float y = 128 + self.sprite.contentSize.height/2;
        
        self.sprite.position = ccp(x, y);
        self.weaponSprite = [CCSprite spriteWithFile:@"weapon.png"];
        self.weaponSprite.position = ccp(self.sprite.contentSize.width/2, self.sprite.contentSize.height/3);
        [self.sprite addChild:self.weaponSprite z:11];
        
        // create the player's physics object
        
        b2BodyDef playerBodyDef;
        playerBodyDef.type = b2_dynamicBody;
        playerBodyDef.position.Set(x/PTM_RATIO , y/PTM_RATIO);
        _playerBody = world->CreateBody(&playerBodyDef);
        _playerBody->SetGravityScale(0);
        
        b2PolygonShape polygon;
        polygon.SetAsBox(self.sprite.contentSize.width/2/PTM_RATIO, self.sprite.contentSize.height/2/PTM_RATIO);
        
        b2FixtureDef playerFixDef;
        playerFixDef.shape = &polygon;
        playerFixDef.density = 10.0f;
        playerFixDef.friction = 0.5f;
        playerFixDef.restitution = 0.2f;
        playerFixDef.userData = (void*) TAGS_PLAYER;
        playerFixDef.filter.categoryBits = PLAYER_SHIP;
        playerFixDef.filter.maskBits = BOUNDARY;
        _playerBody->CreateFixture(&playerFixDef);
    }
    
    return self;

}

-(id)initWithWorld:(b2World*)world withDict:(NSDictionary*)dict{
    if (self = [super init]){
        self.shotsRemaining = 10;
        self.lifeRemaining = 2;
        self.maxLife = 2;
        self.weapon = MISSILE;
        self.sprite = [CCSprite spriteWithFile:@"player.png"];
        self.engineEffect = [CCParticleSystemQuad particleWithFile:@"engine.plist"];
        self.engineEffect.positionType = kCCPositionTypeGrouped;
        
        float x = [dict[@"x"] floatValue];
        float y = [dict[@"y"] floatValue];
        float width = [dict[@"width"] floatValue];
        float height = [dict[@"height"] floatValue];
        
        self.sprite.position = ccp(x + width/2, y + height/2);
        self.weaponSprite = [CCSprite spriteWithFile:@"weapon.png"];
        self.weaponSprite.position = ccp(self.sprite.contentSize.width/2, self.sprite.contentSize.height/3);
        [self.sprite addChild:self.weaponSprite z:11];
        
        // create the player's physics object
        
        b2BodyDef playerBodyDef;
        playerBodyDef.type = b2_dynamicBody;
        playerBodyDef.position.Set((x + width/2)/PTM_RATIO, (y + height/2)/PTM_RATIO);
        _playerBody = world->CreateBody(&playerBodyDef);
        _playerBody->SetGravityScale(0);
        
        b2PolygonShape polygon;
        polygon.SetAsBox(self.sprite.contentSize.width/2/PTM_RATIO, self.sprite.contentSize.height/2/PTM_RATIO);
        
        b2FixtureDef playerFixDef;
        playerFixDef.shape = &polygon;
        playerFixDef.density = 10.0f;
        playerFixDef.friction = 0.5f;
        playerFixDef.restitution = 0.2f;
        playerFixDef.userData = (void*) TAGS_PLAYER;
        playerFixDef.filter.categoryBits = PLAYER_SHIP;
        playerFixDef.filter.maskBits = BOUNDARY;
        _playerBody->CreateFixture(&playerFixDef);
    }
    
    return self;
}

-(b2Body*)getBody{
    return _playerBody;
}

@end
