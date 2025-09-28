//
//  IIIF.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import Foundation

enum IIIF {
    static func imageURL(for imageID: String?, sizeSegment: String = "full/843,") -> URL? {
        guard let imageID = imageID else { return nil }
        // Sample Link: https://www.artic.edu/iiif/2/{imageID}/full/843,/0/default.jpg
        return URL(string: "https://www.artic.edu/iiif/2/\(imageID)/\(sizeSegment)/0/default.jpg")
    }
}
