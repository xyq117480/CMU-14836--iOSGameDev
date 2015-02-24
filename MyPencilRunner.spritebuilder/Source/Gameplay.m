//
//  Gameplay.m
//  MyPencilRunner
//
//  Created by Aihua Peng on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    CCNode *_leftbound;
    CCNode *_rightbound;
    CCNode *_topbound;
    CCNode *_spike1;
    CCButton *_restart;
    CCButton *_jump;
    CCButton *_move;
    Runner *_runner;
    CCNode *_spikeInAir1;
    CCNode *_spikeInAir2;
    CCNode *_spikeInAir3;
    CCNode *_coin1;
    CCNode *_coin2;
    CCNode *_cherry1;
    CCNode *_cherry2;
    CCNode *_cherry3;
    CCNode *_cherry4;
    CCNode *_door;
    CCNode *_underDoor;
    bool isWin;
    
}


-(void)didLoadFromCCB{
    isWin = FALSE;
    _restart.visible = FALSE;
    _spikeInAir1.visible=FALSE;
    _spikeInAir2.visible=FALSE;
    _spikeInAir3.visible=FALSE;
    _cherry1.visible = FALSE;
    _cherry2.visible = FALSE;
    _cherry3.visible = FALSE;
    _cherry4.visible = FALSE;
    _door.visible = FALSE;
    
    _cherry1.physicsBody.sensor = TRUE;
    _cherry2.physicsBody.sensor = TRUE;
    _cherry3.physicsBody.sensor = TRUE;
    _cherry4.physicsBody.sensor = TRUE;
    _coin2.physicsBody.sensor = TRUE;
    _physicsNode.collisionDelegate = self;
    self.userInteractionEnabled = TRUE;
    _runner = (Runner *)[CCBReader load:@"Runner"];
    [_physicsNode addChild:_runner];
    _runner.position = CGPointMake(50.0f, 100.0f);
    _runner.physicsBody.collisionType=@"runner";
    _spike1.physicsBody.collisionType=@"bound";
    _leftbound.physicsBody.collisionType=@"bound";
    _rightbound.physicsBody.collisionType=@"bound";
    _topbound.physicsBody.collisionType=@"bound";
    _spikeInAir1.physicsBody.collisionType=@"spike";
    _spikeInAir2.physicsBody.collisionType=@"spike";
    _spikeInAir3.physicsBody.collisionType=@"spike";
    _coin2.physicsBody.collisionType=@"cherryFall";
    _cherry1.physicsBody.collisionType=@"bound";
    _cherry2.physicsBody.collisionType=@"bound";
    _cherry3.physicsBody.collisionType=@"win";
    _door.physicsBody.collisionType=@"finalWin";
    _cherry4.physicsBody.collisionType=@"bound";
    _underDoor.physicsBody.collisionType=@"bound";
    
    
    
}

-(void)spikePopUp:(CCNode *) spike{
    
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    if (CGRectContainsPoint([_spike1 boundingBox], touchLocation)) {
        [self spike1PopUp:_spike1];
    }
  
    
    
}

-(void)spike1PopUp: (CCNode *)spike{
    spike.physicsBody.type= CCPhysicsBodyTypeDynamic;
    _spikeInAir1.opacity = 0.5f;
    _spikeInAir1.visible = TRUE;
    _spikeInAir1.physicsBody =nil;
    _spikeInAir2.opacity = 0.5f;
    _spikeInAir2.visible = TRUE;
    _spikeInAir2.physicsBody =nil;
    _spikeInAir3.opacity = 0.5f;
    _spikeInAir3.visible = TRUE;
    _spikeInAir3.physicsBody =nil;
    [ _spike1.physicsBody applyImpulse:ccp(0, 600.f)];
   

}

-(void)jump{
   [ _runner.physicsBody applyImpulse:ccp(0, 100.f)];
    
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner spike:(CCNode *)spike{
    [self stop];
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    _spikeInAir1.visible=TRUE;
    _spikeInAir2.visible=TRUE;
    _spikeInAir3.visible=TRUE;
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner bound:(CCNode *)bound{
    [self stop];
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner cherryFall:(CCNode *)cherry{
    
    _cherry1.visible = TRUE;
    _cherry1.physicsBody.sensor = FALSE;
    _cherry1.physicsBody.type = CCPhysicsBodyTypeDynamic;
    _cherry2.visible = TRUE;
    _cherry2.physicsBody.type = CCPhysicsBodyTypeDynamic;
    _cherry2.physicsBody.sensor = FALSE;
    _cherry3.visible = TRUE;
    _cherry3.physicsBody.type = CCPhysicsBodyTypeDynamic;
    _cherry3.physicsBody.sensor = FALSE;
    _cherry4.visible = TRUE;
    _cherry4.physicsBody.type = CCPhysicsBodyTypeDynamic;
    _cherry4.physicsBody.sensor = FALSE;
    NSLog(@"Cherry begin falling");
   
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner win:(CCNode *)winCherry{
   
    NSLog(@"Door comes up");
    _cherry4.physicsBody = nil;
    [self win];
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)runner finalWin:(CCNode *)door{
    [self stop];
    if (isWin) {
        _restart.title = @"Win!";
        NSLog(@"Win!");
        _runner.visible = FALSE;
        _runner.physicsBody = nil;
    }
    else{
        NSLog(@"Not win yet");
    }
    _restart.visible = TRUE;
    
   
    return TRUE;
}

-(void)win{
    _door.visible = TRUE;
    
    isWin = TRUE;
}


-(void)stop{
    _jump.visible=FALSE;
    _move.visible=FALSE;
    [_runner stopAllActions];
    
}

-(void)restart{
   
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

-(void)move{
    _runner.position = ccp(_runner.position.x+5, _runner.position.y);
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 4000);
    [_runner.physicsBody applyForce:force];
}

@end
