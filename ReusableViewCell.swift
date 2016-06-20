/*
 ReusableViewCell
 
 Created by Anıl Göktaş on 4/28/16.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

import Foundation

// MARK: - ReusableViewCell

protocol ReusableViewCell: ReusableView, NibLoadableView {
    static var estimatedHeight: CGFloat { get }
    
    func didEndDisplaying()
}

extension ReusableViewCell {
    static var estimatedHeight: CGFloat { return 44 }
    
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