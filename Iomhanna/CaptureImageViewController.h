//
//  ViewController.h
//  Iomhanna
//
//  Created by Spadez Family on 04/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureImageViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIButton *button_capture, *button_capture_2, *button_images;
    IBOutlet UIImageView *image;
    IBOutlet UITextField *_txtWidth, *_txtHeight;
    UIActivityIndicatorView *activityIndicator;
    UIImage *image1, *image2;
    NSString *buttonString;
}

@property(nonatomic, retain) IBOutlet UIButton *button_capture;
@property(nonatomic, retain) IBOutlet UIButton *button_capture_2;
@property(nonatomic, retain) IBOutlet UIButton *button_images;
@property(nonatomic, retain) IBOutlet UIImageView *image;
@property(nonatomic, retain) IBOutlet UITextField *_txtWidth;
@property(nonatomic, retain) IBOutlet UITextField *_txtHeight;
@property(nonatomic, retain) UIImage *image1;
@property(nonatomic, retain) UIImage *image2;

-(IBAction)capture:(id)sender;
-(IBAction)goToImages:(id)sender;

@end

