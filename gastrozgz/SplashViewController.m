//
//  SplashViewController.m
//  gastrozgz
//
//  Created by Daniel Vela on 6/25/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "SplashViewController.h"
#import "OSCoreDataSyncEngine.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initWaitingView {
    self.watingView.layer.cornerRadius = 20;
    self.watingView.alpha = 0.0;
    [self.watingView setOpaque:NO];
    [self.view addSubview:self.watingView];
    CGRect frame = self.watingView.frame;
    frame.origin.x = 30;
    frame.origin.y = 186;
    self.watingView.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initWaitingView];
}

- (void)navigateToNextController {
    [self performSegueWithIdentifier:@"SplashSegue2"
                              sender:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[OSCoreDataSyncEngine sharedEngine] initialSyncComplete] == YES) {
        [self navigateToNextController];
    } else {
        // Mostrar una alerta que explique al usuario que se está
        // realizando la primera sincronización.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initialSyncFinished)
                                                     name:kOSCoreDataSyncEngineSyncCompletedNotificationName
                                                   object:nil];
        [self showWaitPleaseView];
    }
    // FIXME: Testing only. REMOVE
    [self performSelector:@selector(initialSyncFinished) withObject:nil afterDelay:1];
}

- (void)initialSyncFinished {
    self.watingView.hidden = YES;
    [self.watingView removeFromSuperview];
    [self navigateToNextController];
}

- (void)showWaitPleaseView {

    [UIView animateWithDuration:0.4f animations:^(void){
        [self.watingView setAlpha:0.9];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWatingView:nil];
    [self setImage:nil];
        [super viewDidUnload];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
