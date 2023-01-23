//
//  MPVolumeView.swift
//  StoryHouse
//
//  Created by iMac on 20/01/23.
//

import Foundation
import MediaPlayer

extension MPVolumeView {
    
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider?.value = volume
        }
    }
}
