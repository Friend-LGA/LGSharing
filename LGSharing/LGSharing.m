//
//  LGSharing.m
//  LGSharing
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGSharing)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGSharing.h"

@implementation LGSharingObject

@end

@interface LGSharing () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *vkAppId;
@property (strong, nonatomic) NSString *googlePlusClientId;
@property (strong, nonatomic) NSString *googlePlusDeepLinkId;

@property (strong, nonatomic) NSMutableArray *sharingObjects;

@property (strong, nonatomic) NSString *emailAlertTitle;
@property (strong, nonatomic) NSString *emailAlertMessage;
@property (strong, nonatomic) NSString *smsAlertTitle;
@property (strong, nonatomic) NSString *smsAlertMessage;

@property (strong, nonatomic) void (^emailCompletionHandler)(MFMailComposeResult result, NSError *error);
@property (strong, nonatomic) void (^emailDismissCompletionHandler)();
@property (assign, nonatomic, getter=isEmailAnimated) BOOL emailAnimated;

@property (strong, nonatomic) void (^smsCompletionHandler)(MessageComposeResult result);
@property (strong, nonatomic) void (^smsDismissCompletionHandler)();
@property (assign, nonatomic, getter=isSmsAnimated) BOOL smsAnimated;

@property (strong, nonatomic) void (^presentCompletionHandler)(LGSharingDestination destination);
@property (strong, nonatomic) void (^completionHandler)(LGSharingObject *object);
@property (strong, nonatomic) void (^dismissCompletionHandler)(LGSharingDestination destination);

@end

@implementation LGSharing

+ (instancetype)sharedManagerWithNavigationController:(UINavigationController *)navigationController
                                              vkAppId:(NSString *)vkAppId
                                   googlePlusClientId:(NSString *)googlePlusClientId
                                 googlePlusDeepLinkId:(NSString *)googlePlusDeepLinkId
{
    static dispatch_once_t once;
    static id sharedManager;
    
    dispatch_once(&once, ^(void)
                  {
                      sharedManager = [super new];
                      
                      [(LGSharing *)sharedManager setNavigationController:navigationController];
                      [(LGSharing *)sharedManager setVkAppId:vkAppId];
                      [(LGSharing *)sharedManager setGooglePlusClientId:googlePlusClientId];
                      [(LGSharing *)sharedManager setGooglePlusDeepLinkId:googlePlusDeepLinkId];
                      
                      [(LGSharing *)sharedManager setEmailAlertMessage:@"Укажите почтовый аккаунт в настройках вашего устройста."];
                      [(LGSharing *)sharedManager setSmsAlertMessage:@"Ваше устройство не предназначено для отправки сообщений."];
                  });
    
    return sharedManager;
}

#pragma mark -

- (void)showActionSheetWithDestinations:(LGSharingDestination)destinations
                              shareText:(NSString *)text
                              shareLink:(NSString *)link
               presentCompletionHandler:(void(^)(LGSharingDestination destination))presentCompletionHandler
                      completionHandler:(void(^)(LGSharingObject *object))completionHandler
               dismissCompletionHandler:(void(^)(LGSharingDestination destination))dismissCompletionHandler
{
    [self showActionSheetWithDestinations:(LGSharingDestination)destinations
                             setupHandler:^(LGSharingObject *object)
     {
         object.text = text;
         object.link = link;
     }
                 presentCompletionHandler:presentCompletionHandler
                        completionHandler:completionHandler
                 dismissCompletionHandler:dismissCompletionHandler];
}

