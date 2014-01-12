//
//  HelloWorldLayer.mm
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//



// Import the interfaces
#import "GameLayer.h"
#import "Player.h"
#import "cocos2d.h"
#import "CCParallaxNode-Extras.h"
#import "Shot.h"
#import "Wall.h"
#import "GLES-Render.h"
#import "BoxDebugLayer.h"
#import "MyContactListener.h"
#import "HUDLayer.h"
#import "SimpleAudioEngine.h"
#import "GameObject.h"
#import "YellowBot.h"
#import "Explosion.h"
#import "TankBot.h"
#import "LaserBeam.h"
#import "BotPart.h"
#import "GravityBomb.h"
#import "Portal.h"
#import "LunkerBot.h"
#import "RootViewController.h"
#import "Constants.h"


@interface GameLayer(){

    int _currentLevel;
    
    RootViewController* _rootViewController;
    NSDictionary* _rootLevelDict;
    NSMutableDictionary* _spriteSheets;
    
    Player *_player;
    Shot *_shot;
    GravityBomb* _gravBomb;
    
    NSMutableArray *_portals;
    NSMutableArray *_walls;
    NSMutableArray *_enemies; 
    NSMutableArray *_explosions;
    NSMutableArray *_lasers;
    
    b2World *_world;
    //b2Vec2 _touchPoint;
    
    // Map, map data
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_tileLayer;
    CCTMXObjectGroup *_mapObjects;
    CCTMXObjectGroup *_mapEnemies;
    CCTMXObjectGroup *_mapWalls;
    
    // parallax background Node & Sprites
    CCParallaxNode *_backgroundNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_planet;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
    // particle effecs
    CCParticleSystemQuad *_starsEffect1;
    CCParticleSystemQuad *_starsEffect2;
    CCParticleSystemQuad *_starsEffect3;
    CCParticleSystemQuad *_sparkEffect;
    
    MyContactListener *_contactListener;
    
    NSInteger _playerIsMoving;
    BOOL _deployableShot;
    CGRect _guiRect;
}
@end

@implementation GameLayer

+ (id)scene:(RootViewController*)rootViewController level:(NSInteger)levelNum{
    
    CCScene *scene = [CCScene node];
    
    GameLayer *layer = [[GameLayer alloc] initWithRootViewController:rootViewController level:levelNum];
    [scene addChild:layer];
    
    return scene;
}

-(id)initWithRootViewController:(RootViewController*)rootViewController level:(NSInteger)levelNum;{
    
    if (self=[super init]) {
        _playerIsMoving = STOPPED;
        _rootViewController = rootViewController;
        _currentLevel = levelNum;
        self.isTouchEnabled = YES;
        _deployableShot = NO;
       
        // load level dictionary

        NSString* levelString = [NSString stringWithFormat:@"level%d", _currentLevel];
        NSString* path = [[NSBundle mainBundle] pathForResource:levelString ofType:@"plist"];
        _rootLevelDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString* mapName = _rootLevelDict[@"map"];
        
        // load up tileMap, walls, objects
        
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
        _mapObjects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(_mapObjects != nil, @"tile map has no Objects object layer");
        _mapEnemies = [_tileMap objectGroupNamed:@"Enemies"];
        NSAssert(_mapObjects != nil, @"tile map has no Enemies object layer");
        _tileLayer = [_tileMap layerNamed:@"Tiles"];
        NSAssert(_tileLayer != nil, @"tile map has no Tiles tile layer");
        _mapWalls = [_tileMap objectGroupNamed:@"Walls"];
        NSAssert(_tileMap != nil, @"tile map has no Walls object layer");
        
        [self addChild:_tileMap z:1];
        
        // used?
        
        NSDictionary* hudDict = [_mapObjects objectNamed:@"gui"];
        _guiRect = CGRectMake([hudDict[@"x"] floatValue], [hudDict[@"y"] floatValue], [hudDict[@"width"] floatValue], [hudDict[@"height"] floatValue]);
        // ?
        
        CCSprite* wtf = [CCSprite spriteWithFile:@"blue35.png"];
        wtf.position = ccp([hudDict[@"x"] floatValue] + wtf.contentSize.width/2, [hudDict [@"y"] floatValue] + wtf.contentSize.height/2);
        
        [self addChild:wtf z:3];
        
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -5.0f);
        _world = new b2World(gravity);
        
        _explosions = [NSMutableArray array];
        [self loadAudio];
        [self loadSpriteSheets];
        [self loadWalls];
        [self loadPlayer];
        [self loadEnemies];
        [self loadLasers];
        [self loadParallaxBG];
        
        // Create contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        [self schedule:@selector(tick:)];
        
        // ***** DEBUG LAYER
        
        //[self addChild:[BoxDebugLayer debugLayerWithWorld:_world ptmRatio:PTM_RATIO] z:10000];
    }
    return self;
}


