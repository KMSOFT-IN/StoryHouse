//
//  LoadingButtons.swift
//  StoryHouse
//
//  Created by kmsoft on 13/03/23.
//

import Foundation
import MHLoadingButton

//enum IndicatorType: String {
//    case sysDefault = "System Default"
//    case material = "Material Design"
//    case ballPulseSync = "Ball Pulse Sync"
//    case ballSpinFade = "Ball Spin"
//    case ballPulse = "Ball Pulse"
//    case lineScalePulse = "Line Scale Pulse"
//    case lineScale = "Line Scale"
//    case ballBeat = "Ball Beat"
//    case lineSpin = "Line Spin"
//    
//    var indicator: UIView & IndicatorProtocol {
//        // Add light and dark theme loader for iOS 13.0 or later platform.
//        if #available(iOS 13.0, *) {
//            switch self {
//            case .sysDefault:
//                let indicator = UIActivityIndicatorView()
//                indicator.color = .label
//                return indicator
//            case .material:
//                return MaterialLoadingIndicator(color: .label)
//            case .ballPulseSync:
//                return BallPulseSyncIndicator(color: .label)
//            case .ballSpinFade:
//                return BallSpinFadeIndicator(color: .label)
//            case .lineScalePulse:
//                return LineScalePulseIndicator(color: .label)
//            case .lineScale:
//                return LineScaleIndicator(color: .label)
//            case .ballPulse:
//                return BallPulseIndicator(color: .label)
//            case .ballBeat:
//                return BallBeatIndicator(color: .label)
//            case .lineSpin:
//                return LineSpinFadeLoader(color: .label)
//            }
//        } else {
//            switch self {
//            case .sysDefault:
//                let indicator = UIActivityIndicatorView()
//                indicator.color = .darkGray
//                return indicator
//            case .material:
//                return MaterialLoadingIndicator(color: .gray)
//            case .ballPulseSync:
//                return BallPulseSyncIndicator(color: .gray)
//            case .ballSpinFade:
//                return BallSpinFadeIndicator(color: .gray)
//            case .lineScalePulse:
//                return LineScalePulseIndicator(color: .gray)
//            case .lineScale:
//                return LineScaleIndicator(color: .gray)
//            case .ballPulse:
//                return BallPulseIndicator(color: .gray)
//            case .ballBeat:
//                return BallBeatIndicator(color: .gray)
//            case .lineSpin:
//                return LineSpinFadeLoader(color: .gray)
//            }
//        }
//    }
//}
