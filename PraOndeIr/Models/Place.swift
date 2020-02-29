//
//  Place.swift
//  PraOndeIr
//
//  Created by Marcos Joshoa on 29/02/20.
//  Copyright © 2020 Marcos Joshoa. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    let name: String
    let latitute: CLLocationDegrees
    let longitute: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
         return CLLocationCoordinate2D(latitude: latitute, longitude: longitute )
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)"
        }
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)"
        }
        if let city = placemark.locality {
            address += "\n\(city)"
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)"
        }
        if let postalCode = placemark.postalCode {
            address += "\nCEP: \(postalCode)"
        }
        if let country = placemark.country {
            address += "\n\(country)"
        }
        return address
    }
}

extension Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.latitute == rhs.latitute && lhs.longitute == rhs.longitute
    }
}
