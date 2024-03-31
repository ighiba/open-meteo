//
//  GeoWeatherCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

final class GeoWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "geoWeatherCell"
    static let height: CGFloat = 100
    
    var longPressDidEndHandler: (() -> Void)?
    var deleteButtonDidTapHandler: (() -> Void)?
    
    lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
    
    private var cornerRadius: CGFloat { Self.height / 5 }
    private let horizontalOffset: CGFloat = 20
    private let verticalOffset: CGFloat = 10
    private let temperatureRangeContainerHeight: CGFloat = 20
    private let deleteItemButtonWidth: CGFloat = 40
    private let editingBackgroundViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
    
    private(set) var isEditing = false
    private var isLastTouchInBounds = true
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupGestures()
        self.setPlaceholders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func update(withGeoName geoName: String, temperature: Float, temperatureRange: TemperatureRange, weatherCode: Weather.Code, skyType: SkyType) {
        geoNameLabel.text = geoName
        currentTemperatureLabel.setTemperature(temperature)
        todayTemeperatureRangeContainer.setTemperature(range: temperatureRange)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(weatherCode.localizedDescription)
        updateBackground(forSkyType: skyType)
    }
    
    func startEditing(animated: Bool = true, completion: (() -> Void)? = nil) {
        isEditing = true
        
        if animated {
            animateEditingBegan(completion: completion)
        } else {
            backgroundGradientView.isUserInteractionEnabled = false
            longPressGesture.isEnabled = false
            deleteItemButton.isHidden = false
            
            let rect = backgroundGradientView.bounds.inset(by: editingBackgroundViewInsets)
            let finalPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
            let mask = CAShapeLayer(with: finalPath)
            backgroundGradientView.layer.mask = mask
            currentTemperatureLabel.layer.opacity = 0.0
            todayTemeperatureRangeContainer.layer.opacity = 0.0
        }
    }
    
    func endEditing(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            animateEditingEnded() { [weak self] in
                self?.isEditing = false
                completion?()
            }
        } else {
            removeAllAnimations()
            longPressGesture.isEnabled = true
            currentTemperatureLabel.layer.opacity = 1.0
            todayTemeperatureRangeContainer.layer.opacity = 1.0
            backgroundGradientView.layer.mask = nil
            backgroundGradientView.isUserInteractionEnabled = true
            deleteItemButton.isHidden = true
        }
    }
    
    private func updateBackground(forSkyType skyType: SkyType) {
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundGradientView.setColors(weatherColorSet: colorSet)
    }
    
    private func setupViews() {
        layer.cornerRadius = cornerRadius
        backgroundGradientView.layer.cornerRadius = cornerRadius
        backgroundGradientView.layer.masksToBounds = true
        backgroundView = backgroundGradientView
        
        setDefaultBackground()
        
        backgroundGradientView.addSubview(geoNameLabel)
        backgroundGradientView.addSubview(weatherCodeDescriptionLabel)
        backgroundGradientView.addSubview(currentTemperatureLabel)
        backgroundGradientView.addSubview(todayTemeperatureRangeContainer)
        insertSubview(deleteItemButton, at: 0)

        backgroundGradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        geoNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalTo(todayTemeperatureRangeContainer.snp.leading)
            make.top.equalTo(currentTemperatureLabel).offset(verticalOffset)
        }
        
        weatherCodeDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(geoNameLabel)
            make.centerY.equalTo(todayTemeperatureRangeContainer)
        }

        currentTemperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.centerY.equalToSuperview().offset(-horizontalOffset / 2)
        }
        
        todayTemeperatureRangeContainer.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom)
            make.centerX.equalTo(currentTemperatureLabel)
            make.width.equalTo(todayTemeperatureRangeContainer.preferredWidth)
            make.height.equalTo(temperatureRangeContainerHeight)
        }
        
        deleteItemButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(deleteItemButtonWidth)
            make.height.equalTo(deleteItemButtonWidth)
        }
    }
    
    private func setupGestures() {
        longPressGesture.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGesture)
    }
    
    private func setPlaceholders() {
        geoNameLabel.text = "..."
        weatherCodeDescriptionLabel.setAttributedTextWithShadow("...")
        currentTemperatureLabel.setPlaceholder()
        todayTemeperatureRangeContainer.setPlaceholders()
        setDefaultBackground()
    }
    
    private func setDefaultBackground() {
        backgroundGradientView.setColors(weatherColorSet: .clearSky)
    }
    
    private func removeAllAnimations() {
        currentTemperatureLabel.layer.removeAllAnimations()
        todayTemeperatureRangeContainer.layer.removeAllAnimations()
        deleteItemButton.layer.removeAllAnimations()
    }
    
    // MARK: - Animations
    
    private func animateEditingBegan(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        backgroundGradientView.isUserInteractionEnabled = false
        longPressGesture.isEnabled = false
        deleteItemButton.isHidden = false
        
        backgroundGradientView.layer.animatePath(
            initialRect: backgroundGradientView.frame,
            cornerRadius: cornerRadius,
            insets: editingBackgroundViewInsets,
            duration: duration,
            completion: { [weak self] _ in
                guard let button = self?.deleteItemButton else { return }
                
                self?.bringSubviewToFront(button)
                completion?()
            }
        )
        
        currentTemperatureLabel.layer.animateOpacity(from: 1.0, to: 0.0, duration: duration / 2)
        todayTemeperatureRangeContainer.layer.animateOpacity(from: 1.0, to: 0.0, duration: duration / 2)

        deleteItemButton.layer.animateRotation(from: -CGFloat.pi * 0.5, to: 0, duration: duration)
    }
    
    private func animateEditingEnded(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        sendSubviewToBack(deleteItemButton)
        
        var endInsets = editingBackgroundViewInsets
        endInsets.right *= -1
        
        backgroundGradientView.layer.animatePath(
            initialRect: backgroundGradientView.frame.inset(by: editingBackgroundViewInsets),
            cornerRadius: cornerRadius,
            insets: endInsets,
            duration: duration,
            completion: { [weak self] _ in
                self?.backgroundGradientView.layer.mask = nil
                self?.backgroundGradientView.isUserInteractionEnabled = true
                self?.deleteItemButton.isHidden = true
                self?.longPressGesture.isEnabled = true
                self?.removeAllAnimations()
                completion?()
            }
        )
        
        currentTemperatureLabel.layer.animateOpacity(from: 0.0, to: 1.0, duration: duration / 2)
        todayTemeperatureRangeContainer.layer.animateOpacity(from: 0.0, to: 1.0, duration: duration / 2)

        deleteItemButton.layer.animateRotation(from: 0.0, to: -CGFloat.pi * 0.5, duration: duration)
    }
    
    private func animateLongPressBegan(duration: TimeInterval = 0.1) {
        let options: UIView.AnimationOptions = [.curveEaseOut, .beginFromCurrentState]
        
        UIView.animate(withDuration: duration, delay: 0, options: options) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func amimateLongPressEnded(duration: TimeInterval = 0.05, completion: (() -> Void)? = nil) {
        let options: UIView.AnimationOptions = [.curveEaseIn, .beginFromCurrentState]
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            self?.transform = .identity
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Views
    
    private let backgroundGradientView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.5))
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
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
    
    private let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white

        return label
    }()
    
    private let todayTemeperatureRangeContainer: TemperatureRangeContainer = {
        let container = TemperatureRangeContainer(withFontSize: 15)
        
        container.setColors(.white)
        
        return container
    }()
    
    private let deleteItemButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let symbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        let image = UIImage(systemName: "minus.circle.fill", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(-20)
        button.tintColor = .red
        button.isHidden = true
        
        button.addTarget(nil, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        
        return button
    }()
}

