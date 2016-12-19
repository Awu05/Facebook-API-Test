//
//  ViewController.h
//  Facebook
//
//  Created by Andy Wu on 12/19/16.
//  Copyright © 2016 Andy Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FBSDKSharingDelegate>


@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (IBAction)login:(id)sender;
- (IBAction)uploadPhotos:(id)sender;

@end

