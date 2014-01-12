//
//  Shot.m
//  SpaceCollector
//
//  Created by Zachary Reik on 6/10/13.
//
//

#import "Shot.h"
#import "GameLayer.h"
#import "Constants.h"

@interface Shot(){
    b2Body* _shotBody;
}

@end

@implementation Shot

-(id)initWithType:(NSInteger)type withWorld:(b2World*)world withPlayer:(Player*)player{
    if (self = [super init]){
        
        // type must match the dictionary heading names in shotType.plist in data folder
        self.shotType = type;
        NSString* strType = [self convertEnumToString:type];
        NSLog(@"self.shotType:%d", self.shotType);
        
        // get the plist and the NSDictionary for this type of shot
        NSString* path = [[NSBundle mainBundle] pathForResource:@"shotType" ofType:@"plist"];
        NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDictionary* thisShot = root[strType];
        
        // initialize variables
        NSString* spriteName = thisShot[@"sprite"];
        self.sprite = [CCSprite spriteWithFile:spriteName];
        self.sprite.position = ccp(player.weaponSprite.position.x, player.weaponSprite.position.y + player.weaponSprite.contentSize.height/2);
        self.damage = [thisShot[@"damage"] intValue];
        self.doesBounce = [thisShot[@"doesBounce"] boolValue];
        self.numBounces = [thisShot[@"numBounces"] intValue];
        self.shouldDelete = NO;
        self.colliding = NO;
        
        // create the box2d object
        b2BodyDef shotBodyDef;
        shotBodyDef.type = b2_dynamicBody;
        shotBodyDef.bullet = TRUE;
        shotBodyDef.position.Set(player.sprite.position.x/PTM_RATIO, player.sprite.position.y/PTM_RATIO - player.sprite.contentSize.height/6/PTM_RATIO);
        _shotBody = world->CreateBody(&shotBodyDef);
        _shotBody->SetGravityScale(0);
        
        
        b2FixtureDef shotFixDef;
        shotFixDef.density = 1.0f;
        shotFixDef.friction = 0.0f;
        shotFixDef.restitution = 1.0f;
        shotFixDef.userData = (void*) TAGS_PROJECTILE;
        shotFixDef.filter.categoryBits = PROJECTILE;
        shotFixDef.filter.maskBits = ENEMY | BOUNDARY;
        
        switch (self.shotType) {
            case LAZER:{
                b2PolygonShape poly;
                poly.SetAsBox(self.sprite.contentSize.width/2/PTM_RATIO, self.sprite.contentSize.height/2/PTM_RATIO);
                shotFixDef.shape = &poly;
            }
                break;
            case BOUNCER:{
                b2CircleShape circle;
                circle.m_radius = 8/PTM_RATIO;
                shotFixDef.shape = &circle;
            }
                break;
            case GRAVITY_BOMB:{
                b2CircleShape circle;
                circle.m_radius = 8/PTM_RATIO;
                shotFixDef.shape = &circle;
            }
                break;
            case MISSILE:{
                b2PolygonShape poly;
                poly.SetAsBox(self.sprite.contentSize.width/2/PTM_RATIO, self.sprite.contentSize.height/2/PTM_RATIO);
                shotFixDef.shape = &poly;
            }
                break;
            default:
                break;
        }
        
        _shotBody->CreateFixture(&shotFixDef);

    }
    return self;
}

-(NSString*)convertEnumToString:(NSInteger)i{
    NSString* result;
    switch (i) {
        case 0:
            result = @"bouncer";
            break;
        case 1:
            result = @"lazer";
            break;
        case 2:
            result = @"gravity_bomb";
            break;
        case 3:
            result = @"missile";
            break;
        default:
            break;
    }
    return result;
}

-(b2Body*) getBody{
    return _shotBody;
}

@end
