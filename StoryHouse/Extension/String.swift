//
//  String.swift
//  buddyUpppp
//
//  Created by KMSOFT on 07/07/21.
//

import Foundation
import UIKit

extension String {
    
    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)
        
        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }
        
        return result
    }
    
    func trimRight() -> String {
        String(reversed().drop { $0.isWhitespace }.reversed())
    }
    
    var trim: String? {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var isAlphanumericAndUnderscope: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9_.]", options: .regularExpression) == nil
    }
    
    func getImage() -> UIImage? {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(self)
        if fileManager.fileExists(atPath: imagePAth) {
            return UIImage(contentsOfFile: imagePAth)
        }
        else {
            print("No Image")
        }
        return nil
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func convertDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension String {

    func stringByRemovingAll(subStrings: [String], replaceString: String) -> String {
        var resultString = self
        _ = subStrings.map { _ in resultString = resultString.replacingOccurrences(of: resultString, with: replaceString) }
        return resultString
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
