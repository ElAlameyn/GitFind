//
//  Extensions.swift
//  GitFind
//
//  Created by Артем Калинкин on 13.10.2021.
//

import Foundation
import UIKit

extension UITableView {
  func dequeueReusableCell<T:UITableViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else { fatalError("Wrong identifier") }
    return cell
  }
}
