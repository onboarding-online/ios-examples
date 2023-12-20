//
//  SwitchControlSelectionCell.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import UIKit

typealias SwitchValueChangedCallback = (Bool)->()

final class SwitchControlSelectionCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var uiSwitch: UISwitch!
    
    var valueChangedCallback: SwitchValueChangedCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setWith(configuration: SwitchSelectionCellConfiguration) {
        titleLabel.text = configuration.title
        uiSwitch.isOn = configuration.isOn
        self.valueChangedCallback = configuration.valueChangedCallback
    }
    
}

// MARK: - Actions
private extension SwitchControlSelectionCell {
    @IBAction func switchControlValueChanged() {
        valueChangedCallback?(uiSwitch.isOn)
    }
}
