//
//  SmartVision
//
//  Created by ferhatiltas on 1.06.2023.
//

import UIKit

protocol MeasureDelegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int)
}

class Measure {
    var delegate: MeasureDelegate?

    var index: Int = -1
    var measurements: [[String: Double]]

    init() {
        let measurement = [
            "start": CACurrentMediaTime(),
            "end": CACurrentMediaTime()
        ]
        measurements = [[String: Double]](repeating: measurement, count: 30)
    }

    func changeMeasureIndex() {
        index += 1
        index %= 30
        measurements[index] = [:]

        setMeasure(for: index, with: "start")
    }

    func calculateMeasure() {
        setMeasure(for: index, with: "end")

        let beforeMeasurement = getBeforeMeasurment(for: index)
        let currentMeasurement = measurements[index]
        if let startTime = currentMeasurement["start"],
           let endInferenceTime = currentMeasurement["endInference"],
           let endTime = currentMeasurement["end"],
           let beforeStartTime = beforeMeasurement["start"]
        {
            delegate?.updateMeasure(inferenceTime: endInferenceTime - startTime,
                                    executionTime: endTime - startTime,
                                    fps: Int(1 / (startTime - beforeStartTime)))
        }
    }

    func 🏷(with msg: String? = "") {
        setMeasure(for: index, with: msg)
    }

    private func setMeasure(for index: Int, with msg: String? = "") {
        if let message = msg {
            measurements[index][message] = CACurrentMediaTime()
        }
    }

    private func getBeforeMeasurment(for index: Int) -> [String: Double] {
        return measurements[(index + 30 - 1) % 30]
    }

    func 🖨() {}
}

class MeasureLogView: UIView {
    let etimeLabel = UILabel(frame: .zero)
    let fpsLabel = UILabel(frame: .zero)

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
