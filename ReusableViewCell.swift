//
//  ReusableViewCell.swift
//
//
//  Created by Anıl Göktaş on 4/28/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

// MARK: - ReusableViewCell

protocol ReusableViewCell: ReusableView, NibLoadableView {
    func didEndDisplaying()
}

extension ReusableViewCell {
    func didEndDisplaying() { }
}

// MARK: - ReusableView

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(self)
    }

}

// MARK: - NibLoadableView

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(self)
    }

}

// MARK: - UICollectionView

extension UICollectionView {
    
    func register<ReusableViewCell: UICollectionViewCell where ReusableViewCell: ReusableView>(_: ReusableViewCell.Type) {
        registerClass(ReusableViewCell.self, forCellWithReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func register<ReusableViewCell: UICollectionViewCell where ReusableViewCell: ReusableView, ReusableViewCell: NibLoadableView>(_: ReusableViewCell.Type) {
        let bundle = NSBundle(forClass: ReusableViewCell.self)
        let nib = UINib(nibName: ReusableViewCell.nibName, bundle: bundle)
        
        registerNib(nib, forCellWithReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func dequeueReusableCell<ReusableViewCell: UICollectionViewCell where ReusableViewCell: ReusableView>(forIndexPath indexPath: NSIndexPath) -> ReusableViewCell {
        guard let cell = dequeueReusableCellWithReuseIdentifier(ReusableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ReusableViewCell else {
            fatalError("Could not dequeue cell with identifier: \(ReusableViewCell.reuseIdentifier)")
        }
        return cell
    }
    
}

// MARK: - UITableView

extension UITableView {
    
    func register<ReusableViewCell: UITableViewCell where ReusableViewCell: ReusableView>(_: ReusableViewCell.Type) {
        registerClass(ReusableViewCell.self, forCellReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func register<ReusableViewCell: UITableViewCell where ReusableViewCell: ReusableView, ReusableViewCell: NibLoadableView>(_: ReusableViewCell.Type) {
        let bundle = NSBundle(forClass: ReusableViewCell.self)
        let nib = UINib(nibName: ReusableViewCell.nibName, bundle: bundle)
        
        registerNib(nib, forCellReuseIdentifier: ReusableViewCell.reuseIdentifier)
    }
    
    func dequeueReusableCell<ReusableViewCell: UITableViewCell where ReusableViewCell: ReusableView>(forIndexPath indexPath: NSIndexPath) -> ReusableViewCell {
        guard let cell = dequeueReusableCellWithIdentifier(ReusableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ReusableViewCell else {
            fatalError("Could not dequeue cell with identifier: \(ReusableViewCell.reuseIdentifier)")
        }
        return cell
    }
    
}