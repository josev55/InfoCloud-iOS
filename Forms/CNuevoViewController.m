//
//  CNuevoViewController.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CNuevoViewController.h"
#import "CFormsParser.h"
#import "CAppDelegate.h"
#import "CNuevoItemCell.h"
#import "LoadingView.h"
#import "CConnectionHelper.h"
#import "CWebViewController.h"


@interface CNuevoViewController ()

@end

@implementation CNuevoViewController{
	CAppDelegate *appDelegate;
	LoadingView *loadingView;
	NSString *tmp;
	NSString *tmpName;
	CFormModel *model;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate = (CAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *myforms = [NSString stringWithFormat:@"%@/forms/myforms.xml",appDelegate.documentPath];
	CFormsParser *parser = [[CFormsParser alloc] initWithFile:myforms];
	[parser parse];
	self.mNuevoArray = [[parser formularios] copy];
	self.mNuevoTableView.dataSource = self;
	self.mNuevoTableView.delegate = self;
	[self.navigationController setTitle:@"Nuevo"];
	self.navigationItem.title = @"Nuevo";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.mNuevoArray count] == 0) {
		return 1;
	}
	return self.mNuevoArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"Cell";
	CNuevoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	CFormModel *formModel = (CFormModel*)[self.mNuevoArray objectAtIndex:indexPath.row];
	if (cell == nil) {
		cell = (CNuevoItemCell*)[[[NSBundle mainBundle] loadNibNamed:@"UINuevoCell" owner:self options:nil] objectAtIndex:0];
	}
	if ([self.mNuevoArray count] == 0) {
		cell.mNuevoLabel.text = @"No hay datos disponibles";
	} else {
		cell.mNuevoLabel.text = formModel.name;
		cell.mNuevoImage.image = [UIImage imageNamed:@"document.png"];
		NSString *formPath = [NSString stringWithFormat:@"%@/forms/%@",appDelegate.documentPath,formModel.directoryName];
		if (![[NSFileManager defaultManager] fileExistsAtPath:formPath]) {
			cell.mNuevoImage.image = [UIImage imageNamed:@"download.png"];
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnImageTap:)];
			[cell.mNuevoImage addGestureRecognizer:tapGestureRecognizer];
		}
	}
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self.mNuevoArray count] == 0) {
		return self.mNuevoTableView.bounds.size.height;
	}
	return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	model = (CFormModel *)[self.mNuevoArray objectAtIndex:indexPath.row];
	NSString *formFile = [NSString stringWithFormat:@"%@/forms/%@/%@",appDelegate.documentPath,model.directoryName,model.mainHtml];
	NSLog(@"%@",formFile);
	tmp = formFile;
	tmpName = model.name;
	if ([[NSFileManager defaultManager] fileExistsAtPath:formFile]) {
		[self performSegueWithIdentifier:@"webview" sender:nil];
	}
}

//End of UITableView DataSource

-(void) OnImageTap:(id) sender{
	if ([[[[sender view] superview] superview] isKindOfClass:[CNuevoItemCell class]]) {
		CNuevoItemCell *itemCell = (CNuevoItemCell*)[[[sender view] superview] superview];
		NSIndexPath *indexPath = [self.mNuevoTableView indexPathForCell:itemCell];
		NSLog(@"%@",[[self.mNuevoArray objectAtIndex:indexPath.row] directoryName]);
		loadingView = [LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
		if (self.httpManager == nil) {
			self.httpManager = [[CHttpDownload alloc] init];
			self.httpManager.delegate = self;
		}
		model = (CFormModel *)[self.mNuevoArray objectAtIndex:indexPath.row];
		NSString *url = [NSString stringWithFormat:@"%@/%@.zip",[CConnectionHelper getRepoURL],model.directoryName];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[self.httpManager startAsynchronousRequest:request delegate:self andFormModel:model];
	}
}

-(void)didFinishedDownload:(NSString *)destination{
	[loadingView removeView];
	[self.mNuevoTableView reloadData];
}

-(void)didFailWithError:(NSError *)error{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Hubo un error al descargar el archivo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
		[loadingView removeView];
	});
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([[segue identifier] isEqualToString:@"webview"]) {
		CWebViewController *view = [segue destinationViewController];
		[view setHtmlFile:tmp];
		[view setFormName:tmpName];
		[view setFormModel:model];
		
	}
}
@end