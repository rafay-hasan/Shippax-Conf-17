//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
#import "SpeakerWebServiceObject.h"
#import "HomeWebServiceObject.h"

@implementation RHWebServiceManager


-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del
{
    if (self=[super init])
    {
        self.delegate = del;
        self.requestType = reqType;
    }
    
    return self;
}


-(void)getDataFromWebURL:(NSString *)requestURL
{
    
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain", nil];
    
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSInteger statusCode = operation.response.statusCode;
         
         
         NSLog(@"status code is %@",responseObject);
         
//         if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//         {
//             [self.delegate dataFromWebReceivedSuccessfully:responseObject];
//         }
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             if(self.requestType == HTTPRequestTypeSpeakers)
             {
                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                 {
                     [self.delegate dataFromWebReceivedSuccessfully:[self parseAllSpeakerItems:responseObject]];
                 }
             }
             else if(self.requestType == HTTPRequestTypeProgramme)
             {
                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                 {
                     [self.delegate dataFromWebReceivedSuccessfully:[self parseAllSpeakerItems:responseObject]];
                 }
             }
             else if(self.requestType == HTTPRequestTypeHome)
             {
                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                 {
                     [self.delegate dataFromWebReceivedSuccessfully:[self parseAllHomeItems:responseObject]];
                 }
             }
             else if(self.requestType == HTTPRequestTypeExhibitor)
             {
                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                 {
                     [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                 }
             }
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"error is %@",error.description);
         
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             //DebugLog(@"Object conforms this protocol.");
             if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
             {
                 // DebugLog(@"Object responds to this selector.");
                 [self.delegate dataFromWebReceiptionFailed:error];
             }
             else
             {
                 //DebugLog(@"Object Doesn't respond to this selector.");
             }
         }
         else
         {
             //DebugLog(@"Object Doesn't conform this protocol.");
         }
         
     }
     ];
    
    
}

-(void)getPostXMLDataFromWebURL:(NSString *)requestURL bookingNumber:(NSString *)bookingNo lastName:(NSString *)lastName methodName:(NSString *)methodName
{
    
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *ua = @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25";
    [requestSerializer setValue:ua forHTTPHeaderField:@"User-Agent"];
    //    [requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-type"];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
     NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"method",bookingNo,@"params[0]",lastName,@"params[1]",nil];
    
    [manager POST:requestURL
       parameters:postData
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSData * data = (NSData *)responseObject;
              NSString *fetchedXML = [NSString stringWithCString:[data bytes] encoding:NSISOLatin1StringEncoding];
              NSLog(@"Response string: %@", fetchedXML );
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(NSMutableArray *) parseAllSpeakerItems :(id) response
{
    NSMutableArray *speakerItemsArray = [NSMutableArray new];
    
    NSArray *tempArray = (NSArray *)response;
    for(NSInteger i = 0; i< tempArray.count; i++)
    {
        SpeakerWebServiceObject *object = [SpeakerWebServiceObject new];
        
        object.speakerName = [[NSAttributedString alloc] initWithData:[[[tempArray objectAtIndex:i] valueForKey:@"title"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        object.speakerDetails = [[tempArray objectAtIndex:i]valueForKey:@"description"];
        object.speakerImageUrlStr = [[tempArray objectAtIndex:i]valueForKey:@"imageUrl"];
        
        [speakerItemsArray addObject:object];
    }
    
    return speakerItemsArray;
}

-(NSMutableArray *) parseAllHomeItems :(id) response
{
    NSMutableArray *homeItemsArray = [NSMutableArray new];
    
    NSArray *tempArray = (NSArray *)response;
    for(NSInteger i = 0; i< tempArray.count; i++)
    {
        HomeWebServiceObject *object = [HomeWebServiceObject new];
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"title"] isKindOfClass:[NSString class]])
        {
            object.homeTitle  = [[tempArray objectAtIndex:i] valueForKey:@"title"];
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"description"] isKindOfClass:[NSString class]])
        {
            object.homeDescription  = [[tempArray objectAtIndex:i] valueForKey:@"description"];
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"imageUrl"] isKindOfClass:[NSString class]])
        {
            object.homeImageUrlStr  = [[tempArray objectAtIndex:i] valueForKey:@"imageUrl"];
        }
        
        
        [homeItemsArray addObject:object];
    }
    
    return homeItemsArray;
}


