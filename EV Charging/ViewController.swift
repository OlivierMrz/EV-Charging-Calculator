//
//  ViewController.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout: CommentFlowLayout = .init()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.contentInsetAdjustmentBehavior = .always
        cv.backgroundColor = .clear
        cv.register(CarInfoCollectionViewCell.self, forCellWithReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier)
        cv.register(ChargingPercentageCollectionViewCell.self, forCellWithReuseIdentifier: ChargingPercentageCollectionViewCell.reuseIdentifier)
        cv.register(ChargingPowerAndCostCollectionViewCell.self, forCellWithReuseIdentifier: ChargingPowerAndCostCollectionViewCell.reuseIdentifier)
        cv.register(CostAndTimerCollectionViewCell.self, forCellWithReuseIdentifier: CostAndTimerCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var collectionViewViewModel: CollectionViewViewModel?
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewViewModel = CollectionViewViewModel()
        setupUI()
    }


    private func setupUI() {
        // view
        view.backgroundColor = Colors.background
        
        // collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(viewModel: collectionViewViewModel)
            cell.updateData()
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChargingPercentageCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? ChargingPercentageCollectionViewCell else { return UICollectionViewCell() }
            cell.sliderMovementDelegate = self
            cell.configure(viewModel: collectionViewViewModel)
            cell.updateData()
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChargingPowerAndCostCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? ChargingPowerAndCostCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(viewModel: collectionViewViewModel)
            cell.updateData()
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CostAndTimerCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? CostAndTimerCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(viewModel: collectionViewViewModel)
            cell.updateData()
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // to be implemanted
        if indexPath.row == 0 {
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ViewController: sliderMovementDelegate {
    func isSliderMoving(bool: Bool) {
        collectionView.isScrollEnabled = bool
        collectionView.reloadData()
    }
}

extension ViewController: ChargingPowerAndCostCellDelegate {
    func additionalViewTapped(isNoFeeSelected: Bool) {
        if isNoFeeSelected {
            collectionView.reloadData()
        } else {
            promptForAnswer()
        }
    }
    
    func ChargingKWOrChargingCostSliderMoved() {
        collectionView.reloadData()
    }

    private func promptForAnswer() {
        let ac = UIAlertController(title: "Edit Additional Cost", message: nil, preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.text = String(format: "%.2f", self.collectionViewViewModel?.additionalCost ?? 0.0)
            textfield.keyboardType = .decimalPad
        }

        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
            guard let textField = ac.textFields?.first,
                  let text = textField.text,
                    let newValue = Float(text) else { return }

            self.collectionViewViewModel?.setAdditionalCost(value: newValue)
            self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        self.present(ac, animated: true)
    }
}

// ToDo: move class to seperate file
final class CommentFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
            layoutAttributesObjects?.forEach({ layoutAttributes in
                if layoutAttributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                        layoutAttributes.frame = newFrame
                    }
                }
            })
            return layoutAttributesObjects
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
