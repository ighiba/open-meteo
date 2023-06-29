//
//  DailyForecastContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

class DailyForecastContainer: UIStackView {
    
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
        self.subviews.first(where: { $0 is UIVisualEffectView })?.layer.cornerRadius = self.layer.cornerRadius
    }
    
    func setViews() {
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .center
        
        self.backgroundColor = .systemGray6.withAlphaComponent(0.1)

        let blurEffectView = UIVisualEffectView.obtainBlur(style: .light)
        self.insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
                make.height.equalTo(DayForecastRow.height)
            }
            if row != forecastRows.last {
                self.addSeparator()
            }
        }
    }
    
    func obtainForecastContainerRows(_ dayForecastList: [DayForecast]) -> [DayForecastRow] {
        let containerRows = dayForecastList.map { forecast in
            let forecastRow = DayForecastRow()
            forecastRow.configure(with: forecast)
        
            return forecastRow
        }
        return containerRows
    }
    
    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .separator
        self.addArrangedSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(1)
        }
    }
}
