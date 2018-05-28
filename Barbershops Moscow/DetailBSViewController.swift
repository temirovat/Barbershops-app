//
//  DetailBSViewController.swift
//  Barbershops Moscow
//
//  Created by Alan on 24/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class DetailBSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    

    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!

    var barber: Barber!
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? RateViewController else { return }
        guard let rating = svc.barberRating else { return }
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rateButton.layer.cornerRadius = 5
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.white.cgColor
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(data: barber!.image! as Data)
        
        mapView.layer.cornerRadius = 10
        //                mapView.layer.cornerRadius = 10
        //                mapView.clipsToBounds = true
        
        title = barber!.name
        
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(barber.location!) { (placemarks, error) in
            
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first!
            
            let annotation = MKPointAnnotation()
            annotation.title = self.barber?.name
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotaionIdentifier = "barberAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotaionIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotaionIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImage.image = UIImage(data: barber.image! as Data)
        annotationView?.rightCalloutAccessoryView = rightImage
        
        annotationView?.pinTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        return annotationView
    }
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailBSTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Barber name"
            cell.valueLabel.text = barber!.name
        case 1:
            cell.keyLabel.text = "Address"
            cell.valueLabel.text = barber!.location
        case 2:
            cell.keyLabel.text = "Your review"
            cell.valueLabel.text = barber!.review
        default:
            break
        }
        return cell
    }
    
}
