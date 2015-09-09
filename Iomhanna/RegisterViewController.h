//
//  RegisterViewController.h
//  Iomhanna
//
//  Created by Spadez Family on 24/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) IBOutlet UITextField *_firstname;
@property(nonatomic, retain) IBOutlet UITextField *_lastname;
@property(nonatomic, retain) IBOutlet UITextField *_password;
@property(nonatomic, retain) IBOutlet UITextField *_confirm_password;
@property(nonatomic, retain) IBOutlet UITextField *_email;
@property(nonatomic, retain) IBOutlet UIButton *button_register;
@property(nonatomic, retain) IBOutlet UIButton *button_cancel;

-(IBAction)registerUser:(id)sender;
-(IBAction)cancel:(id)sender;

@end
