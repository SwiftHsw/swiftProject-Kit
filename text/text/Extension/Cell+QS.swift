import UIKit

// MARK: - UITableView

extension UITableView {
    
    func register(_ cellTypes: [UITableViewCell.Type]) {
        for cellType in cellTypes {
            self.register(UINib(nibName: cellType.className, bundle: nil), forCellReuseIdentifier: cellType.className)
        }
    }
    
    func register(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.className, bundle: nil), forCellReuseIdentifier: cellType.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
}

// MARK: - UICollectionView

extension UICollectionView {
    
    func register(_ cellTypes: [UICollectionViewCell.Type]) {
        for cellType in cellTypes {
            self.register(UINib(nibName: cellType.className, bundle: nil), forCellWithReuseIdentifier: cellType.className)
        }
    }
    
    func register(_ cellType: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cellType.className, bundle: nil), forCellWithReuseIdentifier: cellType.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func register(_ reusableTypes: [UICollectionReusableView.Type]) {
        for reusableType in reusableTypes {
            self.register(UINib(nibName: reusableType.className, bundle: nil), forCellWithReuseIdentifier: reusableType.className)
        }
    }
    
    func register(_ reusableType: UICollectionReusableView.Type) {
        self.register(UINib(nibName: reusableType.className, bundle: nil), forCellWithReuseIdentifier: reusableType.className)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, withType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
}
