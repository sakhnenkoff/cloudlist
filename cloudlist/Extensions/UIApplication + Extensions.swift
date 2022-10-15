//
//  UIApplication + Extensions.swift
//  CryptoUI
//
//  Created by Matvii Sakhnenko on 14/08/2022.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
