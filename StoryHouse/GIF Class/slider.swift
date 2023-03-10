import UIKit

final class Slider: UISlider {

    private let baseLayer = CALayer() // Step 3
    private let trackLayer = CAGradientLayer() // Step 7
    
    var sliderValueChangedCallback : (() -> Void)?
    var hideSliderCallback : (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
        self.valueChanged(self)
    }

    private func setup() {
        clear()
        createBaseLayer() // Step 3
        createThumbImageView() // Step 5
        configureTrackLayer() // Step 7
        addUserInteractions() // Step 8
    }

    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }

    // Step 3
    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.orange.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.orange.withAlphaComponent(0.2).cgColor
        baseLayer.frame = .init(x: 0, y: frame.height / 4, width: frame.width, height: frame.height / 2)
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        layer.insertSublayer(baseLayer, at: 0)
    }

    // Step 7
    private func configureTrackLayer() {
        let firstColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        let secondColor = UIColor.orange.withAlphaComponent(1).cgColor
        trackLayer.colors = [firstColor, secondColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: 0, height: frame.height / 2)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 1)
    }

    // Step 8
    private func addUserInteractions() {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    @objc private func valueChanged(_ sender: Slider) {
        // Step 10
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // Step 9
        var tempValue = value
        if value > 0.0 && value <= 0.20 {
            tempValue = 0.20
        } else if value > 0.20 && value <= 0.40 {
            tempValue = 0.40
        } else if value > 0.40 && value <= 0.60 {
            tempValue = 0.60
        } else if value > 0.60 && value <= 0.80 {
            tempValue = 0.80
        } else if value > 0.80 && value <= 1.0 {
            tempValue = 1
        }
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: tempValue)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: thumbRectA.midX, height: frame.height / 2)
        // Step 10
        CATransaction.commit()
        self.sliderValueChangedCallback?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideSliderCallback?()
    }
    
    

    // Step 5
    private func createThumbImageView() {
        let thumbSize = (3 * frame.height) / 4
        let thumbView = ThumbView(frame: .init(x: 0, y: 0, width: thumbSize, height: thumbSize))
        thumbView.layer.cornerRadius = thumbSize / 2
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        // Step 6
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
}

// Step 4
final class ThumbView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.orange
//        let middleView = UIView(frame: .init(x: frame.midX - 6, y: frame.midY - 6, width: 12, height: 12))
//        middleView.backgroundColor = .white
//        middleView.layer.cornerRadius = 6
//        addSubview(middleView)
    }
}

// Step 4
extension UIView {

    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