- (void)showActionSheetWithDestinations:(LGSharingDestination)destinations
                           setupHandler:(void(^)(LGSharingObject *object))setupHandler
               presentCompletionHandler:(void(^)(LGSharingDestination destination))presentCompletionHandler
                      completionHandler:(void(^)(LGSharingObject *object))completionHandler
               dismissCompletionHandler:(void(^)(LGSharingDestination destination))dismissCompletionHandler
{
    _sharingObjects = [NSMutableArray new];
    _presentCompletionHandler = presentCompletionHandler;
    _completionHandler = completionHandler;
    _dismissCompletionHandler = dismissCompletionHandler;
    
    if (destinations & LGSharingDestinationVkontakte || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationVkontakte;
        object.buttonTitle = @"ВКонтакте";
        [_sharingObjects addObject:object];
    }
    
    if (destinations & LGSharingDestinationFacebook || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationFacebook;
        object.buttonTitle = @"Facebook";
        [_sharingObjects addObject:object];
    }
    
    if (destinations & LGSharingDestinationTwitter || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationTwitter;
        object.buttonTitle = @"Twitter";
        [_sharingObjects addObject:object];
    }
    
    if (destinations & LGSharingDestinationGooglePlus || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationGooglePlus;
        object.buttonTitle = @"Google+";
        [_sharingObjects addObject:object];
    }
    
    if (destinations & LGSharingDestinationEmail || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationEmail;
        object.buttonTitle = @"E-Mail";
        [_sharingObjects addObject:object];
    }
    
    if (destinations & LGSharingDestinationSMS || destinations == LGSharingDestinationAll)
    {
        LGSharingObject *object = [LGSharingObject new];
        object.destination = LGSharingDestinationSMS;
        object.buttonTitle = NSLocalizedString(@"SMS", nil);
        [_sharingObjects addObject:object];
    }
    
    // -----
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (LGSharingObject *object in _sharingObjects)
    {
        if (setupHandler) setupHandler(object);
        
        [actionSheet addButtonWithTitle:object.buttonTitle];
    }
    
    [actionSheet showInView:_navigationController.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && buttonIndex != actionSheet.destructiveButtonIndex)
    {
        LGSharingObject *object = _sharingObjects[buttonIndex-1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                       {
                           __weak typeof(self) wself = self;
                           
                           if (object.destination == LGSharingDestinationVkontakte)
                           {
                               [self shareToVkontakteText:object.text
                                                     link:object.link
                                                 animated:YES
                                 presentCompletionHandler:^(void)
                                {
                                    if (_presentCompletionHandler) _presentCompletionHandler(LGSharingDestinationVkontakte);
                                }
                                        completionHandler:^(VKShareDialogControllerResult result)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }
                                 dismissCompletionHandler:^(void)
                                {
                                    if (_dismissCompletionHandler) _dismissCompletionHandler(LGSharingDestinationVkontakte);
                                }];
                           }
                           else if (object.destination == LGSharingDestinationFacebook)
                           {
                               [self shareToFacebookText:object.text
                                                    link:object.link
                                                animated:YES
                                presentCompletionHandler:^(void)
                                {
                                    if (_presentCompletionHandler) _presentCompletionHandler(LGSharingDestinationFacebook);
                                }
                                       completionHandler:^(SLComposeViewControllerResult result)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }
                                dismissCompletionHandler:^(void)
                                {
                                    if (_dismissCompletionHandler) _dismissCompletionHandler(LGSharingDestinationFacebook);
                                }];
                           }
                           else if (object.destination == LGSharingDestinationTwitter)
                           {
                               [self shareToTwitterText:object.text
                                                   link:object.link
                                               animated:YES
                               presentCompletionHandler:^(void)
                                {
                                    if (_presentCompletionHandler) _presentCompletionHandler(LGSharingDestinationTwitter);
                                }
                                      completionHandler:^(SLComposeViewControllerResult result)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }
                               dismissCompletionHandler:^(void)
                                {
                                    if (_dismissCompletionHandler) _dismissCompletionHandler(LGSharingDestinationTwitter);
                                }];
                           }
                           else if (object.destination == LGSharingDestinationGooglePlus)
                           {
                               [self shareToGooglePlusText:object.text
                                                      link:object.link
                                         completionHandler:^(NSError *error)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }];
                           }
                           else if (object.destination == LGSharingDestinationEmail)
                           {
                               [self shareToEmailText:object.text
                                                 link:object.link
                                             animated:YES
                             presentCompletionHandler:^(void)
                                {
                                    if (_presentCompletionHandler) _presentCompletionHandler(LGSharingDestinationEmail);
                                }
                                    completionHandler:^(MFMailComposeResult result, NSError *error)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }
                             dismissCompletionHandler:^(void)
                                {
                                    if (_dismissCompletionHandler) _dismissCompletionHandler(LGSharingDestinationEmail);
                                }];
                           }
                           else if (object.destination == LGSharingDestinationSMS)
                           {
                               [self shareToSmsText:object.text
                                               link:object.link
                                           animated:YES
                           presentCompletionHandler:^(void)
                                {
                                    if (_presentCompletionHandler) _presentCompletionHandler(LGSharingDestinationSMS);
                                }
                                  completionHandler:^(MessageComposeResult result)
                                {
                                    if (wself)
                                    {
                                        __strong typeof(wself) self = wself;
                                        
                                        if (self.completionHandler) self.completionHandler(object);
                                    }
                                }
                           dismissCompletionHandler:^(void)
                                {
                                    if (_dismissCompletionHandler) _dismissCompletionHandler(LGSharingDestinationSMS);
                                }];
                           }
                       });
    }
}

#pragma mark -

- (void)setEmailAlertTitle:(NSString *)title message:(NSString *)message
{
    _emailAlertTitle = title;
    _emailAlertMessage = message;
}

- (void)setSmsAlertTitle:(NSString *)title message:(NSString *)message
{
    _smsAlertTitle = title;
    _smsAlertMessage = message;
}

#pragma mark -

- (void)shareToVkontakteText:(NSString *)text
                        link:(NSString *)link
                    animated:(BOOL)animated
    presentCompletionHandler:(void(^)())presentCompletionHandler
           completionHandler:(void(^)(VKShareDialogControllerResult result))completionHandler
    dismissCompletionHandler:(void(^)())dismissCompletionHandler
{
    if (_vkAppId.length)
    {
        link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        LGSharingVkontakte *sharingVkontakteObject = [LGSharingVkontakte sharedManagerWithAppId:_vkAppId
                                                                           navigationController:_navigationController];
        
        [sharingVkontakteObject postWithText:text
                                        link:[NSURL URLWithString:link]
                                    animated:animated
                    presentCompletionHandler:presentCompletionHandler
                           completionHandler:completionHandler
                    dismissCompletionHandler:dismissCompletionHandler];
    }
    else NSLog(@"LGSharing WARNING: vkAppId is nil");
}

