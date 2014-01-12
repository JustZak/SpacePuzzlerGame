//
//  Portal.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/11/13.
//
//

#import "Portal.h"
#import "GameLayer.h"

@interface Portal(){
    b2Body* _portalBody;
}

@end

@implementation Portal

-(b2Body*)getBody{
    return _portalBody;
}

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)pos withOrientation:(NSInteger)orientation with2ndPosition:(b2Vec2)pos2{
    if (self = [super init]){
        self.sprite = [CCSprite spriteWithFile:@"portalBlue.png"];
        self.sprite2 = [CCSprite spriteWithFile:@"portalBlue.png"];
        float x;
        float y;
        float x2;
        float y2;
        
        switch (orientation) {
            case LEFT:
               // x = pos.x +
                break;
                
            default:
                break;
        }
        self.sprite.position = ccp((pos.x )* PTM_RATIO, pos.y * PTM_RATIO);
        
        
        self.sprite2.position = ccp(pos2.x * PTM_RATIO, pos2.y * PTM_RATIO);
        
        b2BodyDef portalBodyDef;
        portalBodyDef.type = b2_staticBody;
        portalBodyDef.position.Set(pos.x, pos.y);
        _portalBody = world->CreateBody(&portalBodyDef);
        _portalBody->SetGravityScale(0);
        
        b2FixtureDef portalFixDef;
        b2PolygonShape poly;
        
        int num = 13;
        b2Vec2 verts[] = {
            b2Vec2(-0.7f / PTM_RATIO, 39.8f / PTM_RATIO),
            b2Vec2(-9.7f / PTM_RATIO, 33.9f / PTM_RATIO),
            b2Vec2(-13.1f / PTM_RATIO, 19.4f / PTM_RATIO),
            b2Vec2(-13.3f / PTM_RATIO, -8.3f / PTM_RATIO),
            b2Vec2(-10.1f / PTM_RATIO, -26.9f / PTM_RATIO),
            b2Vec2(-6.4f / PTM_RATIO, -35.7f / PTM_RATIO),
            b2Vec2(-0.4f / PTM_RATIO, -39.2f / PTM_RATIO),
            b2Vec2(7.6f / PTM_RATIO, -39.1f / PTM_RATIO),
            b2Vec2(12.0f / PTM_RATIO, -29.3f / PTM_RATIO),
            b2Vec2(13.1f / PTM_RATIO, -23.5f / PTM_RATIO),
            b2Vec2(13.1f / PTM_RATIO, 21.4f / PTM_RATIO),
            b2Vec2(10.3f / PTM_RATIO, 32.7f / PTM_RATIO),
            b2Vec2(5.3f / PTM_RATIO, 39.1f / PTM_RATIO)
        };
        poly.Set(verts, num);
        
        portalFixDef.shape = &poly;
        portalFixDef.isSensor = YES;
        portalFixDef.filter.categoryBits = BOUNDARY;
        portalFixDef.filter.maskBits = ENEMY;
        portalFixDef.userData = (void*)TAGS_PORTAL;
        _portalBody->CreateFixture(&portalFixDef);
    }
    
    return self;
}


@end
