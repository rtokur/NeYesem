//
//  SortViewController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 24.08.2025.
//

import UIKit
import SnapKit

class SortViewController: UIViewController {
    
    //MARK: - Properties
    private let options = [
        "Newest First",
        "Oldest First",
        "Alphabetical (A→Z)",
        "Alphabetical (Z→A)",
        "Preparation Time (Short → Long)",
        "Preparation Time (Long → Short)",
        "Calories (Low → High)",
        "Calories (High → Low)"
    ]
    
    private var selectedIndex: IndexPath? = IndexPath(row: 0,
                                                      section: 0)
    private var tableViewHeightConstraint: Constraint?
    var onSelection: ((String) -> Void)?

    //MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort"
        label.font = .dmSansSemiBold(18)
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .plain)
        tableView.register(RadioOptionTableViewCell.self,
                           forCellReuseIdentifier: RadioOptionTableViewCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 36
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        if let selectedIndex {
            onSelection?(options[selectedIndex.row])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint?.update(offset: tableView.contentSize.height)
    }
    //MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tableView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(25)
        }
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(1).constraint
        }
    }
}

// MARK: - TableView
extension SortViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioOptionTableViewCell.reuseID, for: indexPath) as! RadioOptionTableViewCell
        let isSelected = indexPath == selectedIndex
        cell.configure(title: options[indexPath.row],
                       selected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldIndex = selectedIndex
        selectedIndex = indexPath
        var reload: [IndexPath] = [indexPath]
        if let oldIndex { reload.append(oldIndex) }
        tableView.reloadRows(at: reload, with: .none)
        
        let selectedOption = options[indexPath.row]
        onSelection?(selectedOption)
    }
}
