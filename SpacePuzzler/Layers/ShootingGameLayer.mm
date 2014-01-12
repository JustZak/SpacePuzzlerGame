//
//  ShootingGameLayer.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 10/21/13.
//
//

#import "ShootingGameLayer.h"
#import "Player.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "CCParallaxNode-Extras.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "BoxDebugLayer.h"
#import "Shot.h"
#import "GravityBomb.h"
#import "RootViewController.h"

@interface ShootingGameLayer(){
    NSInteger _score;
    
    RootViewController* _rootViewController;
    NSMutableDictionary* _spriteSheets;
    MyContactListener* _contactListener;
    
    b2World *_world;
    Player* _player;
    NSMutableArray* _projectiles;
    
    NSMutableArray* _backgroundObjects;
    CCParallaxNode* _backgroundNode;
    NSInteger _parallaxTopY;
    
    NSInteger _playerMovement;
}

@end

@implementation ShootingGameLayer

+ (id) scene:(RootViewController *)rootViewController{
    CCScene *scene = [CCScene node];
    
    ShootingGameLayer *layer = [[ShootingGameLayer alloc] initWithRootViewController:rootViewController];
    [scene addChild:layer];
    
    return scene;
}

-(id)initWithRootViewController:(RootViewController *)rootViewController{
    
    if (self = [super init]) {
        self.isTouchEnabled = YES;
        _playerMovement = STOPPED;
        _score = 0;
        _rootViewController = rootViewController;
        
        b2Vec2 gravity = b2Vec2(0.0f, -5.0f);
        _world = new b2World(gravity);
        
        [self loadWalls];
        [self loadPlayer];
        [self loadParallaxBG];
        
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        [self schedule:@selector(tick:)];
        
        // *************** DEBUG *************
        
        [self addChild:[BoxDebugLayer debugLayerWithWorld:_world ptmRatio:PTM_RATIO] z:10000];
    }
    
    return self;
}

- (void)tick:(ccTime) dt {
    // Parallax Scrolling updating
    
    CGPoint backgroundScrollVel = ccp(0, -1000);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    
    for (CCSprite *background in _backgroundObjects) {
        if ([_backgroundNode convertToWorldSpace:background.position].y < -background.contentSize.height) {
            [_backgroundNode incrementOffset:ccp(0, _parallaxTopY) forChild:background];
        }
    }
    
    // ************   Step the physics   ***********
    
    _world->Step(dt, 10, 10);
    
    
    // ************    update sprite positions    ***********
    
    b2Body* playerBody = [_player getBody];
    
    _player.sprite.position = ccp(playerBody->GetPosition().x * PTM_RATIO, playerBody->GetPosition().y * PTM_RATIO);
    _player.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(playerBody->GetAngle());
    
    // ************   Move player   **************
    
    if (_playerMovement < 3){
        switch (_playerMovement) {
            case LEFT:
            {
                [_player getBody]->SetLinearVelocity(b2Vec2(-15, 0));
            }
                break;
            case RIGHT:
            {
                [_player getBody]->SetLinearVelocity(b2Vec2(15, 0));
            }
                break;
            case STOPPING:
            {
                b2Body* playerBody = [_player getBody];
                float x = playerBody->GetLinearVelocity().x;
                float desiredVel = -(x * 0.25);
                float impulse = playerBody->GetMass() * desiredVel;
                playerBody->ApplyLinearImpulse( b2Vec2(impulse,0), playerBody->GetWorldCenter());
            }
                break;
            default:
                break;
        }
    }

}

- (void)loadWalls{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    b2BodyDef wallBodyDef;
    wallBodyDef.type = b2_staticBody;
    wallBodyDef.position.Set(0, 0);
    
    b2Body* wallBody = _world->CreateBody(&wallBodyDef);
    b2EdgeShape bottomEdge;
    bottomEdge.Set(b2Vec2(0, 0), b2Vec2(winSize.width/PTM_RATIO, 0));
    
    b2FixtureDef wallFixDef;
    wallFixDef.shape = &bottomEdge;
    wallFixDef.filter.categoryBits = BOUNDARY;
    wallFixDef.filter.maskBits = PLAYER_SHIP;
    wallBody->CreateFixture(&wallFixDef);
    
    bottomEdge.Set(b2Vec2(0, 0), b2Vec2(0, winSize.height/PTM_RATIO));
    wallBody->CreateFixture(&wallFixDef);
    
    bottomEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    wallBody->CreateFixture(&wallFixDef);
    
    bottomEdge.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
    wallBody->CreateFixture(&wallFixDef);
    
}

- (void)loadPlayer{
    _player = [[Player alloc] initWithWorld:_world];
    [self addChild: _player.sprite z:10];
}

