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
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Methods

}

