//
//  SendAllDataViewController.m
//  Iomhanna
//
//  Created by Spadez Family on 18/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import "SendAllDataViewController.h"
#import "MBProgressHUD.h"

typedef void(^dataCompletion)(BOOL);
typedef void(^uploadImage2)(BOOL);

@interface SendAllDataViewController ()

@end

@implementation SendAllDataViewController

@synthesize _txtDescription, _switchPriority, image, _imageView, _imageView2, image2, button_upload, txt_position, txt_position2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Set data";
    _txtDescription.layer.borderColor = [[UIColor blackColor]CGColor];
    _txtDescription.layer.borderWidth = 0.3;
    _txtDescription.text = @"Description";
    _txtDescription.textColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = NO;
    [self.view addSubview:activityIndicator];
    activityIndicator.hidden = YES;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [_txtDescription setInputAccessoryView:toolbar];
    
    pickerPosition = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    [pickerPosition setDataSource: self];
    [pickerPosition setDelegate: self];
    pickerPosition.showsSelectionIndicator = YES;

    pickerPosition2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    [pickerPosition2 setDataSource: self];
    [pickerPosition2 setDelegate: self];
    pickerPosition2.showsSelectionIndicator = YES;
    
    txt_position.inputView = pickerPosition;
    [txt_position setInputAccessoryView:toolbar];
    txt_position.text = @"Left";
    
    txt_position2.inputView = pickerPosition2;
    [txt_position2 setInputAccessoryView:toolbar];
    txt_position2.text = @"Right";
    
    arrPosition = [NSArray arrayWithObjects:@"Left", @"Right", nil];
    if(image != nil)
        _imageView.image = [self imageWithImage:image scaledToSize:_imageView.frame.size];
    
    if(image2 != nil)
        _imageView2.image = [self imageWithImage:image2 scaledToSize:_imageView2.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* 
Number of components in picker
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/* 
Number of rows in picker
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrPosition count];
}

/* 
 Set picker row title
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrPosition objectAtIndex:row];
}

/* 
 Perform action on selecting picker row
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == pickerPosition)
        txt_position.text = [arrPosition objectAtIndex:row];
    else
        txt_position2.text = [arrPosition objectAtIndex:row];
}

/*
 Hide keyboard after Done / Return button press
 */
-(void) resignKeyboard
{
    [_txtDescription resignFirstResponder];
    [txt_position resignFirstResponder];
    [txt_position2 resignFirstResponder];
}

/* 
 Function to move the view up/down whenever the keyboard is shown/dismissed
 */
- (void) animateTextField: (BOOL) up
{
    const int movementDistance = 100;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/* 
 Function called when the user begin editing text view
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}

/* 
 Method gets called when the user ends editing text view 
 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Description";
        textView.textColor = [UIColor grayColor];
    }
    
    [textView resignFirstResponder];
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
 Upload button action
 */
-(IBAction)uploadAction:(id)sender
{
    [self sendData];
}

/*
 Send the data on server
 */
-(void)sendData
{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    if(image != nil)
        [self uploadRequest];
    else if(image2 != nil)
        [self upload2Request:image2];
    else
        [self sendAllDataRequest];
}

/* 
 API request for uploading first image on server. 
 */
-(void)uploadRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/UploadImage"]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            [self parseUploadPhotoResponse:data];
        }
    }];
}
/* API request for uploading second image on server.
 */
-(void)upload2Request:(UIImage*)img
{
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/UploadImage"]];
    
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            [self parseUploadPhotoResponse2:data];
        }
    }];
}

/* 
 Parsing JSON for upload the first image  
 */
