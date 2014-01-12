//
//  Wall.m
//  SpaceCollector
//
//  Created by Zachary Reik on 6/12/13.
//
//

#import "Wall.h"
#import "GameLayer.h"
#import "Box2D.h"
#import "Constants.h"

@interface Wall(){
    b2Body* _wallBody;
}

@end

@implementation Wall

-(id)initWithType:(NSString*)wallType withObjectGroup:(CCTMXObjectGroup*)walls withWorld:(b2World*)world withWallNum:(NSInteger)wallNum{
    if (self = [super init]){
        self.type = wallType;
        
        NSString *wallString = [NSString stringWithFormat: @"wall%d", wallNum];
        NSDictionary *wallObjectDict = [walls objectNamed:wallString];
        float x = [wallObjectDict[@"x"] floatValue];
        float y = [wallObjectDict[@"y"] floatValue];
        self.height = [wallObjectDict[@"height"] floatValue];
        self.width = [wallObjectDict[@"width"] floatValue];
        
        b2BodyDef wallBodyDef;
        wallBodyDef.type = b2_staticBody;
        wallBodyDef.position.Set((x + self.width/2)/PTM_RATIO, (y + self.height/2)/PTM_RATIO);
        wallBodyDef.userData = (__bridge void*)self;
        _wallBody = world->CreateBody(&wallBodyDef);
        
        b2PolygonShape wallBox;
        b2FixtureDef wallFixDef;
        wallFixDef.shape = &wallBox;
        wallFixDef.friction = 100;
        wallFixDef.density = 10;
        wallFixDef.restitution = 0.4;
        wallFixDef.filter.categoryBits = BOUNDARY;
        wallFixDef.filter.maskBits = ENEMY | PROJECTILE | PLAYER_SHIP;
        wallFixDef.userData = (void*)TAGS_WALL;
        
        b2Vec2 center = b2Vec2(0, 0);
        wallBox.SetAsBox((self.width/PTM_RATIO) /2, (self.height/PTM_RATIO) /2, center, 0);
        _wallBody->CreateFixture(&wallFixDef);
    }
    
    return self;
}

-(b2Body*)getWallBody{
    return _wallBody;
}

@end
