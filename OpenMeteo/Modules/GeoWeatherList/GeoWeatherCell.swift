//
//  GeoWeatherCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "geoWeatherCell"
    static let height: CGFloat = 100

    private let horizontalOffset: CGFloat = 20
    
    var longTapEndedCallback: (() -> Void)?
    var removeButtonTappedHandler: (() -> Void)?
    
    lazy var longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent))
    
    var isEditing = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        addGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    func setViews() {
        self.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.masksToBounds = true
        
        setBackgroundPlaceholder()
        
        self.backgroundView = backgroundGradientView
        backgroundGradientView.addSubview(geoNameLabel)
        backgroundGradientView.addSubview(weatherCodeDescriptionLabel)
        backgroundGradientView.addSubview(currentTemperatureLabel)
        backgroundGradientView.addSubview(todayMinMaxTemeperatureRangeContainer)
        self.insertSubview(removeItemButton, at: 0)

        backgroundGradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        geoNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalTo(todayMinMaxTemeperatureRangeContainer.snp.leading)
            make.top.equalTo(currentTemperatureLabel).offset(10)
        }
        
        weatherCodeDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(geoNameLabel)
            make.centerY.equalTo(todayMinMaxTemeperatureRangeContainer)
        }

        currentTemperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.centerY.equalToSuperview().offset(-horizontalOffset / 2)
        }
        
        todayMinMaxTemeperatureRangeContainer.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom)
            make.centerX.equalTo(currentTemperatureLabel)
            make.width.equalTo(todayMinMaxTemeperatureRangeContainer.preferredWidth)
            make.height.equalTo(20)
        }
        
        removeItemButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Methods
    
    func configure(with geoWeather: GeoWeather) {
        geoNameLabel.text = geoWeather.geocoding.name
        guard let weather = geoWeather.weather else { return }
        updateBackgroundView(with: weather)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(weather.currentWeatherCode.localizedDescription)
        currentTemperatureLabel.setTemperature(weather.obtainForecastForCurrentHour().temperature)
        todayMinMaxTemeperatureRangeContainer.setTemperature(
            min: weather.currentDayMinTemperature,
            max: weather.currentDayMaxTemperature
        )
    }

    func updateBackgroundView(with weather: Weather) {
        let skyType = weather.obtainSkyType()
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundGradientView.setColors(weatherColorSet: colorSet)
    }
    
    func setBackgroundPlaceholder() {
        backgroundGradientView.setColors(weatherColorSet: .clearSky)
    }
    
    private func addGestureRecognizers() {
        longPress.minimumPressDuration = 0.1
        self.addGestureRecognizer(longPress)
    }
    
    private func removeGestureRecognizers() {
        self.removeGestureRecognizer(longPress)
    }
    
    func startEditing(animated: Bool = true, completion: (() -> Void)? = nil) {
        isEditing = true
        if animated {
            animateIsEditingBegin() {
                completion?()
            }
        } else {
            backgroundGradientView.isUserInteractionEnabled = false
            removeGestureRecognizers()
            removeItemButton.isHidden = false
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
            let rect = backgroundGradientView.bounds.inset(by: insets)
            let finalPath = UIBezierPath(roundedRect: rect, cornerRadius: Self.height / 5).cgPath
            let mask = CAShapeLayer(with: finalPath)
            backgroundGradientView.layer.mask = mask
            currentTemperatureLabel.layer.opacity = 0.0
            todayMinMaxTemeperatureRangeContainer.layer.opacity = 0.0
        }
    }
    
    func endEditing(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            animateIsEditingEnd() { [weak self] in
                self?.isEditing = false
                completion?()
            }
        } else {
            removeAllAnimations()
            currentTemperatureLabel.layer.opacity = 1.0
            todayMinMaxTemeperatureRangeContainer.layer.opacity = 1.0
            backgroundGradientView.layer.mask = nil
            removeItemButton.isHidden = true
            addGestureRecognizers()
            backgroundGradientView.isUserInteractionEnabled = true
        }
    }
    
    private func removeAllAnimations() {
        currentTemperatureLabel.layer.removeAllAnimations()
        todayMinMaxTemeperatureRangeContainer.layer.removeAllAnimations()
        removeItemButton.layer.removeAllAnimations()
    }
    
    // MARK: - Animations
    
    private func animateIsEditingBegin(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        backgroundGradientView.isUserInteractionEnabled = false
        removeGestureRecognizers()
        removeItemButton.isHidden = false
        backgroundGradientView.layer.animatePath(
            initialRect: backgroundGradientView.frame,
            cornerRadius: Self.height / 5,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60),
            duration: duration) { [weak self] _ in
                guard let button = self?.removeItemButton else { return }
                self?.bringSubviewToFront(button)
                completion?()
            }
        currentTemperatureLabel.layer.animateOpacity(from: 1.0, to: 0.0, duration: duration / 2)
        todayMinMaxTemeperatureRangeContainer.layer.animateOpacity(from: 1.0, to: 0.0, duration: duration / 2)

        removeItemButton.layer.animateRotation(from: -CGFloat.pi * 0.5, to: 0, duration: duration)
    }
    
    private func animateIsEditingEnd(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        self.sendSubviewToBack(removeItemButton)
        backgroundGradientView.layer.animatePath(
            initialRect: backgroundGradientView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)),
            cornerRadius: Self.height / 5,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -60),
            duration: duration) { [weak self] _ in
                self?.backgroundGradientView.layer.mask = nil
                self?.backgroundGradientView.isUserInteractionEnabled = true
                self?.removeItemButton.isHidden = true
                self?.addGestureRecognizers()
                self?.removeAllAnimations()
                completion?()
            }
        currentTemperatureLabel.layer.animateOpacity(from: 0.0, to: 1.0, duration: duration / 2)
        todayMinMaxTemeperatureRangeContainer.layer.animateOpacity(from: 0.0, to: 1.0, duration: duration / 2)

        removeItemButton.layer.animateRotation(from: 0.0, to: -CGFloat.pi * 0.5, duration: duration)
    }
    
    private func animateTapBegin() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func amimateTapEnded() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            self.transform = .identity
        }) { [weak self] _ in
            self?.longTapEndedCallback?()
        }
    }
    
    // MARK: - Views
    
    private var backgroundGradientView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.5))
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location name"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let weatherCodeDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white

        return label
    }()
    
    private let todayMinMaxTemeperatureRangeContainer: TemperatureRangeContainer = {
        let fontSize: CGFloat = 15
        let container = TemperatureRangeContainer(withFontSize: fontSize)
        
        container.minTemperatureLabel.temperatureLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        container.maxTemperatureLabel.temperatureLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        
        container.setColors(.white)
        
        return container
    }()
    
    private var removeItemButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        let image = UIImage(systemName: "minus.circle.fill", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        button.tintColor = .red
        button.addTarget(nil, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
}

// MARK: - Actions

extension GeoWeatherCell {
    @objc func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        guard !isEditing else { return }
        if sender.state == .began {
            animateTapBegin()
        } else if sender.state == .ended {
            amimateTapEnded()
        }
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {

        animateIsEditingEnd(duration: 0.1) { [weak self] in
            self?.isEditing = false
            self?.removeButtonTappedHandler?()
        }
    }
}
