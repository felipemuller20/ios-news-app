//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Felipe Muller on 25/07/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceNameLabel: UILabel! // Faz o link com a view NewsTableViewCell
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    
    public var news: NewsModel? { // Assim que news receber valor, faça isso:
        didSet {
            self.sourceNameLabel.text = news?.source.name
            self.authorLabel.text = news?.author
            self.titleLabel.text = news?.title
            self.descriptionLabel.text = news?.description
            self.publishedAtLabel.text = news?.publishedAt.toString() // precisa transformar em string pois é data. Mas toString não existe, então ciraremos a extension lá embaixo.
            self.imageImageView.loadImage(from: news?.urlToImage) // loadImage também não existe, portanto iremos criar na extension lá embaixo.
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink)) // Cria "tap" para ser o toque na imagem do link, já que não existe essa função em imagens. Não existe o selector  openLink, portanto criaremos logo abaixo
        self.linkImageView.isUserInteractionEnabled = true // habilita interação, pois imagem nao tem por padrão
        self.linkImageView.addGestureRecognizer(tap) // adiciona a função tap.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func openLink() {
        guard let news = news, let url = URL(string: news.url) else { return } // guard "garante que aconteça tal coisa", senão vai pro else. Aqui só estamos retornando, mas poderíamos fazer qualquer coisa.
        UIApplication.shared.open(url) // essa função abre a url em algum app, se existir (youtube, linkedin, etc). Se não tiver, vai pro navegador.
    }
    
}

extension UIImageView {
    
     func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(named: "no-image.png")
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func loadImage(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        if link != nil {
            guard let link = link, let url = URL(string: link) else { return }
            downloadImage(from: url, contentMode: contentMode)
        } else {
            self.image = UIImage(named: "no-image.png")
        }
    }

}

extension Date {
    func toString(with formatter: String = "dd/MM/yyyy") -> String? {
        let dateFormat = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            dateFormat.dateFormat = "HH:mm"
            dateFormat.locale = Locale.init(identifier: "pt-br")
            dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            return "Hoje às \(dateFormat.string(from: self))"
        }
        dateFormat.dateFormat = formatter
        return dateFormat.string(from: self)
    }
}
