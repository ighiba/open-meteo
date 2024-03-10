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
    
    func update(with geocoding: Geocoding) {
        let adminLocation = geocoding.adminLocation.isEmpty ? "" : ", \(geocoding.adminLocation)"
        let titleText = "\(geocoding.name)\(adminLocation)"
        let detailText = "\(geocoding.country)"
        
        textLabel?.text = titleText
        detailTextLabel?.text = detailText
    }
}
