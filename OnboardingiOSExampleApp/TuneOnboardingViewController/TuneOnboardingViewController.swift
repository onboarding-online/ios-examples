//
//  ViewController.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import UIKit


final class TuneOnboardingViewController: UIViewController {
    
    typealias TuneOnboardingDataSource = UITableViewDiffableDataSource<TuneOnboardingViewController.TableSection, TuneOnboardingViewController.RowName>
    typealias TuneOnboardingSnapshot = NSDiffableDataSourceSnapshot<TuneOnboardingViewController.TableSection, TuneOnboardingViewController.RowName>
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var actionButtons: [UIButton]!
    
    private var dataSource: TuneOnboardingDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
}

// MARK: - UITableViewDelegate
extension TuneOnboardingViewController: UITableViewDelegate { }

// MARK: - Actions
private extension TuneOnboardingViewController {
    @IBAction func startOnboardingButtonPressed(_ sender: Any) {
        TunedOnboardingRunner.shared.startOnboardingWithSelectedSettings()
    }
   
    @IBAction func prepareOnboardingButtonPressed(_ sender: Any) {
        TunedOnboardingRunner.shared.prepareOnboarding()
    }
    
    @IBAction func runPreparedOnboardingButtonPressed(_ sender: Any) {
        TunedOnboardingRunner.shared.startPreparedOnboarding()
    }
    
    @objc func clearCacheButtonPressed() {
        TunedOnboardingRunner.shared.clearCache()
        let alert = UIAlertController(title: Strings.cacheClearedAlertTitle,
                                      message: Strings.cacheClearedAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Setup methods
private extension TuneOnboardingViewController {
    func setup() {
        setupNavigationBar()
        setupButtonsUI()
        setupTableView()
    }
    
    func setupNavigationBar() {
        title = Strings.tuneScreenTitle
        let clearCacheButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                style: .plain,
                                                target: self,
                                               action: #selector(clearCacheButtonPressed))
        navigationItem.rightBarButtonItem = clearCacheButton
    }
    
    func setupButtonsUI() {
        actionButtons.forEach { button in
            button.layer.cornerRadius = 8
        }
    }
    
    func setupTableView() {
        registerTableViewCells()
        tableView.delegate = self
        setupDataSource()
        applySnapshot()
    }
    
    func registerTableViewCells() {
        let supportedCells: [UITableViewCell.Type] = [SegmentControlSelectionCell.self,
                                                      SwitchControlSelectionCell.self]
        supportedCells.forEach { cellType in
            tableView.registerCellNibOfType(cellType)
        }
    }
    
    func setupDataSource() {
        dataSource = TuneOnboardingDataSource(tableView: tableView) { (tableView, indexPath, row) -> UITableViewCell? in
            switch row {
            case .segmentSelection(let configuration):
                let cell = tableView.dequeueCellOfType(SegmentControlSelectionCell.self)
                cell.setWith(configuration: configuration)                
                
                return cell
            case .switchSelection(let configuration):
                let cell = tableView.dequeueCellOfType(SwitchControlSelectionCell.self)
                cell.setWith(configuration: configuration)
                
                return cell
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = TuneOnboardingSnapshot()
        
        snapshot.appendSections([.main])
        let items: [RowName] = [.segmentSelection(.selectAppearanceModeConfiguration()),
                                .segmentSelection(.selectOnboardingLocationConfiguration()),
                                .segmentSelection(.selectAppearanceConfiguration()),
                                .segmentSelection(.selectAssetsPrefetchModeConfiguration()),
                                .segmentSelection(.selectLoadingScreenTypeConfiguration()),
                                .switchSelection(.launchAnimatedConfiguration())]
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot)
    }
}

// MARK: - TableView enums
extension TuneOnboardingViewController {
    enum TableSection: Hashable {
        case main
    }
    
    enum RowName: Hashable {
        case segmentSelection(SegmentControlSelectionCellConfiguration)
        case switchSelection(SwitchSelectionCellConfiguration)
    }
}

//@available(iOS 17, *)
//#Preview {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let vc = storyboard.instantiateInitialViewController()!
//
//    return vc
//}