- (void)tick:(ccTime) dt {
    // Parallax Scrolling updating
    
    CGPoint backgroundScrollVel = ccp(0, -1000);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_planetsunrise, _galaxy, _spacialanomaly, _spacialanomaly2, _planet, nil];
    for (CCSprite *background in backgrounds) {
        if ([_backgroundNode convertToWorldSpace:background.position].y < -background.contentSize.width) {
            [_backgroundNode incrementOffset:ccp(0, 2000) forChild:background];
        }
    }
    
    // &&&&&&&&&&&&&&&&&&&& put engine effect inside player class and fix bug where moveBeginning is skipped and enginge effect doesnt happen
    
    // ********** ***************************   Step the physics
    
    _world->Step(dt, 10, 10);
    
    
    // ************    update sprite positions    ***********
    
    b2Body* playerBody = [_player getBody];
    
    _player.sprite.position = ccp(playerBody->GetPosition().x * PTM_RATIO, playerBody->GetPosition().y * PTM_RATIO);
    _player.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(playerBody->GetAngle());
    
    
    for (GameEnemy* enemy in _enemies){
        NSMutableArray* parts = [enemy getBotParts];
        for (BotPart* part in parts){
            b2Body* bodyPart = [part getBodyPart];
            part.sprite.position = ccp(bodyPart->GetPosition().x * PTM_RATIO, bodyPart->GetPosition().y * PTM_RATIO);
            part.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(bodyPart->GetAngle());
        }
    }
    
    if (_shot){
        _shot.sprite.position = ccp([_shot getBody]->GetPosition().x * PTM_RATIO, [_shot getBody]->GetPosition().y * PTM_RATIO);
        //_shot.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(_shotBody->GetAngle());
        b2Vec2 lv = [_shot getBody]->GetLinearVelocity();
        float rotation =  CC_RADIANS_TO_DEGREES(atan2(lv.x, lv.y));
        
        _shot.sprite.rotation = rotation;
        
        //_shotEffect.position = ccp(_shotBody->GetPosition().x * PTM_RATIO, _shotBody->GetPosition().y * PTM_RATIO);
        /*
        b2Vec2 lv = _shotBody->GetLinearVelocity();
        float x = atan2f(lv.x, lv.y);
        NSLog(@"%f, %f", lv.x, lv.y);
        x += M_PI/2;
        NSLog(@"%f", x);
        
        CGPoint p = ccp(- (lv.x * PTM_RATIO), - (lv.y * PTM_RATIO));
        
        if (_shotEffect){
            [_shotEffect setGravity:p];
        }
         */
        
        
    }
    
    if (_playerIsMoving < 3){
        switch (_playerIsMoving) {
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
    
    BOOL shotDidCollide = NO;
    NSMutableArray* bodiesToDestroy = [NSMutableArray array];
    NSMutableArray* jointsToDestroy = [NSMutableArray array];
    NSMutableArray* partsToDestroy = [NSMutableArray array];
    
    // COllision checking and resolving
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        int userDataA = (int)contact.fixtureA->GetUserData();
        int userDataB = (int)contact.fixtureB->GetUserData();
        
        if (_shot){
            
        // PROJECTILE TO WALL COLLISIONS
            
            if ((userDataA == TAGS_WALL && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_WALL && userDataA == TAGS_PROJECTILE)){
                if (! _shot.colliding){
                    if (_shot.doesBounce && _shot.numBounces > 0){
                        _shot.numBounces--;
                        _shot.colliding = YES;
                        //_shotEffect.resetSystem;
                    } else {
                        _shot.shouldDelete = YES;
                    }
                }
            }
            
        // PROJECTILE TO ENEMY COLLISIONS
            
            if ((userDataA == TAGS_ENEMY && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_ENEMY && userDataA == TAGS_PROJECTILE)){
                
                _shot.shouldDelete = YES;
                BotPart* botPiece;
                if (userDataA == TAGS_ENEMY){
                    botPiece = (__bridge BotPart*) contact.fixtureA->GetBody()->GetUserData();
                } else {
                    botPiece = (__bridge BotPart*) contact.fixtureB->GetBody()->GetUserData();
                }
                
                [self deactivateRobot:botPiece.bot];
                
                Explosion* explosion = [[Explosion alloc] initWithWorld:_world withCenter:contact.collisionPoint explosionType:@"normal"];
                [_explosions addObject:explosion];
                
                CCParticleSystemQuad* sparkEffect = [CCParticleSystemQuad particleWithFile:@"sparks.plist"];
                sparkEffect.position = ccp(contact.collisionPoint.x * PTM_RATIO, contact.collisionPoint.y * PTM_RATIO);
                [self addChild:sparkEffect z:5];

                
                NSMutableArray* joints = botPiece.joints;
                
                if (joints.count > 0 && joints.count < 3){
                    for (NSValue* jointVal in joints){
                        b2Joint* joint = (b2Joint*)[jointVal pointerValue];
                        
                        CCParticleSystemQuad* sparkEffect = [CCParticleSystemQuad particleWithFile:@"sparks.plist"];
                        sparkEffect.position = ccp(contact.collisionPoint.x * PTM_RATIO, contact.collisionPoint.y * PTM_RATIO);
                        [self addChild:sparkEffect z:5];
                        
                        NSValue* val = [NSValue valueWithPointer:joint];
                        if (![jointsToDestroy containsObject:val]){
                            [jointsToDestroy addObject:val];
                        }
                    }
                }
            }
            
            // PROJECTILE TO LASER BEAM COLLISIONS
            
            if ((userDataA == TAGS_LASER_BEAM && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_LASER_BEAM && userDataA == TAGS_PROJECTILE)){
                
                _shot.shouldDelete = YES;
                CCParticleSystemQuad* laserCloud = [CCParticleSystemQuad particleWithFile:@"laserSmoke.plist"];
                laserCloud.position = ccp(contact.collisionPoint.x * PTM_RATIO, contact.collisionPoint.y * PTM_RATIO);
                [self addChild:laserCloud z:15];
            }
            
            // PROJECTILE TO LASER SWITCH COLLISIONS
            if ((userDataA == TAGS_LASER_SWITCH && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_LASER_SWITCH && userDataA == TAGS_PROJECTILE)){
                
                NSLog(@"hit switch");
                LaserBeam* laser;
                if (userDataA == TAGS_LASER_SWITCH){
                    laser = (__bridge LaserBeam*)contact.fixtureA->GetBody()->GetUserData();
                } else {
                    laser = (__bridge LaserBeam*)contact.fixtureB->GetBody()->GetUserData();
                }
                
                if (laser.isColliding){
                    [laser toggleSwitch];
                    [self addChild:laser.switchSprite z:6];
                    if (laser.isOn){
                        [self addChild:laser.laserParticle z:5];
                    } else{
                        [self removeChild:laser.laserParticle cleanup:NO];
                    }
                    laser.isColliding = NO;
                }
            }
        } // END PROJECTILE COLLISIONS
        
        // LASER BEAM TO ENEMY COLLISIONS
        
        if ((userDataA == TAGS_LASER_BEAM && userDataB == TAGS_ENEMY) || (userDataB == TAGS_LASER_BEAM && userDataA == TAGS_ENEMY)){
            
            BotPart* part;
            
            if (userDataA == TAGS_ENEMY){
                part = (__bridge BotPart*)contact.fixtureA->GetBody()->GetUserData();
            } else {
                part = (__bridge BotPart*)contact.fixtureB->GetBody()->GetUserData();
            }
            
            //Explosion* explosion = [[Explosion alloc] initWithWorld:_world withCenter:contact.collisionPoint withLength:5];
            //[_explosions addObject:explosion];
            
            _sparkEffect = [CCParticleSystemQuad particleWithFile:@"laserSmoke.plist"];
            _sparkEffect.position = ccp(contact.collisionPoint.x * PTM_RATIO, contact.collisionPoint.y * PTM_RATIO);
            [self addChild:_sparkEffect z:5];
            
            NSMutableArray* joints = part.joints;
            
            if (joints.count > 0){
                for (NSValue* jointVal in joints){
                    b2Joint* joint = (b2Joint*)[jointVal pointerValue];
                    NSValue* val = [NSValue valueWithPointer:joint];
                    if (![jointsToDestroy containsObject:val]){
                        [jointsToDestroy addObject:val];
                    }
                }
            }
            
            NSValue* bVal = [NSValue valueWithPointer:[part getBodyPart]];
            [bodiesToDestroy addObject:bVal];
            [self removeChild:part.sprite cleanup:YES];
            [partsToDestroy addObject:part];
        }
        
        if ((userDataA == TAGS_GRAVITY_BOMB && userDataB == TAGS_ENEMY) || (userDataB == TAGS_GRAVITY_BOMB && userDataA == TAGS_ENEMY)){
            
            BotPart* part;
            b2Body* gravBody;
            
            if (userDataA == TAGS_ENEMY){
                part = (__bridge BotPart*)contact.fixtureA->GetBody()->GetUserData();
                gravBody = contact.fixtureB->GetBody();
            } else {
                part = (__bridge BotPart*)contact.fixtureB->GetBody()->GetUserData();
                gravBody = contact.fixtureA->GetBody();
            }
            
            b2CircleShape* circ = (b2CircleShape*)gravBody->GetFixtureList()->GetShape();
            float rad = circ->m_radius;
            b2Vec2 bombPos = gravBody->GetPosition();
            b2Vec2 distance = b2Vec2(0, 0);
            distance += [part getBodyPart]->GetPosition();
            distance -= bombPos;
            float finalDist = distance.Length();
            distance = -distance;
            float vecSum = fabsf(distance.x) + fabsf(distance.y);
            distance *= (1/vecSum) * rad/finalDist * 4;
            [part getBodyPart]->ApplyForce(distance, [part getBodyPart]->GetWorldCenter());
            
        }

    } // END OF COLLISION CHECKING
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGRect winRec = CGRectMake(0, 0, winSize.width, winSize.height);
    if (! CGRectIntersectsRect(winRec, _shot.sprite.boundingBox)){
        _shot.shouldDelete = YES;
    }
    
    if (_explosions.count > 0){
        
        NSMutableArray* explosionsToDelete = [NSMutableArray array];
        
        for (Explosion* explosion in _explosions){
            if (explosion.length > 0){
                explosion.length--;
            } else {
                for (NSValue* bodyVal in explosion.explosionBodies){
                    b2Body* exploder = (b2Body*)[bodyVal pointerValue];
                    _world->DestroyBody(exploder);
                    exploder = NULL;
                }
                
                [explosionsToDelete addObject:explosion];
            }
        }
        
        for (Explosion* explosion in explosionsToDelete){
            [_explosions removeObject:explosion];
        }
        
        explosionsToDelete = NULL;
    }
    
    if (jointsToDestroy.count > 0){
        for (NSValue* jointVal in jointsToDestroy){
            b2Joint* joint = (b2Joint*)[jointVal pointerValue];
            if (joint){
                BotPart* partA = (__bridge BotPart*)joint->GetBodyA()->GetUserData();
                BotPart* partB = (__bridge BotPart*)joint->GetBodyB()->GetUserData();
                [partA.joints removeObject:jointVal];
                [partB.joints removeObject:jointVal];
                _world->DestroyJoint(joint);
            }
        }
    }
    
    if (bodiesToDestroy.count > 0){
        for (NSValue* bodyVal in bodiesToDestroy){
            b2Body* mBody = (b2Body*)[bodyVal pointerValue];
            //for (b2JointEdge* j = mBody->GetJointList(); j; j=j->next){
            //    b2Joint* joint = j->joint;
            //    _world->DestroyJoint(joint);
            //}
            _world->DestroyBody(mBody);
        }
    }
    
    if (partsToDestroy.count > 0){
        for (int i = 0; i < partsToDestroy.count; i++){
            BotPart* p = [partsToDestroy objectAtIndex:i];
            p = NULL;
        }
    }
    
    
    
    if (!shotDidCollide){
        _shot.colliding = NO;
    }
    
    if (_shot.shouldDelete){
        [self removeChild:_shot.sprite cleanup:YES];
        _world->DestroyBody([_shot getBody]);
        _shot = NULL;
    }
    
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
}

