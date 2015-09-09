//
//  ImagesViewController.h
//  Iomhanna
//
//  Created by Spadez Family on 25/08/15.
//  Copyright (c) 2015 Spadez Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *buttonHint;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView1;
@property(nonatomic, retain) IBOutlet UIImageView *imageView2;
@property(nonatomic, retain) IBOutlet UIButton *retake1;
@property(nonatomic, retain) IBOutlet UIButton *retake2;
@property(nonatomic, retain) UIImage *image1;
@property(nonatomic, retain) UIImage *image2;

-(IBAction)retake:(id)sender;

@end
