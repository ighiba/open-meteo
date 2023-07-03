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
            
            viewModel.geoWeatherIdsDidChangedHandler = { [weak self] ids in
                self?.updateSnapshot(reloading: ids)
            }
        }
    }

    var dataSource: DataSource!

    private var initialPathForAnimator: CGPath?
    
    private var dimmedView: UIView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
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
        
        setNavigationBar()
        updateNavigationBarAppearance()
        
        self.collectionView.delegate = self
        self.navigationController?.delegate = self
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.register(GeoWeatherCell.self, forCellWithReuseIdentifier: GeoWeatherCell.identifier)
        
        dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            return self.configureCell(collectionView: collectionView, itemIdentifier: itemIdentifier, for: indexPath)
        }
        
        updateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationBarAppearance()
    }
    
    func setNavigationBar() {
        let searchController = GeoSearchModuleAssembly.configureModule() as! GeoSearchViewController
        searchController.geoWeatherListViewControllerDelegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.title = NSLocalizedString("Weather", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateNavigationBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barStyle = .default

        self.navigationController?.navigationBar.tintColor = nil
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
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
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
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

        initialPathForAnimator = UIBezierPath(roundedRect: cellOnRootViewRect, cornerRadius: cell.layer.cornerRadius).cgPath
        detailViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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

extension GeoWeatherListViewController: GeoWeatherListViewControllerDelegate {
    
    
    private var dimmedViewTransitionDuration: TimeInterval {
        return 0.3
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        viewModel.addGeoWeather(geoWeather)
    }
    
    func showDimmedView() {
        guard dimmedView == nil else { return }
        dimmedView = UIView()
        dimmedView?.backgroundColor = .clear
        
        self.view.addSubview(dimmedView!)
        self.collectionView.isUserInteractionEnabled = false
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.backgroundColor = .white
        dimmedView?.snp.makeConstraints { make in
            make.top.equalTo(navigationController.navigationBar)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        UIView.animate(withDuration: dimmedViewTransitionDuration) { [weak self] in
            self?.dimmedView?.backgroundColor = .darkGray.withAlphaComponent(0.3)
        }
    }
    
    func hideDimmedView() {
        UIView.animate(withDuration: dimmedViewTransitionDuration, delay: 0, animations: { [weak self] in
            self?.dimmedView?.backgroundColor = .clear
        }, completion: { [weak self] _ in
            self?.dimmedView?.removeFromSuperview()
            self?.dimmedView = nil
            self?.collectionView.isUserInteractionEnabled = true
        })
    }
}

