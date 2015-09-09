//
//  LoginViewController.h
//  Iomhanna
//
//  Created by Spadez Family on 04/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *textfield_userID, *textfield_password;
    IBOutlet UIButton *button_login, *button_register;
    UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) UITextField *textfield_userID;
@property(nonatomic, retain) UITextField *textfield_password;
@property(nonatomic, retain) UIButton *button_login;
@property(nonatomic, retain) UIButton *button_register;

-(IBAction)login:(id)sender;
-(IBAction)registerUser:(id)sender;

@end
