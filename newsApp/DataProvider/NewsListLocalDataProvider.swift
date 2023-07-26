//
//  NewsListLocalDataProvider.swift
//  newsApp
//
//  Created by Felipe Muller on 24/07/23.
//

import Foundation

protocol NewsListLocalDataProviderProtocol: GenericDataProvider { } // Basicamente está herdando o GenericDataProvider

// Essa classe irá recuperar os valores armazenados pelo "repository"
// Essa classe assina o DataProvider, que por sua vez recebe dois valores genéricos: o protocolo que será usado e o model que será retornado
// Nesse caso o protocolo é o que acabamos de criar, que assina "GenericDataProvider", enquanto o Model é o NewsModel, contendo as infos
class NewsListLocalDataProvider: DataProviderManager<NewsListLocalDataProviderProtocol, NewsModel> {
    
    func getNewsList() { // Acessa o repositório e tenta ler os dados. Se der erro, chama o failure. Se der sucesso, chama o sucesso
        NewsListRepository.shared.getNewsList { newModelList, error in
            if let error = error {
                self.delegate?.failure(self.delegate, error: error) // se der erro retorna qual o provedor que deu erro e qual o erro
            }
            
            if let newModelList = newModelList {
                self.delegate?.success(model: newModelList) // se der sucesso, retorna o model
            }
        }
    }

}
