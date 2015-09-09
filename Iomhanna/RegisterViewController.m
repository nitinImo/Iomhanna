//
//  RegisterViewController.m
//  Iomhanna
//
//  Created by Spadez Family on 24/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize _firstname, _lastname, _password, _confirm_password, _email, button_cancel, button_register;

- (void)viewDidLoad {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    [self.view addSubview:activityIndicator];
    activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
/* 
 Hides keyboard after Done / Return button press
 */
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}
/*
 Action performed on Register button.
 */
-(IBAction)registerUser:(id)sender
{
    NSString *text = @"";
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    if([_firstname.text isEqual:@""])
        text = @"Please fill First Name";
    else if([_lastname.text isEqual:@""])
        text = @"Please fill Last Name";
    else if([_password.text isEqual:@""])
        text = @"Please fill Password";
    else if([_confirm_password.text isEqual:@""])
        text = @"Please fill Confirm Password";
    else if([_email.text isEqual:@""])
        text = @"Please fill Email";
    else if(![_password.text isEqual:_confirm_password.text])
        text = @"Password and Confirm Password are not same";
    else if ([emailTest evaluateWithObject:_email.text] == NO)
        text = @"Please fill the valid email address";

    if([text isEqual:@""])
        [self registerRequest];
    else
        [self showAlert:text];
}

/* 
 Show alert message for displaying validations
 */
-(void)showAlert:(NSString*)text
{
    [[[UIAlertView alloc] initWithTitle: nil
                                message:text
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

/*
 Function called for navigation back to Login screen
 */
-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 
 API request for register.
 */
-(void)registerRequest
{
    @try {
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
      
        NSURL *url = [NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/registerUser"];
        
        NSDictionary *requestData = @{@"FirstName":_firstname.text,
                                      @"LastName": _password.text,
                                      @"password": _password.text,
                                      @"email": _email.text
                                      };
        
        NSError *error;
      
        NSData *postData = [NSJSONSerialization dataWithJSONObject: requestData options:0 error:&error];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        __block BOOL success = NO;
        
        [NSURLConnection
         sendAsynchronousRequest:request
         queue:queue
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error) {
             if ([data length] >0 && error == nil){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     success = YES;
                 });
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (success) {
                         [activityIndicator stopAnimating];
                         activityIndicator.hidden = YES;
                         [self parseRegisterResponse:data];
                     }
                     else
                     {
                         
                     }
                 });
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"Empty Response, not sure why?");
             }
             else if (error != nil){
                 NSLog(@"%@", error.description);
             }
         }];
    }
    @catch (NSException *exception) {
    }
}

/*
 Parsing JSON on Register response
 */
- (void) parseRegisterResponse:(NSData *) data {
    @try
    {
        NSError *error = nil;
        id jsonDict = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:NSJSONReadingAllowFragments
                       error:&error];
        NSLog(@"%@", jsonDict);
        
        if(jsonDict != nil)
        {
            [[[UIAlertView alloc] initWithTitle: @"Success"
                                        message:@"You have been registered successfully. Please confirm the mail we just sent you on your email."
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
    @catch(NSException *ex)
    {
    }
}

/*
 AlertView action for dismissing the alertView
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
