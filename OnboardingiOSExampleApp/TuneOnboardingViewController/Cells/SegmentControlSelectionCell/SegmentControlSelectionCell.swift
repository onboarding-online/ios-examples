//
//  SegmentControlSelectionCell.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import UIKit

typealias SegmentValueChangedCallback = (Int)->()

final class SegmentControlSelectionCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    var valueChangedCallback: SegmentValueChangedCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setWith(configuration: SegmentControlSelectionCellConfiguration) {
        titleLabel.text = configuration.title
        segmentedControl.removeAllSegments()
        for (i, segment) in configuration.segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment, at: i, animated: false)
        }
        segmentedControl.selectedSegmentIndex = configuration.selectedIndex
        self.valueChangedCallback = configuration.valueChangedCallback
    }
    
}

// MARK: - Actions
private extension SegmentControlSelectionCell {
    @IBAction func segmentControlValueChanged() {
        valueChangedCallback?(segmentedControl.selectedSegmentIndex)
    }
}