// ********** LOADING / CREATION METHODS / OTHER METHODS ************************************************
-(void) deactivateRobot:(GameEnemy*)enemy{
    NSMutableArray* parts = [enemy getBotParts];
    for (BotPart* part in parts){
        for (NSValue* val in part.joints){
            b2RevoluteJoint* joint = (b2RevoluteJoint*)[val pointerValue];
            joint->SetLimits(CC_DEGREES_TO_RADIANS(-360), CC_DEGREES_TO_RADIANS(360));
        }
    }
}

-(void) loadGravityBomb{
    _gravBomb = [[GravityBomb alloc] initWithWorld:_world withPosition:[_shot getBody]->GetPosition()];
    [self addChild:_gravBomb.gravParticle z:3];
    [self scheduleOnce:@selector(explodeGravBomb) delay:4.0];
}

-(void) explodeGravBomb{
    Explosion* explosion = [[Explosion alloc] initWithWorld:_world withCenter:[_gravBomb getBody]->GetPosition() explosionType:@"normal"];
    [_explosions addObject:explosion];
    [self removeChild:_gravBomb.gravParticle cleanup:YES];
    _world->DestroyBody([_gravBomb getBody]);
    _gravBomb = NULL;
}

-(void) loadShot{
    _shot = [[Shot alloc] initWithType:_player.weapon withWorld:_world withPlayer:_player];
    [self addChild:_shot.sprite z:10.5];
}

