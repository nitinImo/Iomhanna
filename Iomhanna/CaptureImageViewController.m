//
//  ViewController.m
//  Iomhanna
//
//  Created by Spadez Family on 04/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import "CaptureImageViewController.h"
#import "SendAllDataViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "ImagesViewController.h"

@interface CaptureImageViewController ()

@end

@implementation CaptureImageViewController

@synthesize button_capture, image, _txtHeight, _txtWidth, button_capture_2, button_images, image1, image2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Capture image";
    image.hidden = YES;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    [self.view addSubview:activityIndicator];
    activityIndicator.hidden = YES;
    
    button_capture.accessibilityHint = @"capture1";
    button_capture_2.accessibilityHint = @"capture2";
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [_txtWidth setInputAccessoryView:toolbar];
    [_txtHeight setInputAccessoryView:toolbar];
    
    UIBarButtonItem *btnLogout = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = btnLogout;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(activityIndicator)
        [activityIndicator stopAnimating];
}

/*
 Function for logging out of application
 */
-(void)logout
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 Function for making the keypad disappear
 */
-(void) resignKeyboard
{
    [_txtHeight resignFirstResponder];
    [_txtWidth resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Function for navigating to image preview screen
 */
-(IBAction)goToImages:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:_txtWidth.text forKey:@"width"];
    [[NSUserDefaults standardUserDefaults]setObject:_txtHeight.text forKey:@"height"];
    [self performSegueWithIdentifier:@"ImagesScreen" sender:nil];
}

/*
 Function for scaling the image
 */
- (UIImage *)imageWithImage:(UIImage *)img scaledToSize:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
 Function for invoking the camera view
 */
-(IBAction)capture:(id)sender
{
    UIButton *btn = sender;
    buttonString = btn.accessibilityHint;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    if([btn.accessibilityHint isEqual:@"capture1"])
        [button_capture setTitle:@"Retake" forState:UIControlStateNormal];
    else
        [button_capture_2 setTitle:@"Retake" forState:UIControlStateNormal];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

/*
 ImagePickerController function called on finish
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    image.hidden = NO;
    NSLog(@"Width : %f, Height : %f", [_txtWidth.text floatValue], [_txtHeight.text floatValue]);
    chosenImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake([_txtWidth.text isEqual:@""] ? 40 : [_txtWidth.text floatValue], [_txtHeight.text isEqual:@""] ? 40 : [_txtHeight.text floatValue])];
    self.image.image = chosenImage;
    image.frame = CGRectMake(image.frame.origin.x, image.frame.origin.y, chosenImage.size.width, chosenImage.size.height);
    if([buttonString isEqual:@"capture1"])
        image1 = chosenImage;
    else
        image2 = chosenImage;
    NSLog(@"ImageView size :  %@", NSStringFromCGSize(image.image.size));
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

/*
 ImagePickerController function called on cancelling
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*
 Function called on performing segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"AllDetails"])
    {
    SendAllDataViewController *controller = segue.destinationViewController;
    controller.image = image.image;
    }
    else if([segue.identifier isEqual:@"ImagesScreen"])
    {
        ImagesViewController *controller = segue.destinationViewController;
        controller.image1 = image1;
        controller.image2 = image2;
    }
    else
    {
        LoginViewController *controller = segue.destinationViewController;
    }
}


@end
