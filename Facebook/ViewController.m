//
//  ViewController.m
//  Facebook
//
//  Created by Andy Wu on 12/19/16.
//  Copyright © 2016 Andy Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    
    //Get Persons e-mail address
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    loginButton.publishPermissions = @[@"publish_actions"];
    
    
    
    [self.view addSubview:loginButton];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchUserInfo {
    NSLog(@"Trying to fetch users email.\n");
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me"
                                      parameters:parameters
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            // Handle the result
            if (!error)
            {
                NSLog(@"Result: %@\n", [result valueForKey:@"email"]);
            }
        }];
        
    }
    else {
        NSLog(@"Email not found!\n");
    }
}


- (IBAction)login:(id)sender {
    
    [self fetchUserInfo];
    
}

- (void) showPhotos {
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        NSLog(@"Publishing Permission already Granted.\n");
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                              NSLog(@"Granting Publishing Permission.\n");
                                          }];
    }
    
    NSLog(@"Uploading Photo to Facebook.\n");
    // Assuming you have a UIImage reference
    UIImage *someImage = image;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES] ];
    
    // Assuming self implements <FBSDKSharingDelegate>
    [FBSDKShareAPI shareWithContent:content delegate:self];
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)uploadPhotos:(id)sender {
    [self showPhotos];
    
}

- (void)sharer: (id<FBSDKSharing>) sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"You have successfully upload your photo onto Facebook.\n");
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success!"
                                  message:@"You have successfully upload the photo."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sharer: (id<FBSDKSharing>) sharer didFailWithError:(NSError *)error {
    NSLog(@"There was an error uploading your photo.\nPlease try again.\n");
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error!"
                                  message:@"There was an Error Uploading your photo."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"You have canceled the upload.\n");
}

@end
