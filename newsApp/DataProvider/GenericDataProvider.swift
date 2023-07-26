//
//  GenericDataProvider.swift
//  newsApp
//
//  Created by Felipe Muller on 24/07/23.
//

import Foundation

protocol GenericDataProvider { // Esse protocolo será assinado pela classe que irá executar o programa, no ViewController
    // Basicamente, ao executar, o programa poderá retornar sucesso, caso ocorra tudo bem
    func success(model: Any) // nesse caso, o sucesso irá retornar o "model", ou seja, as informações
    
    // Ou o programa poderá retornar erro
    func failure(_ provide: GenericDataProvider?, error: Error) // Se erro, irá retornar qual o provider utilizado e qual o erro apresentado
}

class DataProviderManager<T, S> { // T e S são genéricos, portanto serão atribuídos no momento que são criados
    // T será o Provedor utilizado
    // S será o Model utilizado
    var delegate: T? // Irá delegar o que aconteceu (sucesso ou erro)
    var model: S? // Irá retornar o model, em caso de sucesso
}
