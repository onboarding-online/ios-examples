//
//  UITableView.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import UIKit

extension UITableView {
    func registerCellNibOfType<T: UITableViewCell>(_ type: T.Type) {
        let cellName = String(describing: type)
        register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func dequeueCellOfType<T: UITableViewCell>(_ type: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: type.cellIdentifier) as! T
    }
}