- (void)loadParallaxBG{
    _backgroundObjects = [NSMutableArray array];
    _backgroundNode = [CCParallaxNode node];
    [self addChild:_backgroundNode z:-1];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"parallaxBGs" ofType:@"plist"];
    NSDictionary* rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary* levelDict = rootDict[@"level0"];
    NSInteger numChildren = [levelDict[@"numChildren"] integerValue];
    CGFloat speed = [levelDict[@"bgSpeed"] floatValue];
    CGPoint bgSpeed = ccp(speed, speed);
    _parallaxTopY = [levelDict[@"yReset"] integerValue];;
    
    for (int i = 0; i < numChildren; i++){
        NSLog(@"%d", i);
        NSString* str = [NSString stringWithFormat:@"child%d", i];
        NSDictionary* child = levelDict[str];
        NSString* spriteName = child[@"spriteName"];
        CCSprite* sprite = [CCSprite spriteWithFile:spriteName];
        NSInteger x = [child[@"x"] integerValue];
        NSInteger y = [child[@"y"] integerValue];
        [_backgroundNode addChild:sprite z:-1 parallaxRatio:bgSpeed positionOffset:ccp(x, y)];
        [_backgroundObjects addObject:sprite];
    }
    
    CCParticleSystemQuad* starsEffect1 = [CCParticleSystemQuad particleWithFile:@"stars0.plist"];
    [self addChild:starsEffect1 z:0];
    CCParticleSystemQuad* starsEffect2 = [CCParticleSystemQuad particleWithFile:@"stars1.plist"];
    [self addChild:starsEffect2 z:0.1];
    CCParticleSystemQuad* starsEffect3 = [CCParticleSystemQuad particleWithFile:@"stars2.plist"];
    [self addChild:starsEffect3 z:0.2];
}

-(void) loadAudio{
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"credits.aac" loop:YES];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser2.aiff"];
    
}

// ************ TOUCH HANDLING ******************************


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGPoint offset = ccpSub(location, _player.sprite.position);
    
    if (offset.y <= 0) return;
    
    float angleRadians = atanf((float)offset.x / (float)offset.y);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float rotateDegreesPerSecond = 180 / 0.5; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
    float degreesDiff = _player.weaponSprite.rotation - angleDegrees;
    float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
    
    [_player.weaponSprite runAction: [CCRotateTo actionWithDuration:rotateDuration angle:angleDegrees]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGPoint offset = ccpSub(location, _player.sprite.position);
    
    if (offset.y <= 0) return;
    
    float angleRadians = atanf((float)offset.x / (float)offset.y);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    
    _player.weaponSprite.rotation = angleDegrees;
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGPoint offset = ccpSub(location, _player.sprite.position);
    /*
    if (_gravBomb) return;
    if (offset.y <= 0) return;
    
    float angleRadians = atanf((float)offset.x / (float)offset.y);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    _player.weaponSprite.rotation = angleDegrees;
    
    if (_shot){
        if (_deployableShot){
            if (_shot.shotType == GRAVITY_BOMB){
                b2Body* shotB = [_shot getBody];
                shotB->SetLinearVelocity(b2Vec2(0, 0));
                shotB->SetAngularVelocity(0);
                _shot.shouldDelete = YES;
                [self loadGravityBomb];
            }
        }
    } else {
        [self loadShot];
        
        float total = fabsf(offset.x) + offset.y;
        float multiplier = 200/total;
        b2Vec2 shotForce = b2Vec2(offset.x * multiplier /PTM_RATIO, offset.y * multiplier / PTM_RATIO);
        
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        b2Vec2 toTarget = locationWorld - [_shot getBody]->GetPosition();
        float desiredAngle = atan2f( -toTarget.x, toTarget.y );
        [_shot getBody]->SetTransform([_shot getBody]->GetPosition(), desiredAngle );
        
        [_shot getBody]->ApplyLinearImpulse(shotForce, [_shot getBody]->GetPosition());
        [[SimpleAudioEngine sharedEngine] playEffect:@"laser2.aiff"];
        
        if (_shot.shotType == GRAVITY_BOMB){
            _deployableShot = YES;
        }
    }
     */
    
}

// **********  Touch handler callbacks from view controller

-(void)selectAmmo:(NSInteger)ammo{
    _player.weapon = ammo;
}

-(void)startMove:(NSInteger)direction{
    _player.engineEffect.position = ccp(_player.sprite.contentSize.width/2, 0);
    [_player.sprite addChild:_player.engineEffect z:5];
    _playerMovement = direction;
}

-(void)endMove{
    _playerMovement = STOPPING;
    [_player.sprite removeChild:_player.engineEffect cleanup:NO];
}


// read up about this!
- (void)dealloc {
    [SimpleAudioEngine end];
    delete _world;
    delete _contactListener;
    
    _world = NULL;
}

@end
