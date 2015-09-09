//
//  LoginViewController.m
//  Iomhanna
//
//  Created by Spadez Family on 04/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import "LoginViewController.h"
#import "SendAllDataViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize textfield_password, textfield_userID, button_login, button_register;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    [self.view addSubview:activityIndicator];
    activityIndicator.hidden = YES;
    textfield_userID.delegate = self;
    textfield_password.delegate = self;
    [textfield_password setReturnKeyType:UIReturnKeyDone];
    [textfield_userID setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    textfield_userID.text = @"";
    textfield_password.text = @"";
}

/*
 Function called on tapping login button
 */
-(IBAction)login:(id)sender
{
    if(![textfield_userID.text isEqual:@""] && ![textfield_password.text isEqual:@""])
        [self loginRequest];
    else
        [[[UIAlertView alloc] initWithTitle: @"Required"
                                    message:@"Please enter User ID and Password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
 Function called on tapping register button
 */
-(IBAction)registerUser:(id)sender
{
    [self performSegueWithIdentifier:@"RegisterScreen" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

/*
 API login request on server 
 */
-(void)loginRequest
{
    @try {
        
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        NSURL *url = [NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/loginUser"];
        
        NSDictionary *requestData = @{@"email":textfield_userID.text,
                                      @"password": textfield_password.text
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
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
             NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
             if(response == nil)
             {
                 [activityIndicator stopAnimating];
                 activityIndicator.hidden = YES;
                 [[[UIAlertView alloc] initWithTitle: @"Login failed"
                                             message:@"Invalid credentials"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
   
             }
             else if ([data length] >0 && error == nil){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     success = YES;
                 });
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (success) {
                         [activityIndicator stopAnimating];
                         activityIndicator.hidden = YES;
                         [self parseLoginResponse:data];
                     }
                     else
                     {
                         [activityIndicator stopAnimating];
                         activityIndicator.hidden = YES;
                     }
                 });
             }
             else if ([data length] == 0 && error == nil){
                 [activityIndicator stopAnimating];
                 activityIndicator.hidden = YES;
                 NSLog(@"Empty Response, not sure why?");
             }
             else if (error != nil){
                 [activityIndicator stopAnimating];
                 activityIndicator.hidden = YES;
                 NSLog(@"%@", error.description);
             }
         }];
    }
    @catch (NSException *exception) {
    }
}
/*
 JSON parsing of login response
 */
- (void) parseLoginResponse:(NSData *) data {
    @try
    {
        NSError *error = nil;
        id jsonDict = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:NSJSONReadingAllowFragments
                       error:&error];
        NSLog(@"%@", jsonDict);
        if([[NSString stringWithFormat:@"%@", jsonDict] intValue] == 1)
        {
            [[[UIAlertView alloc] initWithTitle: @"Login failed"
                                        message:@"Invalid credentials"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else if(jsonDict != nil)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", jsonDict] forKey:@"AuthToken"];
            
            [self performSegueWithIdentifier:@"CaptureView" sender:nil];
        }
    }
    @catch(NSException *ex)
    {
    }
}

@end
