//
//  DayForecastContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class DayForecastContainer: UIStackView {
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 20
    }
    
    func setViews() {
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .center
        
        self.backgroundColor = .systemGray6
    }
    
    func configure(with dayForecastList: [DayForecast]) {
        self.arrangedSubviews.forEach { subview in
            self.removeArrangedSubview(subview)
        }
        addArrangedSubviews(with: dayForecastList)
        
    }
    
    func addArrangedSubviews(with dayForecastList: [DayForecast]) {
        let forecastRows = obtainForecastContainerRows(dayForecastList)
        forecastRows.forEach { row in
            self.addArrangedSubview(row)
            row.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(ForecastRow.height)
            }
        }
    }
    
    func obtainForecastContainerRows(_ dayForecastList: [DayForecast]) -> [ForecastRow] {
        let containerRows = dayForecastList.map { forecast in
            let forecastRow = ForecastRow()
            forecastRow.configure(with: forecast)
        
            return forecastRow
        }
        return containerRows
    }
}
