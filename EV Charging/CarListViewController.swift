//
//  CarListViewController.swift
//  EV Charging
//
//  Created by Olivier Miserez on 12/09/2024.
//

import UIKit

class CarListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv: UITableView = .init(frame: .zero)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car list"
        view.backgroundColor = Colors.white
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CarListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "defaultCell")
        
        cell.textLabel?.text = "Tesla Model Y - 75 kWh"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
}