-(void) loadWalls{
    int numWalls = [_rootLevelDict[@"numWalls"] intValue];
    _walls = [NSMutableArray array];
    for (int i = 0; i < numWalls; i++){
        Wall* wall = [[Wall alloc] initWithType:@"wall" withObjectGroup:_mapWalls withWorld:_world withWallNum:i];
        [_walls addObject:wall];
    }
}


-(void) loadPlayer{
    NSString* spawnPoint = @"Spawn Point";
    NSDictionary* spawnDict = [_mapObjects objectNamed:spawnPoint];
    _player = [[Player alloc] initWithWorld:_world withDict:spawnDict];
    [self addChild: _player.sprite z:10];
    
}

-(void) loadEnemies{
    _enemies = [NSMutableArray array];
    int numEnemies = [_rootLevelDict[@"numEnemies"] intValue];
    for (int i = 0; i < numEnemies; i++){
        
        NSString* str = [NSString stringWithFormat:@"enemy%d", i];
        NSDictionary* spawnDict = [_mapEnemies objectNamed:str];
        float x = [spawnDict[@"x"] floatValue];
        float y = [spawnDict[@"y"] floatValue];
        float width = [spawnDict[@"width"] floatValue];
        float height = [spawnDict[@"height"] floatValue];
        
        int rand = arc4random() % 3;
        
        GameEnemy* enemy;
        b2Vec2 position = b2Vec2((x + width/2)/PTM_RATIO, (y + height/2)/PTM_RATIO);
        
        switch (rand) {
            case YELLOW:
                enemy = [[YellowBot alloc] initWithWorld:_world withPosition:position];
                break;
            case TANK:
                enemy = [[TankBot alloc] initWithWorld:_world withPosition:position];
                break;
            case LUNKER:
                enemy = [[LunkerBot alloc] initWithWorld:_world withPosition:position];
                break;
            default:
                break;
        }
        
        NSMutableArray* parts = [enemy getBotParts];
        for (BotPart* part in parts){
            [self addChild:part.sprite z:4];
        }
        
        //[self schedule:@selector(moveEnemiesLeft) interval:0.2];
        //[self schedule:@selector(moveEnemiesRight) interval:0.2];
        [_enemies addObject:enemy];
        
        //CCSpriteBatchNode *spritesheet = [_spriteSheets objectForKey:@"Robot"];
        //[spritesheet addChild:_enemy.sprite];
    }
}

