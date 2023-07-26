//
//  NewsModel.swift
//  newsApp
//
//  Created by Felipe Muller on 24/07/23.
//

import Foundation

// struc que representa os dados que são retornados pela API
struct NewsModel: Codable { // Codable é um protocolo para nos permite decodificar, ou seja, transforme em json e vice-versa
    var source: SourceModel
    var author: String?
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: Date
    var content: String?
}
