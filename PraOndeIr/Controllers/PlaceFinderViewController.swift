//
//  PlaceFinderViewController.swift
//  PraOndeIr
//
//  Created by Marcos Joshoa on 29/02/20.
//  Copyright © 2020 Marcos Joshoa. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController, UITextFieldDelegate {
    
    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    // MARK: - Properties
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
        tfCity.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfCity {
            findCityAction() 
        }
        return true
    }
    
    // MARK: - Methods
    @objc private func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.loadingPlace(placemarks, error)
            }
        }
    }
    
    private func loadingPlace(_ placemarks: [CLPlacemark]?, _ error: Error?) {
        self.load(show: false)
        if error == nil {
            if !self.savePlace(with: placemarks?.first) {
                self.showMessage(type: .error("Não foi encontrado um local com esse nome"))
            }
        } else {
            self.showMessage(type: .error("Falha interna"))
            print(error?.localizedDescription ?? "Erro desconhecido")
        }
    }
    
    private func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitute: coordinate.latitude, longitute: coordinate.longitude, address: address)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1750, longitudinalMeters: 1750)
        mapView.setRegion(region, animated: true)
        showMessage(type: .confirmation(place.name))
        return true
    }
    
    private func showMessage(type: PlaceFinderMessageType) {
        let title: String, message: String
        var hasConfirmation: Bool = false
        switch type {
            case .confirmation(let name):
                title = "Local encontrado"
                message = "Deseja adicionar \(name)?"
                hasConfirmation = true
            case .error(let errorMessage):
                title = "Erro"
                message = errorMessage
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Sim", style: .default) { (action) in
                self.delegate?.addPlace(self.place)
                if let vc = self.presentingViewController?.children.first as? PlacesTableViewController {
                    vc.performSegue(withIdentifier: "mapSegue", sender: self.place)
                }
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func load(show: Bool) {
        viLoading.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
        
    }
    
    private func findCityAction() {
        tfCity.resignFirstResponder()
        let address = tfCity.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.loadingPlace(placemarks, error)
        }
    }
    
    // MARK: - IBActions
    @IBAction func findCity(_ sender: UIButton) {
        findCityAction()
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
