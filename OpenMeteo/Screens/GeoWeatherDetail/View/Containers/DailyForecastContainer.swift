//
//  DailyForecastContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

final class DailyForecastContainer: UIStackView, StyledContainer {
    
    private let blurEffectView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        axis = .vertical
        distribution = .fillProportionally
        alignment = .center
        
        backgroundColor = .clear
        
        layer.cornerRadius = 16
        blurEffectView.layer.cornerRadius = layer.cornerRadius
        
        insertSubview(blurEffectView, at: 0)
        
        blurEffectView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addPlaceholder()
    }
    
    func updateContainerStyle(with containerStyle: ContainerStyle) {
        blurEffectView.updateBlur(style: containerStyle.blurStyle, withAlpha: containerStyle.alpha)
    }
    
    func setup(with dayForecastList: [DayForecast]) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        addArrangedSubviews(dayForecastList: dayForecastList)
    }
    
    private func addArrangedSubviews(dayForecastList: [DayForecast]) {
        let forecastRows = configureForecastContainerRows(dayForecastList: dayForecastList)
        forecastRows.forEach { row in
            addArrangedSubview(row)
            makeConstraintsForRow(row)
            
            if row != forecastRows.last {
                addSeparator()
            }
        }
    }
    
    private func configureForecastContainerRows(dayForecastList: [DayForecast]) -> [DayForecastRow] {
        return dayForecastList.map { forecast in
            let forecastRow = DayForecastRow()
            forecastRow.configure(with: forecast)
            return forecastRow
        }
    }
    
    private func makeConstraintsForRow(_ row: UIView) {
        row.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(DayForecastRow.height)
        }
    }
    
    private func addPlaceholder() {
        let placeholderRowsRange = 0..<7
        placeholderRowsRange.forEach { rowIndex in
            let row = UIView()
            addArrangedSubview(row)
            makeConstraintsForRow(row)
            
            if rowIndex != placeholderRowsRange.last {
                addSeparator()
            }
        }
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
}
