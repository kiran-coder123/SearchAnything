//
//  ViewController.swift
//  SearchAnythingApp
//
//  Created by Kiran Sonne on 29/09/22.
//

import UIKit
import MapKit
enum maptype:NSInteger
{
    case standardmap = 0
    case satellitemap = 1
    case hybridmap = 2
}
class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search ANYTHING"
        segmentControl.backgroundColor = .lightGray
        segmentControl.tintColor = .white
        
        allCityStaticData()
        
    }
    func allCityStaticData()
    {
        
        let india = Capital(title: "India", coordinate: CLLocationCoordinate2D(latitude:20.5937, longitude: 78.9629), info: "this is most beutiful country in the world")
        
        let afghanistan = Capital(title: "Afghanistan", coordinate: CLLocationCoordinate2D(latitude: 33.9391, longitude: 67.7100), info: "Afghanistan, officially the Islamic Emirate of Afghanistan, is a landlocked country located at the crossroads of Central Asia and South Asia")
        
        let bangladesh = Capital(title: "Bangladesh", coordinate: CLLocationCoordinate2D(latitude: 23.6850, longitude: 90.3563), info: "Bangladesh, to the east of India on the Bay of Bengal, is a South Asian country marked by lush greenery and many waterways. Its Padma (Ganges), Meghna and Jamuna rivers create fertile plains, and travel by boat is common.")
        
        let bhutan = Capital(title: "Bhutan", coordinate: CLLocationCoordinate2D(latitude: 27.5142, longitude: 90.4336), info: "Bhutan, a Buddhist kingdom on the Himalayas’ eastern edge, is known for its monasteries, fortresses (or dzongs) and dramatic landscapes that range from subtropical plains to steep mountains and valleys.")
        
        let china = Capital(title: "China", coordinate: CLLocationCoordinate2D(latitude: 35.8617, longitude: 104.1954), info: "China, officially the People's Republic of China, is a country in East Asia. It is the world's most populous country with a population exceeding 1.4 billion people.")
        
        
        mapView.addAnnotations([india,china,bhutan,afghanistan,bangladesh])
    }
    @IBAction func searchAnythingButtonTapped(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.view.addSubview(indicator)
        
        //Hide search bar
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create a search request
        
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery  = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            indicator.stopAnimating()
            
            self.view.isUserInteractionEnabled = true
            if response == nil {
                print("Error ")
            } else {
                
                // remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting Data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotations
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming an annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                // let region = MKCoordinateRegionMake(coordinate, span)
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: latitude!, longitudinalMeters:longitude!)
                
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            annotationView?.tintColor = .green
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let alert = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func segmentControlClick(_ sender: Any) {
        switch(sender as AnyObject).selectedSegmentIndex
        {
        case maptype.standardmap.rawValue:
            mapView.mapType = .standard
        case maptype.satellitemap.rawValue:
            mapView.mapType = .satellite
        case maptype.hybridmap.rawValue:
            mapView.mapType = .hybrid
            
        default:
            break
        }
    }
}

