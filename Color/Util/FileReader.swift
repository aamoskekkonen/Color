//
//  FileReader.swift
//  Color
//
//  Created by Aamos Kekkonen on 26.5.2023.
//
import Foundation

class FileReader {
    static func readColors() throws -> [OklchColor] {
        guard let fileURL = Bundle.main.url(forResource: "colors", withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate colors.json"])
        }
        
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: fileURL)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to load colors.json"])
        }

        let colors: [OklchColor]? = try JSONDecoder().decode([String: [OklchColor]].self, from: jsonData)["colors"]

        guard let decodedColors = colors else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode colors"])
        }

        return decodedColors
    }
}