- (void)shareToFacebookText:(NSString *)text
                       link:(NSString *)link
                   animated:(BOOL)animated
   presentCompletionHandler:(void(^)())presentCompletionHandler
          completionHandler:(void(^)(SLComposeViewControllerResult result))completionHandler
   dismissCompletionHandler:(void(^)())dismissCompletionHandler
{
    SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [facebookVC setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         if (completionHandler) completionHandler(result);
         
         [_navigationController dismissViewControllerAnimated:animated completion:dismissCompletionHandler];
     }];
    
    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [facebookVC setInitialText:text];
    [facebookVC addURL:[NSURL URLWithString:link]];
    
    [_navigationController presentViewController:facebookVC animated:animated completion:presentCompletionHandler];
}

- (void)shareToTwitterText:(NSString *)text
                      link:(NSString *)link
                  animated:(BOOL)animated
  presentCompletionHandler:(void(^)())presentCompletionHandler
         completionHandler:(void(^)(SLComposeViewControllerResult result))completionHandler
  dismissCompletionHandler:(void(^)())dismissCompletionHandler
{
    SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [twitterVC setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         if (completionHandler) completionHandler(result);
         
         [_navigationController dismissViewControllerAnimated:animated completion:dismissCompletionHandler];
     }];
    
    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [twitterVC setInitialText:text];
    [twitterVC addURL:[NSURL URLWithString:link]];
    
    [_navigationController presentViewController:twitterVC animated:animated completion:presentCompletionHandler];
}

- (void)shareToGooglePlusText:(NSString *)text
                         link:(NSString *)link
            completionHandler:(void(^)(NSError *error))completionHandler
{
    if (_googlePlusClientId.length)
    {
        link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        LGSharingGooglePlus *sharingGooglePlusObject = [LGSharingGooglePlus sharedManagerWithClientId:_googlePlusClientId
                                                                                           deepLinkId:_googlePlusDeepLinkId];
        
        [sharingGooglePlusObject postWithText:text
                                         link:[NSURL URLWithString:link]
                            completionHandler:completionHandler];
    }
    else NSLog(@"LGSharing WARNING: googlePlusClientId is nil");
}

- (void)shareToEmailText:(NSString *)text
                    link:(NSString *)link
                animated:(BOOL)animated
presentCompletionHandler:(void(^)())presentCompletionHandler
       completionHandler:(void(^)(MFMailComposeResult result, NSError *error))completionHandler
dismissCompletionHandler:(void(^)())dismissCompletionHandler
{
    if ([MFMailComposeViewController canSendMail])
    {
        _emailCompletionHandler = completionHandler;
        _emailDismissCompletionHandler = dismissCompletionHandler;
        _emailAnimated = animated;
        
        link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:text];
        [mailViewController setMessageBody:link isHTML:NO];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [_navigationController presentViewController:mailViewController animated:animated completion:presentCompletionHandler];
    }
    else [[[UIAlertView alloc] initWithTitle:_emailAlertTitle
                                     message:_emailAlertMessage
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                           otherButtonTitles:nil] show];
}

- (void)shareToSmsText:(NSString *)text
                  link:(NSString *)link
              animated:(BOOL)animated
presentCompletionHandler:(void(^)())presentCompletionHandler
     completionHandler:(void(^)(MessageComposeResult result))completionHandler
dismissCompletionHandler:(void(^)())dismissCompletionHandler
{
    if ([MFMessageComposeViewController canSendText])
    {
        _smsCompletionHandler = completionHandler;
        _smsDismissCompletionHandler = dismissCompletionHandler;
        _smsAnimated = animated;
        
        MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
        messageViewController.messageComposeDelegate = self;
        [messageViewController setBody:[NSString stringWithFormat:@"%@\n\n%@", text, link]];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            messageViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [_navigationController presentViewController:messageViewController animated:animated completion:presentCompletionHandler];
    }
    else [[[UIAlertView alloc] initWithTitle:_smsAlertTitle
                                     message:_smsAlertMessage
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                           otherButtonTitles:nil] show];
}

#pragma mark -

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [LGSharingVkontakte applicationOpenURL:url sourceApplication:sourceApplication];
    [LGSharingGooglePlus applicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
}

#pragma mark - Mail/SMS Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (_emailCompletionHandler) _emailCompletionHandler(result, error);
    
    [_navigationController dismissViewControllerAnimated:_emailAnimated completion:_emailDismissCompletionHandler];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (_smsCompletionHandler) _smsCompletionHandler(result);
    
    [_navigationController dismissViewControllerAnimated:_smsAnimated completion:_smsDismissCompletionHandler];
}

@end
