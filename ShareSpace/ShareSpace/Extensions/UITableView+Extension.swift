//
//  UITableView+Extension.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/30/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func scrollToBottom() {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)
      self.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
}
