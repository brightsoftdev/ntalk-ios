//
//  BaseViewController.m
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "BaseViewController.h"

#define LOCAL_URL 1
#define TEST_URL 2
#define PRODUCTION_URL 3
#define URL_MODE LOCAL_URL

@interface BaseViewController () 
- (NSString*) appendTokenToURL:(NSString*)baseUrl;
- (NSString*) appendBaseToURL:(NSString*)url;
@end

@implementation BaseViewController
#pragma mark - HTTP requests

- (ASIHTTPRequest*) requestWithURL:(NSString*) s {
    s = [self appendBaseToURL:s];
    DebugLog(@"haciendo peticion a %@", s);
    
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (ASIHTTPRequest*) requestWithURL:(NSString*) s tokenIncluded:(BOOL)token {
    if (token) {
        s = [self appendTokenToURL:s];
    }
    return [self requestWithURL:s];
}

- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s {
    s = [self appendBaseToURL:s];
    DebugLog(@"haciendo peticion a %@", s);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s tokenIncluded:(BOOL)token {
    if (token) {
        s = [self appendTokenToURL:s];
    }
    return [self formRequestWithURL:s];
}

- (NSString*) appendTokenToURL:(NSString*)baseUrl {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"];
    NSString *url = [baseUrl stringByAppendingString:@"?auth_token=%@"];
    url = [NSString stringWithFormat:url, token];
    return url;
}

- (NSString *)appendBaseToURL:(NSString *)url {
    NSString *base;
    
    switch (URL_MODE) {
        case PRODUCTION_URL:
            base = @"http://www.ntalkapp.com";
            break;
        case TEST_URL:
            base = @"http://ntalkntalk.heroku.com";
            break;
        case LOCAL_URL:
        default:
            base = @"http://ntalk.dev";
            break;
    }
    
    return [base stringByAppendingString:url];
}

- (void) addRequest:(ASIHTTPRequest*)request {
	[request setDelegate:self];
	if (!requests) {
		requests = [[NSMutableArray alloc] initWithCapacity:3];
	} else {
		[self clearFinishedRequests];
	}
	[requests addObject:request];
}

- (void) clearFinishedRequests {
	NSMutableArray* toremove = [[NSMutableArray alloc] initWithCapacity:[requests count]];
	for (ASIHTTPRequest* r in requests) {
		if ([r isFinished]) {
			[toremove addObject:r];
		}
	}
	
	for (ASIHTTPRequest* r in toremove) {
		[requests removeObject:r];
	}
	[toremove release];
}

- (void) cancelRequests {
	for (ASIHTTPRequest* r in requests) {
		r.delegate = nil;
		[r cancel];
	}	
	[requests removeAllObjects];
}

- (void) refreshCellsWithImage:(UIImage*)image fromURL:(NSURL*)url inTable:(UITableView*)tableView {
    NSArray *cells = [tableView visibleCells];
    [cells retain];
    SEL selector = @selector(imageLoaded:withURL:);
    for (int i = 0; i < [cells count]; i++) {
		UITableViewCell* c = [[cells objectAtIndex: i] retain];
        if ([c respondsToSelector:selector]) {
            [c performSelector:selector withObject:image withObject:url];
        }
        [c release];
		c = nil;
    }
    [cells release];
}

#pragma mark - UIViewController

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - Memory management

- (void)dealloc {
	[self cancelRequests];
	[requests release];
	
    [super dealloc];
}


@end
