//
//  AppearanceWhenContainedIn.m
//  DownloadTube
//
//  Created by Carlos on 18/11/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "AppearanceWhenContainedIn.h"

@implementation AppearanceWhenContainedIn


+ (void)setAppearance
{
    //[[UIView appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setBackgroundColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], nil] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                        [UIFont boldSystemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                        [UIColor colorWithRed:218.0/255.0 green:153.0/255.0 blue:102.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                                                        nil]
                                                                                             forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha: 0.8],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIFont boldSystemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateDisabled];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                                                      [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0],
//                                                                                                      UITextAttributeTextColor,
//                                                                                                      [UIFont boldSystemFontOfSize: 17.0], NSFontAttributeName,
//                                                                                                      nil]
//                                                                                            forState:UIControlStateSelected];
    
    
//     [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"boton_blanco.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:0 green:117.0/255.0 blue:216.0/255.0 alpha:1.0],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIFont boldSystemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
   

//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:[UIImage imageNamed:@"boton_rojo_2.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

@end
