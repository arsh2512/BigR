//
//  MapVC.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 11/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapKit: MKMapView!
    var lat = Double()
    var longi = Double()
    var name = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        mapKit.delegate = self
        let london = MKPointAnnotation()
        london.title = name
        london.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: longi)
        mapKit.addAnnotation(london)
        
        
        let viewRegion = MKCoordinateRegion(center: london.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapKit.setRegion(viewRegion, animated: false)
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
