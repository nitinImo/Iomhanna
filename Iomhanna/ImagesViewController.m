//
//  ImagesViewController.m
//  Iomhanna
//
//  Created by Spadez Family on 25/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import "ImagesViewController.h"
#import "SendAllDataViewController.h"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

@synthesize image1, image2, imageView1, imageView2, retake1, retake2;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.navigationItem.title = @"Preview";
    image1 = [self imageWithImage:image1 scaledToSize:image1.size];
    image2 = [self imageWithImage:image2 scaledToSize:image2.size];
    imageView1.image = image1;
    imageView2.image = image2;
    imageView1.frame = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y, image1.size.width, image1.size.height);
    imageView2.frame = CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y, image2.size.width, image2.size.height);
    
    retake1.accessibilityHint = @"retake1";
    retake2.accessibilityHint = @"retake2";
    
    UIBarButtonItem *btnSend = [[UIBarButtonItem alloc] initWithTitle:@"Upload"
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem = btnSend;
    if(image1 == nil)
        [retake1 setTitle:@"Take Image 1 " forState:UIControlStateNormal];
    
    if(image2 == nil)
        [retake2 setTitle:@"Take Image 2 " forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

/*
 Navigate to Send all data screen
 */
-(void)upload
{
    [self performSegueWithIdentifier:@"SendAllData" sender:nil];
    
}

/* 
 Used to retake the image
 */
-(IBAction)retake:(id)sender
{
    UIButton *btn = sender;
    buttonHint = btn.accessibilityHint;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

/*
 ImagePickerController function called on finish
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if([buttonHint isEqual:@"retake1"])
    {
        chosenImage = [self imageWithImage:chosenImage scaledToSize:imageView1.frame.size];
        image1 = chosenImage;
        imageView1.image = chosenImage;
    }
    else
    {
        chosenImage = [self imageWithImage:chosenImage scaledToSize:imageView2.frame.size];
        image2 = chosenImage;
        imageView2.image = chosenImage;
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

/*
 ImagePickerController function called on cancelling
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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


#pragma mark - Navigation

/*
 In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SendAllDataViewController *controller = segue.destinationViewController;
    controller.image = image1;
    controller.image2 = image2;
}


@end
