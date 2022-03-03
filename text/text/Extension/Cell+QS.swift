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
    
    /**
      Register cell class
      
      - parameter aClass: class
      */
     func sw_registerHeaderFooterClass<T: UIView>(_ aClass: T.Type) {
         let name = String(describing: aClass)
         self.register(aClass, forHeaderFooterViewReuseIdentifier: name)
     }
     
    func sw_registerHeaderFooterNib<T: UIView>(_ aClass: T.Type) {
           let name = String(describing: aClass)
           let nib = UINib(nibName: name, bundle: nil)
           self.register(nib, forHeaderFooterViewReuseIdentifier: name)
       }
    
    
     /**
      Reusable Cell
      
      - parameter aClass:    class
      
      - returns: cell
      */
     func sw_dequeueReusableHeaderFooter<T: UIView>(_ aClass: T.Type) -> T! {
         let name = String(describing: aClass)
         guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
             fatalError("\(name) is not registed")
         }
         return cell
     }
    
   /**
       Register cell class
       
       - parameter aClass: class
       */
      func sw_registerCellClass<T: UITableViewCell>(_ aClass: T.Type) {
          let name = String(describing: aClass)
          self.register(aClass, forCellReuseIdentifier: name)
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
