//
//  GeocodingCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

final class GeocodingCell: UITableViewCell {
    
    static let identifier = "geocodingCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with geocoding: Geocoding) {
        let titleText = "\(geocoding.name), \(geocoding.country)"
        let detailText = "\(geocoding.latitude), \(geocoding.longitude)"
        
        self.textLabel?.text = titleText
        self.detailTextLabel?.text = detailText
    }
}
