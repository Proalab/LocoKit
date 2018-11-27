//
// Created by Matt Greenfield on 14/04/16.
// Copyright (c) 2016 Big Paua. All rights reserved.
//

import CoreLocation

public extension String {

    public init(duration: TimeInterval, style: DateComponentsFormatter.UnitsStyle = .full, maximumUnits: Int = 2, alwaysIncludeSeconds: Bool = false) {
        if duration.isNaN {
            self.init(format: "NaN")
            return
        }

        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = maximumUnits
        formatter.unitsStyle = style

        if alwaysIncludeSeconds || duration < 60 * 2 {
            formatter.allowedUnits = [.second, .minute, .hour, .day, .month]
        } else {
            formatter.allowedUnits = [.minute, .hour, .day, .month]
        }

        self.init(format: formatter.string(from: duration)!)
    }

    public init(metres: CLLocationDistance, style: MeasurementFormatter.UnitStyle = .long, isAltitude: Bool = false) {
        let formatter = MeasurementFormatter()

        if isAltitude {
            formatter.unitOptions = .providedUnit
            formatter.numberFormatter.maximumFractionDigits = 0
            if Locale.current.usesMetricSystem {
                self.init(format: formatter.string(from: metres.measurement))
            } else {
                self.init(format: formatter.string(from: metres.measurement.converted(to: UnitLength.feet)))
            }
            return
        }

        formatter.unitOptions = .naturalScale
        if metres < 1000 || metres > 20000 {
            formatter.numberFormatter.maximumFractionDigits = 0
        } else {
            formatter.numberFormatter.maximumFractionDigits = 1
        }
        self.init(format: formatter.string(from: metres.measurement))
    }

    public init(speed: CLLocationSpeed) {
        self.init(metresPerSecond: speed)
    }
    
    public init(metresPerSecond mps: CLLocationSpeed) {
        if Locale.current.usesMetricSystem {
            if mps.kmh < 10 {
                self.init(format: "%.1f km/h", mps.kmh)
            } else {
                self.init(format: "%.0f km/h", mps.kmh)
            }

        } else {
            let mph = mps.kmh / 1.609344
            if mph < 10 {
                self.init(format: "%.1f mph", mph)
            } else {
                self.init(format: "%.0f mph", mph)
            }
        }
    }

}
