//
//  HourlyForecastCollectionView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

final class HourlyForecastCollectionView: UICollectionView, StyledContainer {
    
    private let verticalSectionInset: CGFloat = 10

    private var hourForecastList: [HourForecast] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = self.configureLayout()
        self.register(HourForecastCell.self, forCellWithReuseIdentifier: HourForecastCell.reuseIdentifier)
        self.dataSource = self
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: HourForecastCell.width, height: HourForecastCell.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: verticalSectionInset, bottom: 0, right: verticalSectionInset)
        
        return layout
    }

    private func setupViews() {
        layer.cornerRadius = 16
        
        backgroundColor = .clear
        backgroundView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)
        
        hideScrollIndicators()
    }
    
    func updateContainerStyle(with style: ContainerStyle) {
        backgroundView = UIVisualEffectView.configureBlur(style: style.blurStyle, withAlpha: style.alpha)
    }
    
    func setup(with hourForecastList: [HourForecast]) {
        self.hourForecastList = hourForecastList
    }
    
    private func hideScrollIndicators() {
        hideHorizontalScrollIndicator()
        hideVerticalScrollIndicator()
    }
    
    private func hideHorizontalScrollIndicator() {
        guard showsHorizontalScrollIndicator else { return }
        
        showsHorizontalScrollIndicator = false
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
    
    private func hideVerticalScrollIndicator() {
        guard showsVerticalScrollIndicator else { return }
        
        showsVerticalScrollIndicator = false
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsVerticalScrollIndicator = false
            }
        }
    }
}

// MARK: - DataSource

extension HourlyForecastCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourForecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: HourForecastCell.reuseIdentifier, for: indexPath)
        guard let hourForecastCell = cell as? HourForecastCell else { return cell }
        
        let hourForecast = hourForecastList[indexPath.row]
        hourForecastCell.configure(with: hourForecast, for: indexPath)
        
        return hourForecastCell
    }
}
