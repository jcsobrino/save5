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
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], nil] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                        [UIFont systemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                        [UIColor colorWithRed:233.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                                                        nil]
                                                                                             forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha: 0.8],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIFont systemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateDisabled];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];

    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:233.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1.0],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIFont systemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
   
}

@end
