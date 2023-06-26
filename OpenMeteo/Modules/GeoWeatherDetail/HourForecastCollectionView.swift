//
//  HourForecastCollectionView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class HourForecastCollectionView: UICollectionView {
    
    private let verticalSectionInset: CGFloat = 10

    var hourForecastList: [HourForecast] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: - Init
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: HourForecastCell.width, height: HourForecastCell.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: verticalSectionInset, bottom: 0, right: verticalSectionInset)
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(HourForecastCell.self, forCellWithReuseIdentifier: HourForecastCell.reuseIdentifier)
        
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width / 20
        
        hideHorizontalScrollIndicator()
        hideVerticalScrollIndicator()
    }

    func setViews() {
        self.backgroundColor = .systemGray6
        self.isPagingEnabled = true
        self.layer.masksToBounds = true
    }
    
    func configure(with hourForecastList: [HourForecast]) {
        self.hourForecastList = hourForecastList
    }
    
    func hideHorizontalScrollIndicator() {
        guard self.showsHorizontalScrollIndicator else { return }
        self.showsHorizontalScrollIndicator = false
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
    
    func hideVerticalScrollIndicator() {
        guard self.showsVerticalScrollIndicator else { return }
        self.showsVerticalScrollIndicator = false
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsVerticalScrollIndicator = false
            }
        }
    }
}

// MARK: - DataSource

extension HourForecastCollectionView: UICollectionViewDataSource {
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
            hourForecastCell.configure(with: hourForecast)
        }
        
        return cell
    }
}
