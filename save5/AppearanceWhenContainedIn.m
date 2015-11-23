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
                                                                                                        [UIFont fontWithName:@"GeezaPro-Bold" size:16.0], NSFontAttributeName,
                                                                                                        [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:58.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                                                        nil]
                                                                                             forState:UIControlStateNormal];

    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:58.0/255.0 alpha:1.0],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIFont systemFontOfSize: 17.0], NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
   
}

@end
