//
//  ViewController.m
//  GoogleMapAPIDemo
//
//  Created by Shubham on 01/05/17.
//  Copyright © 2017 Shubham. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    CLLocationManager *manager;
    CLLocation *currentLocation;
    GMSPlacesClient *placeClient;
    float zoomLevel;
    float lattitude;
    float longitude;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    zoomLevel = 15.0;
    [self getCurrentPosition];
    [self loadMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getCurrentPosition{
    
    manager = [[CLLocationManager alloc] init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager requestAlwaysAuthorization];
    manager.distanceFilter = 50.0;
    [manager startUpdatingLocation ];
    manager.delegate = self;
    
    placeClient = [GMSPlacesClient sharedClient];
    
}

-(void)loadMapView{
    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:lattitude longitude:longitude zoom:zoomLevel];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    mapView.myLocationEnabled = true;
    self.view = mapView;
    
    
    //create a marker in center of map
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lattitude, longitude);
    marker.map = mapView;
    
    [placeClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
        }
        
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    currentLocation = locations.lastObject;
    lattitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Error : %@",error);
}
@end