// MARK: - Actions

extension GeoWeatherCell {
    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        guard !isEditing else { return }
        
        let blindSpotInsetValue: CGFloat = 5
        let blindSpotInsets = isLastTouchInBounds ? UIEdgeInsets(-blindSpotInsetValue) : UIEdgeInsets(blindSpotInsetValue)
        
        let touchLocation = sender.location(in: self)
        let isTouchInBounds = bounds.inset(by: blindSpotInsets).contains(touchLocation)
        
        if sender.state == .began {
            animateLongPressBegan()
        } else if sender.state == .ended {
            amimateLongPressEnded { [weak self] in
                if isTouchInBounds {
                    self?.longPressDidEndHandler?()
                }
            }
        } else if sender.state == .changed {
            let touchMovedInside = isTouchInBounds && !isLastTouchInBounds
            let touchMovedOutside = !isTouchInBounds && isLastTouchInBounds
            
            if touchMovedInside {
                animateLongPressBegan()
            } else if touchMovedOutside {
                amimateLongPressEnded()
            }
        }
        
        isLastTouchInBounds = isTouchInBounds
    }
    
    @objc func deleteButtonDidTap(_ sender: UIButton) {
        animateEditingEnded(duration: 0.1) { [weak self] in
            self?.isEditing = false
            self?.deleteButtonDidTapHandler?()
        }
    }
}
