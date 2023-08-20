//
//  HourlyForecastCollectionView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class HourlyForecastCollectionView: UICollectionView, StyledContainer {
    
    private let verticalSectionInset: CGFloat = 10

    var hourForecastList: [HourForecast] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Init
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: HourForecastCell.width, height: HourForecastCell.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: verticalSectionInset, bottom: 0, right: verticalSectionInset)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(HourForecastCell.self, forCellWithReuseIdentifier: HourForecastCell.reuseIdentifier)
        dataSource = self
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 16
        
        hideHorizontalScrollIndicator()
        hideVerticalScrollIndicator()
    }

    func setViews() {
        backgroundColor = .clear
        backgroundView = UIVisualEffectView.obtainBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)
    }
    
    func updateContainerStyle(with style: ContainerStyle) {
        backgroundView = UIVisualEffectView.obtainBlur(style: style.blurStyle, withAlpha: style.alpha)
    }
    
    func configure(with hourForecastList: [HourForecast]) {
        self.hourForecastList = hourForecastList
    }
    
    func hideHorizontalScrollIndicator() {
        guard showsHorizontalScrollIndicator else { return }
        showsHorizontalScrollIndicator = false
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
    
    func hideVerticalScrollIndicator() {
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
        if let hourForecastCell = cell  as? HourForecastCell {
            let hourForecast = hourForecastList[indexPath.row]
            hourForecastCell.configure(with: hourForecast, for: indexPath)
        }
        
        return cell
    }
}