- (void) parseUploadPhotoResponse:(NSData *) data {
    @try
    {
        NSError *error = nil;
        id jsonDict = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:NSJSONReadingAllowFragments
                       error:&error];
        NSLog(@"%@", jsonDict);
        if(jsonDict != nil && [jsonDict count] > 0)
        {
            for(int i = 0; i< [jsonDict count]; i++)
            {
                [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectAtIndex:i] forKey:@"ImagePath"];
            }
            
            [self sendAllDataRequest];
          
        }
        else
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            [[[UIAlertView alloc] initWithTitle: @"Upload failed"
                                        message:@"Cannot upload image"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
    }
    @catch(NSException *ex)
    {
    }
}
/* 
 Parsing JSON for upload the second image  
 */
- (void) parseUploadPhotoResponse2:(NSData *) data {
    @try
    {
        NSError *error = nil;
        id jsonDict = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:NSJSONReadingAllowFragments
                       error:&error];
        NSLog(@"%@", jsonDict);
        if(jsonDict != nil && [jsonDict count] > 0)
        {
            for(int i = 0; i< [jsonDict count]; i++)
            {
                [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectAtIndex:i] forKey:@"ImagePath"];
            }
            
            [self sendAllDataRequest2];
            
        }
        else
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            [[[UIAlertView alloc] initWithTitle: @"Upload failed"
                                        message:@"Cannot upload image"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
    }
    @catch(NSException *ex)
    {
    }
}
/* 
 API request for send all data for first image on server.
 */
-(void)sendAllDataRequest
{
    @try {
        NSURL *url = [NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/InsertImage"];
        NSDictionary *requestData = @{@"Description":_txtDescription.text,
                                      @"Position":[txt_position.text isEqual:@"Left"] ? @"L" : @"R",
                                      @"Status": _switchPriority.on?@"High" : @"Low",
                                      @"ImageURL" : [[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"] == nil ? @"" : [[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],
                                      @"imgAuthToken" : [[NSUserDefaults standardUserDefaults]objectForKey:@"AuthToken"]
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
                         
                         [self parseAllDataResponse:data];
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
 Parsing JSON for all data for first image response
 */
- (void) parseAllDataResponse:(NSData *) data {
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
            if(image2 != nil)
                [self upload2Request:image2];
            else
            {
                [activityIndicator stopAnimating];
                activityIndicator.hidden = YES;
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                hud.mode = MBProgressHUDModeText;
                if(image != nil || image2 != nil)
                    hud.labelText = @"Image uploaded successfully";
                else
                    hud.labelText = @"Data uploaded successfully";
                hud.margin = 10.f;
                hud.yOffset = 150.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            [[[UIAlertView alloc] initWithTitle: @"Upload failed"
                                        message:@"Cannot upload image"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        
        
    }
    @catch(NSException *ex)
    {
    }
}
/* 
 API request for send all data for second image on server.
 */
-(void)sendAllDataRequest2
{
    @try {
        
        NSURL *url = [NSURL URLWithString:@"http://lomhanna.spadez.co/api/SecureAccess/InsertImage"];
        
        
        NSDictionary *requestData = @{@"Description":_txtDescription.text,
                                      @"Position":[txt_position2.text isEqual:@"Left"] ? @"L" : @"R",
                                      @"Status": _switchPriority.on?@"High" : @"Low",
                                      @"ImageURL" : [[NSUserDefaults standardUserDefaults]objectForKey:@"ImagePath"],
                                      @"imgAuthToken" : [[NSUserDefaults standardUserDefaults]objectForKey:@"AuthToken"]
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
                         
                         [self parseAllDataResponse2:data];
                     }
                     else
                     {
                         [activityIndicator stopAnimating];
                         activityIndicator.hidden = YES;
                         [[[UIAlertView alloc] initWithTitle: @"Upload failed"
                                                     message:@"Cannot upload image"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] show];
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
 Parsing JSON for  all data response for second image 
 */
- (void) parseAllDataResponse2:(NSData *) data {
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
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"Image uploaded successfully";
                hud.margin = 10.f;
                hud.yOffset = 150.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            [[[UIAlertView alloc] initWithTitle: @"Upload failed"
                                        message:@"Cannot upload image"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        
        
    }
    @catch(NSException *ex)
    {
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
