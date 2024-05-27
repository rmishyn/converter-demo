//
//  DecimalTextField.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import UIKit

class DecimalTextField: UITextField, UITextFieldDelegate {

    // Maximum number of decimal places allowed
    var decimalPlaces: Int = 2

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.keyboardType = .decimalPad
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.keyboardType = .decimalPad
    }

    // UITextFieldDelegate method to control input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newString = currentText.replacingCharacters(in: range, with: string)
        
        // Check if new string is a valid decimal number
        return isValidDecimal(newString)
    }

    // Validate if the string is a valid decimal number
    private func isValidDecimal(_ string: String) -> Bool {
        // Allow empty string
        if string.isEmpty {
            return true
        }

        // Regular expression for valid decimal numbers with specified decimal places
        let decimalRegex = "^[0-9]*((\\.|,)[0-9]{0,\(decimalPlaces)})?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", decimalRegex)
        return predicate.evaluate(with: string)
    }
}
