//
//  MyContactListener.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/14/13.
//
//

#import "MyContactListener.h"
#import "Shot.h"
#import "GameLayer.h"
#import "LaserBeam.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    b2Vec2 collision;
    b2WorldManifold worldManifold;
    contact->GetWorldManifold(&worldManifold);
    collision = worldManifold.points[0];

    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() , collision};
    _contacts.push_back(myContact);
    
    int userDataA = (int)contact->GetFixtureA()->GetUserData();
    int userDataB = (int)contact->GetFixtureB()->GetUserData();
    if ((userDataA == TAGS_LASER_SWITCH && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_LASER_SWITCH && userDataA == TAGS_PROJECTILE)){
        
        LaserBeam* laser;
        if (userDataA == TAGS_LASER_SWITCH){
            laser = (__bridge LaserBeam*)contact->GetFixtureA()->GetBody()->GetUserData();
        } else {
            laser = (__bridge LaserBeam*)contact->GetFixtureB()->GetBody()->GetUserData();
        }
        
        laser.isColliding = YES;
        NSLog(@"begin");
    }
    
}

void MyContactListener::EndContact(b2Contact* contact) {
    b2Vec2 collision;
    b2WorldManifold worldManifold;
    contact->GetWorldManifold(&worldManifold);
    collision = worldManifold.points[0];

    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB(), collision };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
    
    int userDataA = (int)contact->GetFixtureA()->GetUserData();
    int userDataB = (int)contact->GetFixtureB()->GetUserData();
    if ((userDataA == TAGS_LASER_SWITCH && userDataB == TAGS_PROJECTILE) || (userDataB == TAGS_LASER_SWITCH && userDataA == TAGS_PROJECTILE)){
        
        LaserBeam* laser;
        if (userDataA == TAGS_LASER_SWITCH){
            laser = (__bridge LaserBeam*)contact->GetFixtureA()->GetBody()->GetUserData();
        } else {
            laser = (__bridge LaserBeam*)contact->GetFixtureB()->GetBody()->GetUserData();
        }
        
        NSLog(@"end");
    }
    
}

void MyContactListener::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold) {
}

void MyContactListener::PostSolve(b2Contact* contact,
                                  const b2ContactImpulse* impulse) {
}