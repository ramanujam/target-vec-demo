//
//  AppDelegate.m
//  TestTemplate
//
//  Created by AppsFoundation on 1/18/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

#import "AppDelegate.h"

#import "ConfigurationManager.h"
#import "MSSlidingPanelController.h"
#import "ThemeManager.h"
#import <Leanplum/Leanplum.h>
#import <Taplytics/Taplytics.h>
#import <Optimizely/Optimizely.h>

static NSInteger secondsInHour = 60;

typedef enum {
    RateAppDeclined = 0,
    RateAppConfirmed
}RateApp;

@interface AppDelegate ()

@end

DEFINE_VAR_STRING(welcomeMessage, @"Welcome to Leanplum!");


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
  
    [ThemeManager applyNavigationBarTheme];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    

    #ifdef DEBUG
        LEANPLUM_USE_ADVERTISING_ID;
        [Leanplum setAppId:@"app_RnObManqcjtcKCXcinAmz3Ncq3r6nfT6067JRBGiDPU"
        withDevelopmentKey:@"dev_teJ7GrHGQCEh7BnYLOdmjpmQC0xKNqtUH76doMTldf8"];
    #else
        [Leanplum setAppId:@"app_RnObManqcjtcKCXcinAmz3Ncq3r6nfT6067JRBGiDPU"
         withProductionKey:@"prod_cpr0FCy9pitjEEHRIzmqhXFiyzIyhhChhHijUaFnJn8"];
    #endif
    
    [Leanplum trackAllAppScreens];
    [Leanplum allowInterfaceEditing];
    [Leanplum start];
    [Leanplum track:@"Launch"];

    [Taplytics startTaplyticsAPIKey:@"d9ba01a31e8d6d3d3de5a6b079c48107d396556c"];
    [Optimizely enableEditor];
    [Optimizely startOptimizelyWithAPIToken:
     @"AANQPCwBWPR4GRG-tFalOEFGRwbZwH1Y~5950040050" launchOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([Optimizely handleOpenURL:url]) {
        return YES;
    }
    return NO;
}


+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)([UIApplication sharedApplication]).delegate;
}


#pragma mark - Actions

- (void)openOurMenu {
    [self openControllerWithIndentifier:@"ourMenuNavController"];
}

- (void)openReservation {
    [self openControllerWithIndentifier:@"reservationNavController"];
}

- (void)openFindUs {
    [self openControllerWithIndentifier:@"findUsNavController"];
}

- (void)openFeedback{
    [self openControllerWithIndentifier:@"feedbackNavController"];
}

#pragma mark - Private methods

- (void)openControllerWithIndentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    MSSlidingPanelController *rootController = (MSSlidingPanelController *)self.window.rootViewController;
    
    [rootController setCenterViewController:controller];
    [rootController closePanel];
}


- (void)initRateAppTimer {
    NSNumber *didShowAppRate = [[NSUserDefaults standardUserDefaults] valueForKey:@"showedAppRate"];
    if (!didShowAppRate.boolValue) {
        NSInteger showRateDelay = [[[ConfigurationManager sharedManager] rateAppDelay] integerValue] * secondsInHour;
        [NSTimer scheduledTimerWithTimeInterval:showRateDelay target:self
                                       selector:@selector(showAppRate)
                                       userInfo:nil repeats:NO];
    }
}

- (void)showAppRate {
    NSNumber *didShowAppRate = [[NSUserDefaults standardUserDefaults] valueForKey:@"showedAppRate"];
    if (![didShowAppRate boolValue]) {
        [self rateApp];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"showedAppRate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)rateApp {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Rate the App" message:@"Do you like app?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Rate the App"]) {
        switch (buttonIndex) {
            case RateAppDeclined: {
                break;
            }
            case RateAppConfirmed:
                break;
            default:
                break;
        }
    }
}

@end
