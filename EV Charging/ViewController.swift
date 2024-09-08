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
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChargingPercentageCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? ChargingPercentageCollectionViewCell else { return UICollectionViewCell() }
            cell.sliderMovementDelegate = self
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarInfoCollectionViewCell.reuseIdentifier, 
                                                                for: indexPath) as? CarInfoCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }

    }
}

extension ViewController: sliderMovementDelegate {
    func isSliderMoving(bool: Bool) {
        collectionView.isScrollEnabled = bool
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
