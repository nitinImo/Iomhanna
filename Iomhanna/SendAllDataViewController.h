//
//  SendAllDataViewController.h
//  Iomhanna
//
//  Created by Spadez Family on 18/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendAllDataViewController : UIViewController<UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITextView *_txtDescription;
    IBOutlet UISwitch *_switchPriority;
    IBOutlet UIImageView *_imageView;
    IBOutlet UIImageView *_imageView2;
    IBOutlet UIButton *button_upload;
    IBOutlet UITextField *txt_position;
    IBOutlet UITextField *txt_position2;
    UIPickerView *pickerPosition, *pickerPosition2;
    UIActivityIndicatorView *activityIndicator;
    NSArray *arrPosition;
    BOOL isSuccess;
    BOOL isImage1, isImage2;
}

@property(nonatomic, retain) IBOutlet UITextView *_txtDescription;
@property(nonatomic, retain) IBOutlet UISwitch *_switchPriority;
@property(nonatomic, retain) IBOutlet UIImageView *_imageView;
@property(nonatomic, retain) IBOutlet UIImageView *_imageView2;
@property(nonatomic, retain) IBOutlet IBOutlet UIButton *button_upload;
@property(nonatomic, retain) IBOutlet IBOutlet UITextField *txt_position;
@property(nonatomic, retain) IBOutlet IBOutlet UITextField *txt_position2;
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIImage *image2;

-(IBAction)uploadAction:(id)sender;

@end
