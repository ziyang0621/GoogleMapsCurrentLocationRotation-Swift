//
//  ViewController.swift
//  GoogleMapSwift
//
//  Created by Ziyang Tan on 2/10/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 190.0/M_PI
    }
    
    func DegreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    var GeoAngle = 0.0
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView

        marker.map = mapView
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var camera = GMSCameraPosition.cameraWithLatitude(newLocation.coordinate.latitude,
            longitude: newLocation.coordinate.longitude, zoom: 15)
        (self.view as GMSMapView).animateToCameraPosition(camera)
        
        GeoAngle = self.setLatLonForDistanceAndAngle(newLocation)
        marker.position = newLocation.coordinate
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        var direction = -newHeading.trueHeading as Double
        marker.icon = self.imageRotatedByDegrees(CGFloat(direction), image: UIImage(named: "arrow.png")!)
    }
    
    
    func imageRotatedByDegrees(degrees: CGFloat, image: UIImage) -> UIImage{
        var size = image.size
        
        UIGraphicsBeginImageContext(size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(context, 0.5*size.width, 0.5*size.height)
        CGContextRotateCTM(context, CGFloat(DegreesToRadians(Double(degrees))))
        
        image.drawInRect(CGRect(origin: CGPoint(x: -size.width*0.5, y: -size.height*0.5), size: size))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func setLatLonForDistanceAndAngle(userLocation: CLLocation) -> Double {
        var lat1 = DegreesToRadians(userLocation.coordinate.latitude)
        var lon1 = DegreesToRadians(userLocation.coordinate.longitude)
        
        var lat2 = DegreesToRadians(37.7833);
        var lon2 = DegreesToRadians(-122.4167);
        
        var dLon = lon2 - lon1;
        
        var y = sin(dLon) * cos(lat2);
        var x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        var radiansBearing = atan2(y, x);
        if(radiansBearing < 0.0)
        {
            radiansBearing += 2*M_PI;
        }
        
        return radiansBearing;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

