//
//  GeoWeatherListViewController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit
import Combine

class GeoWeatherListViewController: UICollectionViewController {
    
    // MARK: - Properties

    var viewModel: GeoWeatherListViewModelDelegate!

    var dataSource: DataSource!
    
    private var cancellables = Set<AnyCancellable>()

    private var initialPathForAnimator: CGPath?
    
    private var dimmedView: UIView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    private var isCollectionViewRefreshing: Bool { collectionView.refreshControl?.isRefreshing ?? false }
    private(set) var isAnimatingEditing = false {
        didSet {
            navigationController?.navigationBar.isUserInteractionEnabled = !isAnimatingEditing
            view.isUserInteractionEnabled = !isAnimatingEditing
        }
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
        
        collectionView.delegate = self
        navigationController?.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(GeoWeatherCell.self, forCellWithReuseIdentifier: GeoWeatherCell.identifier)
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return self.configureCell(collectionView: collectionView, itemIdentifier: itemIdentifier, for: indexPath)
        }

        configureBindings()
        updateSnapshot()
        viewModel.loadInitialData()
        viewModel.updateAllWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationBarAppearance()
    }
    
    private func setNavigationBar() {
        let searchController = GeoSearchModuleAssembly.configureModule() as? GeoSearchViewController
        searchController?.geoWeatherListViewControllerDelegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        title = NSLocalizedString("Weather", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func updateNavigationBarAppearance() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barStyle = .default

        navigationController?.navigationBar.tintColor = nil
        
        let navBarAppearance = UINavigationBarAppearance.configureDefaultBackgroundAppearance()        
        let scrollEdgeAppearance = UINavigationBarAppearance.configureTransparentBackgroundAppearance()
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let horizontalSpacing: CGFloat = 20
        let verticalSpacing: CGFloat = 15
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(GeoWeatherCell.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: verticalSpacing,
            leading: horizontalSpacing,
            bottom: horizontalSpacing,
            trailing: horizontalSpacing
        )
        section.interGroupSpacing = verticalSpacing

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureBindings() {
        viewModel.geoWeatherListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }
            .store(in: &cancellables)
        
        viewModel.idsThatChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.updateSnapshot(reloading: ids)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = !editing
        isAnimatingEditing = true
        if editing {
            beginListEditing()
        } else {
            endListEditing()
        }
    }
    
    private func beginListEditing() {
        forEachCell { [weak self] cell in
            cell?.startEditing() {
                self?.isAnimatingEditing = false
            }
        }
    }
    
    private func endListEditing() {
        forEachCell { [weak self] cell in
            cell?.endEditing() { [weak self] in
                self?.isAnimatingEditing = false
            }
        }
    }
    
    private func forEachCell(_ body: (GeoWeatherCell?) -> Void) {
        for i in 0 ..< viewModel.geoWeatherList.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? GeoWeatherCell
            body(cell)
        }
    }

    func openDetail(for indexPath: IndexPath) {
        guard let geoWeather = geoWeather(withIndexPath: indexPath),
              let detailViewController = GeoWeatherDetailModuleAssembly.configureModule(with: geoWeather) as? GeoWeatherDetailViewController else {
            return
        }

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let cellOnRootViewRect = cell.convert(cell.bounds, to: self.view)

        initialPathForAnimator = UIBezierPath(roundedRect: cellOnRootViewRect, cornerRadius: cell.layer.cornerRadius).cgPath
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.updateHandler = { [weak self] in
            self?.updateSnapshot(reloading: [geoWeather.id])
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func geoWeather(withIndexPath indexPath: IndexPath) -> GeoWeather? {
        guard viewModel.geoWeatherList.indices.contains(indexPath.row) else { return nil }
        return viewModel.geoWeatherList[indexPath.row]
    }

    func handleRefreshControlBegin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel.updateAllWeather()
        }
    }
    
    func handleRefreshControlEnd() {
        guard isCollectionViewRefreshing else { return }
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - Delegates

extension GeoWeatherListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isEditing else { return }
        openDetail(for: indexPath)
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isCollectionViewRefreshing {
            handleRefreshControlBegin()
        }
    }
}

extension GeoWeatherListViewController: GeoWeatherListViewControllerDelegate {
    
    private var dimmedViewTransitionDuration: TimeInterval { 0.3 }
    
    func isGeoAlreadyAdded(withId id: Geocoding.ID) -> Bool {
        let ids = viewModel.geoWeatherList.map { $0.geocoding.id }
        return ids.contains(id)
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        viewModel.addGeoWeather(geoWeather)
    }
    
    func showDimmedView() {
        guard dimmedView == nil else { return }
        dimmedView = UIView()
        dimmedView?.backgroundColor = .clear
        
        view.addSubview(dimmedView!)
        collectionView.isUserInteractionEnabled = false
        guard let navigationController = navigationController else { return }
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
