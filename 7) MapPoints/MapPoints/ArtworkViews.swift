//
//  ArtworkViews.swift
//  MapPoints
//
//  Created by César Manuel on 16/01/23.
//

import MapKit

class ArtworkMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation? {
        willSet{
            guard let artwork = newValue as? Artwork else { return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = artwork.markerTintColor
            
            if let letter = artwork.discipline?.first{
                //glyphText = String(letter)
                glyphImage = artwork.image
                print(letter)
            }
        }
    }
}

class ArtworkView: MKAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let artwork = newValue as? Artwork else { return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let mapsButton = UIButton(frame: CGRect(
                origin: .zero, size: CGSize(width: 48, height: 48)))
            
            mapsButton.setBackgroundImage(#imageLiteral (resourceName: "Monument"), for: .normal)
            
            rightCalloutAccessoryView = mapsButton
            
            image = artwork.image
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}
