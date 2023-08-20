//
//  OpenMeteoNavigationController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

class OpenMeteoNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? { topViewController }
}
