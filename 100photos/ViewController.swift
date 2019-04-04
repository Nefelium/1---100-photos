//
//  ViewController.swift
//  100photos
//
//  Created by admin on 21.01.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array100 = [String]()
    let linkBase: String = "http://placehold.it/375x150?text="
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array100.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // можно было бы создать класс ячейки, но в рамках конкретной задачи, считаю, достаточно и этого
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // переиспользование ячеек
        let url = URL(string: array100[indexPath.row])
        downloadImage(withURL: url!, forCell: cell)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array100 = get100PhotoLinks()
    }

    //функция заполнения массива ссылками
    func get100PhotoLinks() -> [String] {
        var array = [String]()
        for i in 0...99 {
          array.append(self.linkBase + "\(i+1)")
        }
        return array
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        let imageView = cell.imageView
        let downloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async { // асинхронная очередь, главный поток
                imageView?.image = image;
                cell.setNeedsLayout(); //обновление ячейки
            }
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        };
        
        downloadTask.resume();
    }
    
    
}

