//
//  AppDelegate.m
//  CoreDataEnvirSample
//
//  Created by Deheng.Xu on 13-4-7.
//  Copyright (c) 2013年 Nicholas.Xu. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "CoreDataEnvir.h"
#import "Team.h"
#import "Member.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [CoreDataEnvir registDatabaseFileName:@"db.sqlite"];
    [CoreDataEnvir registModelFileName:@"SampleModel"];

    dispatch_queue_t q1, q2, qMain;
    
    q1 = dispatch_queue_create("com.cyblion.q1", NULL);
    q2 = dispatch_queue_create("com.cyblion.q2", NULL);
    qMain = dispatch_get_main_queue();
    
    dispatch_async(q1, ^{
        CoreDataEnvir *db = [CoreDataEnvir instance];
        for (int i = 0; i < 500; i++) {
            Team *team = (Team *)[Team lastItemWith:db predicate:[NSPredicate predicateWithFormat:@"name==9"]];
            if (team) {
                [db deleteDataItem:team];
            }else {
                [Team insertItemWith:db fillData:^(Team *item) {
                    item.name = [NSString stringWithFormat:@"9"];
                }];

            }
            [db saveDataBase];
        }
    });
    
    dispatch_async(q2, ^{
        CoreDataEnvir *db = [CoreDataEnvir instance];
        for (int i = 0; i < 500; i++) {
            Team *team = (Team *)[Team lastItemWith:db predicate:[NSPredicate predicateWithFormat:@"name==9"]];
            if (team) {
                [db deleteDataItem:team];
            }else {
                [Team insertItemWith:db fillData:^(Team *item) {
                    item.name = [NSString stringWithFormat:@"9"];
                }];
                
            }
            [db saveDataBase];
        }
    });
    
    dispatch_async(qMain, ^{
        CoreDataEnvir *db = [CoreDataEnvir instance];
        for (int i = 0; i < 500; i++) {
            Team *team = (Team *)[Team lastItemWith:[NSPredicate predicateWithFormat:@"name==9"]];
            if (team) {
                [db deleteDataItem:team];
            }else {
                [Team insertItemWithBlock:^(Team *item) {
                    item.name = [NSString stringWithFormat:@"9"];
                }];
                
            }
            [db saveDataBase];
        }
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end