#import "MainScene.h"

@implementation MainScene

-(void)play{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay1"];
   
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}


-(void)play_level2{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay2"];
    
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];

}

-(void)play_level3{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay3"];
    
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
    
}


-(void)exit_app{
    [[CCDirector sharedDirector] end];
}


@end
