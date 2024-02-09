//
//  DailyForecastContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

class DailyForecastContainer: UIStackView, StyledContainer {
    
    private var blurEffectView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
        blurEffectView.layer.cornerRadius = layer.cornerRadius
    }
    
    // MARK: - Methods
    
    func setViews() {
        axis = .vertical
        distribution = .fillProportionally
        alignment = .center
        
        backgroundColor = .clear
        
        insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addPlaceholder()
    }
    
    func updateContainerStyle(with style: ContainerStyle) {
        blurEffectView.updateBlur(style: style.blurStyle, withAlpha: style.alpha)
    }
    
    func configure(with dayForecastList: [DayForecast]) {
        arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        addArrangedSubviews(with: dayForecastList)
    }
    
    private func addArrangedSubviews(with dayForecastList: [DayForecast]) {
        let forecastRows = obtainForecastContainerRows(dayForecastList)
        forecastRows.forEach { row in
            addArrangedSubview(row)
            row.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(DayForecastRow.height)
            }
            if row != forecastRows.last {
                addSeparator()
            }
        }
    }
    
    private func obtainForecastContainerRows(_ dayForecastList: [DayForecast]) -> [DayForecastRow] {
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
        addArrangedSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(1)
        }
    }
    
    private func makeConstraintsForRow(_ row: UIView) {
        row.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(DayForecastRow.height)
        }
    }
    
    private func addPlaceholder() {
        let placeholderRowsRange = 0 ..< 7
        placeholderRowsRange.forEach { i in
            let row = UIView()
            addArrangedSubview(row)
            makeConstraintsForRow(row)
            if i != placeholderRowsRange.last {
                addSeparator()
            }
        }
    }
}
