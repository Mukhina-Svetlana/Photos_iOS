//
//  MainViewController.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let cellId = "cell"
    let defaults = UserDefaults.standard
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .secondarySystemBackground
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(false, forKey: "exitPress")
        title = "Пользователи"
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = .black
        let buttonBar = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(exit))
        self.navigationItem.rightBarButtonItem  = buttonBar
         navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
       configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
extension MainViewController {
    private func configuration() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func exit() {
        let startViewController = UINavigationController(rootViewController: ViewController())
        startViewController.modalPresentationStyle = .fullScreen
        defaults.set(true, forKey: "exitPress")
        present(startViewController, animated: true, completion: nil)
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Base.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        cell.textForEachCell(name: Base.shared.users[indexPath.row].name, image: UIImage(data: Base.shared.users[indexPath.row].image)!)
        return cell
    }
}


