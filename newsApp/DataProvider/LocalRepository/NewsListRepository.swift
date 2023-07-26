//
//  NewsListRepository.swift
//  newsApp
//
//  Created by Felipe Muller on 24/07/23.
//

import Foundation

enum NewsListError: Error {
    case fileNotFound
}

class NewsListRepository { // Ler e converter os dados json
    // Essa será uma classe SINGLETON. Significa que os dados são instanciados uma única vez, na sua execução.
    // Sua criação é padrão: static var shared, que "instancía" os valores da própria classe e as retorna
    static var shared: NewsListRepository = {
        let instance = NewsListRepository()
        return instance
    }()
    
    private init() {} // privado para garantir que não serão criadas novas instancias
    
    // Por fim, um singleton precisa de uma função com alguma lógica, para recuperar os valores que serão retornados. No caso, ler e converter os dados do arquivo json
    
    // Essa função tentará ler os dados do arquivo
    func getNewsList(conclusion: ([NewsModel]?, Error?) -> Void) { // pode retornar erro se a lista nao existir
        if let path = Bundle.main.path(forResource: "newsList", ofType: "json") { // busca o arquivo newsList.json, por meio do Bundle.main
            do { // precisamos converter a string retornada em dados. Pode dar erro se não encontrar, então do/catch
                let url = URL(fileURLWithPath: path) // transforma o path em URL
                let data = try Data(contentsOf: url, options: .mappedIfSafe) // transforma a URL em data
                
                let decoder = JSONDecoder() // Decodifica um json para um objeto
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full) // formata a data de acordo com DateFormatter criado abaixo
                let newsModelList = try decoder.decode([NewsModel].self, from: data) // decodifica um NewsModel a partir dos dados recuperados (basicamente pega o valor do json e decodifica de acordo com o NewsModel. Para isso, NewsModel precisa assinar o protocolo "Codable".
                conclusion(newsModelList, nil)
            } catch {
                conclusion(nil, error)
            }
        } else {
            conclusion(nil, NewsListError.fileNotFound)
        }
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