-(void) moveEnemiesLeft{
    if (_enemies.count > 0){
        for (TankBot* bot in _enemies){
            [bot moveLeft];
        }
    }
}

-(void) moveEnemiesRight{
    if (_enemies.count > 0){
        for (TankBot* bot in _enemies){
            [bot moveRight];
        }
    }
}

-(void) loadLasers{
    int numLasers = [_rootLevelDict[@"numLasers"] intValue];
    if (numLasers > 0){
        _lasers = [NSMutableArray array];
        for (int i = 0; i < numLasers; i++){
            
            NSString* str = [NSString stringWithFormat:@"laser%d", i];
            NSDictionary* spawnDict = [_mapObjects objectNamed:str];
            
            LaserBeam* laser = [[LaserBeam alloc] initWithDictionary:spawnDict withWorld:_world];
            [self addChild:laser.emitterTopSprite z:6];
            [self addChild:laser.emitterBotSprite z:6];
            [self addChild:laser.laserParticle z:5];
            
            NSString* str2 = [NSString stringWithFormat:@"laserSwitch%d", i];
            NSDictionary* spawnDict2 = [_mapObjects objectNamed:str2];
            [laser setSwitches:spawnDict2 withWorld:_world];
            [self addChild:laser.switchSprite z:6];
            
            [_lasers addObject:laser];
        }
    }
}

