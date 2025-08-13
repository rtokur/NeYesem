//
//  CategoryBarView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 12.08.2025.
//

import UIKit
import SnapKit

final class CategoryBarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var categories: [String] = ["🥬 Sebzeler", "🍞 Tahıllar", "🥩 Et ve Proteinler", "🧀 Süt Ürünler", "🍫 Atıştırmalıklar"] {
        didSet { collectionView.reloadData() }
    }

    private var selectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)

    var onSelectionChanged: ((String, Int) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        DispatchQueue.main.async { [weak self] in
            guard let self, let selected = self.selectedIndexPath, self.categories.indices.contains(selected.item) else { return }
            self.collectionView.selectItem(at: selected, animated: false, scrollPosition: [])
            self.onSelectionChanged?(self.categories[selected.item], selected.item)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func select(index: Int, animated: Bool = true) {
        guard index >= 0, index < categories.count else { return }
        let new = IndexPath(item: index, section: 0)

        if let old = selectedIndexPath, old != new {
            collectionView.deselectItem(at: old, animated: animated)
        }
        selectedIndexPath = new
        collectionView.selectItem(at: new, animated: animated, scrollPosition: .centeredHorizontally)
        onSelectionChanged?(categories[index], index)
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseID,
            for: indexPath
        ) as! CategoryCollectionViewCell
        cell.configure(title: categories[indexPath.item])

        if indexPath == selectedIndexPath {
            cell.isSelected = true
        }
        return cell
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let old = selectedIndexPath, old != indexPath {
            collectionView.deselectItem(at: old, animated: false)
        }
        selectedIndexPath = indexPath
        onSelectionChanged?(categories[indexPath.item], indexPath.item)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = categories[indexPath.item] as NSString
        let font = UIFont.dmSansSemiBold(11)
        let textSize = title.size(withAttributes: [.font: font])
        let horizontalPadding: CGFloat = 20
        let height: CGFloat = 36
        return CGSize(width: ceil(textSize.width) + horizontalPadding, height: height)
    }
}
