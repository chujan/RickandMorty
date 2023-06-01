//
//  RMSearchOptionViewController.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 25/05/2023.
//

import UIKit

class RMSearchOptionViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private let option: RMSearchInputViewViewModel.DynamicOption
    private let selectionBlock: ((String) -> Void)
    
    init(option: RMSearchInputViewViewModel.DynamicOption, selection: @escaping (String) -> Void) {
        self.option = option
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setUpTable()

       
    }
    
    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }

   
}
extension RMSearchOptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  option.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chioce = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = chioce.uppercased()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chioce = option.choices[indexPath.row]
        self.selectionBlock(chioce)
        dismiss(animated: true)
    }
    
    
    
}
    
    
    
    
    
    
    
    
    

