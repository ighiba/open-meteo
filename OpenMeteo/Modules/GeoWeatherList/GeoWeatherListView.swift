//
//  GeoWeatherListViewController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class GeoWeatherListViewController: UICollectionViewController {
    
    // MARK: - Properties

    var viewModel: GeoWeatherListViewModelDelegate! {
        didSet {
            viewModel.geoWeatherListDidChangedHandler = { [weak self] geoWeatherList in
                self?.updateSnapshot()
            }
        }
    }

    var dataSource: DataSource!

    private var initialPathForAnimator: CGPath?
    
    // MARK: - Init
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.navigationController?.delegate = self
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.register(GeoWeatherCell.self, forCellWithReuseIdentifier: GeoWeatherCell.identifier)
        
        dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            return self.configureCell(collectionView: collectionView, itemIdentifier: itemIdentifier, for: indexPath)
        }
        
        updateSnapshot()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(GeoWeatherCell.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Methods

    func openDetail(for indexPath: IndexPath) {
        guard let geoWeather = geoWeather(withIndexPath: indexPath),
              let detailViewController = GeoWeatherDetailModuleAssembly.configureModule(with: geoWeather) as? GeoWeatherDetailViewController else {
            return
        }

        guard let cell = self.collectionView.cellForItem(at: indexPath) else { return }
        
        let cellOnRootViewRect = cell.convert(cell.bounds, to: self.view)
//        let diff = GeoWeatherCell.height / cellOnRootViewRect.height
//
//        let identityWidth = cellOnRootViewRect.width * diff
//        let identityHeight = cellOnRootViewRect.height * diff
//        let identityX = cellOnRootViewRect.origin.x - (identityWidth - cellOnRootViewRect.width) / 2
//        let identityY = cellOnRootViewRect.origin.y - (identityHeight - cellOnRootViewRect.height) / 2
//        cellOnRootViewRect = CGRect(x: identityX,
//                                    y: identityY,
//                                    width: identityWidth,
//                                    height: identityHeight)

        
        initialPathForAnimator = UIBezierPath(roundedRect: cellOnRootViewRect, cornerRadius: cell.layer.cornerRadius).cgPath
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func geoWeather(withIndexPath indexPath: IndexPath) -> GeoWeather? {
        guard indexPath.row <= viewModel.geoWeatherList.count else { return nil }
        return viewModel.geoWeatherList[indexPath.row]
    }
}

// MARK: - Delegates

extension GeoWeatherListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDetail(for: indexPath)
    }
}

extension GeoWeatherListViewController: UINavigationControllerDelegate  {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let initialPath = initialPathForAnimator else { return nil }
        if operation == .push && isValidPushDestionation(from: fromVC, to: toVC) {
            return GeoWeatherDetailPushTransitionAnimator(initialPath: initialPath)
        } else if operation == .pop && isValidPopDestionation(from: fromVC, to: toVC) {
            return GeoWeatherDetailPopTransitionAnimator(finalPath: initialPath)
        }
        return nil
    }
    
    private func isValidPushDestionation(from fromVC: UIViewController, to toVC: UIViewController) -> Bool {
        return fromVC is GeoWeatherListViewController && toVC is GeoWeatherDetailViewController
    }
    
    private func isValidPopDestionation(from fromVC: UIViewController, to toVC: UIViewController) -> Bool {
        return fromVC is GeoWeatherDetailViewController && toVC is GeoWeatherListViewController
    }
}
