//
//  ViewController.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import UIKit

class TubeStatusViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = UITableView()
        private var viewModel: TubeLineStatusViewModel!

        override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            viewModel = TubeLineStatusViewModel(networkService: NetworkService()) // Initialize with real NetworkService
            viewModel.onTubeStatusesLoaded = { [weak self] in
                self?.tableView.reloadData()
            }
            viewModel.onError = { error in
                // Handle error (e.g., show an alert)
            }
            viewModel.loadTubeStatuses()
        }

        private func setupTableView() {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.register(TubeStatusTableViewCell.self, forCellReuseIdentifier: TubeStatusTableViewCell.identifier)
            tableView.rowHeight = UITableView.automaticDimension
            //tableView.estimatedRowHeight = 44 

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.tubeLineStatuses.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TubeStatusTableViewCell.identifier, for: indexPath) as? TubeStatusTableViewCell else {
                return UITableViewCell()
            }

            let lineStatus = viewModel.tubeLineStatuses[indexPath.row]
            cell.configure(with: lineStatus)
            return cell
        }
    }