-(void) loadAudio{
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"credits.aac" loop:YES];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser2.aiff"];

}

-(void) loadSpriteSheets{
    _spriteSheets = [[NSMutableDictionary alloc] init];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"testSheet3.plist"];
    CCSpriteBatchNode *testSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"testSheet3.png"];
    [self addChild:testSpriteSheet z:5];
    [_spriteSheets setObject:testSpriteSheet forKey:@"testSheet"];
}


-(void) loadParallaxBG{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _backgroundNode = [CCParallaxNode node];
    [self addChild:_backgroundNode z:-1];
    
    
    _planetsunrise = [CCSprite spriteWithFile:@"Nebula1.png"];
    _galaxy = [CCSprite spriteWithFile:@"Nebula2.png"];
    _spacialanomaly = [CCSprite spriteWithFile:@"Nebula3.png"];
    _spacialanomaly2 = [CCSprite spriteWithFile:@"Nebula2.png"];
    _planet = [CCSprite spriteWithFile:@"planet0.png"];
    
    CGPoint bgSpeed = ccp(0.1, 0.1);
    
    [_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(100,winSize.height * 1.2)];
    [_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(200,winSize.height * 0.1)];
    [_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600,winSize.height * 0.6)];
    [_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(700,winSize.height * 0.9)];
    
    //CGPoint planetSpeed = ccp(0.2, 0.2);
    
    //[_backgroundNode addChild:_planet z:-1 parallaxRatio:planetSpeed positionOffset:ccp(300, winSize.height * 0.3)];
    
    _starsEffect1 = [CCParticleSystemQuad particleWithFile:@"stars0.plist"];
    [self addChild:_starsEffect1 z:-2];
    _starsEffect2 = [CCParticleSystemQuad particleWithFile:@"stars1.plist"];
    [self addChild:_starsEffect2 z:-2.1];
    _starsEffect3 = [CCParticleSystemQuad particleWithFile:@"stars2.plist"];
    [self addChild:_starsEffect3 z:-2.2];
    
    //[self scheduleOnce:@selector(updateStarParticles) delay:4.0];
}


- (void)dealloc {
    [SimpleAudioEngine end];
    delete _world;
    delete _contactListener;

    _enemies = NULL;
    _world = NULL;
}

// ***************** HUD Reactions

-(void)selectAmmo:(NSInteger)ammo{
    _player.weapon = ammo;
}

-(void)startMove:(NSInteger)direction{
    _player.engineEffect.position = ccp(_player.sprite.contentSize.width/2, 0);
    [_player.sprite addChild:_player.engineEffect z:5];
    _playerIsMoving = direction;
}

-(void)endMove{
    _playerIsMoving = STOPPING;
    [_player.sprite removeChild:_player.engineEffect cleanup:NO];
}

@end