-(NSMutableArray *) parseAllTopLevelItems :(id) response
{
    
//    NSArray *tempArray = (NSArray *)response;
//    
//    for(NSInteger i = 0; i< tempArray.count; i++)
//    {
//        if([[[tempArray objectAtIndex:i] valueForKey:@"template"] isEqualToString:@"page_home.php"])
//        {
//            
//            if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//                [TopLevelObjectsSharedInstances sharedInstance].homeParenStrUrl = [NSString stringWithFormat:@"%@%@&filter[orderby]=menu_order&per_page=100&filter[order]=asc",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].homeParenStrUrl = @"";
//            
//            
//            if([[[tempArray objectAtIndex:i] valueForKey:@"featured_image_source_url"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].HomeImageUrlStr = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"featured_image_source_url"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].HomeImageUrlStr = @"";
//            
//            
//           if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].homeContentString = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].homeContentString = @"";
//
//            
//            
//            
//        }
//        else if([[[tempArray objectAtIndex:i] valueForKey:@"template"] isEqualToString:@"page_exhibitor.php"])
//        {
//            
//            if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//                [TopLevelObjectsSharedInstances sharedInstance].exibitorParenStrUrl = [NSString stringWithFormat:@"%@%@&filter[orderby]=menu_order&per_page=100&filter[order]=asc",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].exibitorParenStrUrl = @"";
//            
//            
//            if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].exibitorContentString = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].exibitorContentString = @"";
//            
//            
//        }
//        else if([[[tempArray objectAtIndex:i] valueForKey:@"template"] isEqualToString:@"page_programme.php"])
//        {
//            
//            if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//                [TopLevelObjectsSharedInstances sharedInstance].programmeParenStrUrl = [NSString stringWithFormat:@"%@%@&filter[orderby]=menu_order&per_page=100&filter[order]=asc",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].programmeParenStrUrl = @"";
//            
//            
//            if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].programmeContentString = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].programmeContentString = @"";
//
//            
//        }
//        else if([[[tempArray objectAtIndex:i] valueForKey:@"template"] isEqualToString:@"page_speaker.php"])
//        {
//            if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//                [TopLevelObjectsSharedInstances sharedInstance].speakersparentUrlString = [NSString stringWithFormat:@"%@%@&filter[orderby]=menu_order&per_page=100&filter[order]=asc",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].speakersparentUrlString = @"";
//            
//            
//            if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].speakerContentString = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].speakerContentString = @"";
//        }
//        else if([[[tempArray objectAtIndex:i] valueForKey:@"template"] isEqualToString:@"page_about.php"])
//        {
//            if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//                [TopLevelObjectsSharedInstances sharedInstance].aboutPageUrlString = [NSString stringWithFormat:@"%@%@&filter[orderby]=menu_order&per_page=100&filter[order]=asc",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].aboutPageUrlString = @"";
//            
//            
//            if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//                [TopLevelObjectsSharedInstances sharedInstance].aboutPagerContentString = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//            else
//                [TopLevelObjectsSharedInstances sharedInstance].aboutPagerContentString = @"";
//        }
//
//        
//    }
    
    return nil;
}



//-(NSMutableArray *) parseAllHomeItems :(id) response
//{
//    NSMutableArray *homeItemsArray = [NSMutableArray new];
//    
//    NSArray *tempArray = (NSArray *)response;
//    
//    
//    //NSLog(@"array is %@",tempArray);
//    
//    for(NSInteger i = 0; i < tempArray.count; i++)
//    {
//        ;
//    }
//    
//    return homeItemsArray;
//}

-(NSMutableArray *) parseAllChildItems :(id) response
{
    NSMutableArray *childItemsArray = [NSMutableArray new];
    
    NSArray *tempArray = (NSArray *)response;
    
   // NSLog(@"response is %@",tempArray);
    
    
//    for(NSInteger i = 0; i < tempArray.count; i++)
//    {
//        ChildObject *object = [ChildObject new];
//        
//        if([[[tempArray objectAtIndex:i] valueForKey:@"id"] isKindOfClass:[NSNumber class]])
//            object.childId = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"id"]];
//        else
//            object.childId = @"";
//        
//        
//        if([[[[tempArray objectAtIndex:i] valueForKey:@"title"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//            object.childTitle = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"title"] valueForKey:@"rendered"]];
//        else
//            object.childTitle = @"";
//
//        
//        if([[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"] isKindOfClass:[NSString class]])
//            object.childDescription = [NSString stringWithFormat:@"%@",[[[tempArray objectAtIndex:i] valueForKey:@"content"] valueForKey:@"rendered"]];
//        else
//            object.childDescription = @"";
//        
//        
//        if([[[tempArray objectAtIndex:i] valueForKey:@"featured_image_source_url"] isKindOfClass:[NSString class]])
//            object.childImageUrlStr = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"featured_image_source_url"]];
//        else
//            object.childImageUrlStr = @"";
//        
//        
//        [childItemsArray addObject:object];
//
//        
//    }
    
    return childItemsArray;
}



@end
