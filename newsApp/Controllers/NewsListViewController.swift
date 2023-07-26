//
//  ViewController.swift
//  newsApp
//
//  Created by Felipe Muller on 24/07/23.
//

import UIKit

class NewsListViewController: UIViewController {

    var localDataProvider: NewsListLocalDataProvider?
    @IBOutlet weak var NewsListTableView: UITableView! // TableView, arrastada lá da Main View
    
    private var newsList: [NewsModel]? { // Aqui está criando uma variável, que será a lista de notícias
        didSet { // informa um didSet, ou seja, "Após setar o valor de newsList, faça isso:
            self.NewsListTableView.reloadData()
            // Faz um reload nos dados. Sem isso a página irá capturar os valores depois de ter montado a página, e não apresentará nada.
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.initLocalDataProvider() // executa a função criada para inicializar os valores
    }

    private func setupTableView() {
        self.NewsListTableView.delegate = self // Sempre que clicar em algo na tela, o delegate irá realizar uma ação. No caso, o próprio ViewController
        self.NewsListTableView.dataSource = self
        self.NewsListTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell") // Registra o tableview na tableviewCell que criamos
        // Precisa assinar os protocolos DataSource e Delegate. Realizadas nas extensões abaixo.
    }
    
    private func initLocalDataProvider() {
        self.localDataProvider = NewsListLocalDataProvider() // cria o localDataProvider a partir da classe NewsListLocalDataProvider
        self.localDataProvider?.delegate = self // Quem irá controlar esse Provider é o próprio ViewController
        self.localDataProvider?.getNewsList() // Busca a lista
    }
}

// ViewController precisa assinar o protocolo do DataProvider para conseguir recuperar e utilizar os dados
extension NewsListViewController: NewsListLocalDataProviderProtocol {
  // precisa ter as funções success e failure para estar em conformidade com NewsListLocalDataProviderProtocol
    func success(model: Any) {
        self.newsList = model as? [NewsModel] // Precisamos informar que é do tipo NewsModel, pois é do tipo Any
    }
    
    func failure(_ provide: GenericDataProvider?, error: Error) {
        print(error.localizedDescription)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Quantas rows nossa table terá
        return self.newsList?.count ?? 0 // Vai ter o tamanho de newsList, ou 0 se não encontrar newslist
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Usado para vincularmos a Cell na nossa ViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("Unable to dequeue subclassed cell")
        } // Após criar nossa TableViewCell, garantimos que ela existe e conseguimos "desempilhar" a tableview criada
        
        guard let newsList = newsList else { // garante que existe a newsList
            fatalError("Unable to find news")
        }
        
        cell.news = newsList[indexPath.row] // Passa o valor da cell para o CellList

        return cell
        
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Função para quando selecionar uma tablerow
        print("Selecionou uma TableRow")
    }
}
