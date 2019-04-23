/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit


@objc public protocol PinterestLayoutDelegate: class {
  // 1. Method to ask the delegate for the height of the image
    /**
     Size for section header. Optional.
     
     @param collectionView - collectionView
     @param section - section for section header view
     
     Returns size for section header view.
     */
    @objc optional func collectionView(collectionView: UICollectionView,
                                       sizeForSectionHeaderViewForSection section: Int) -> CGSize
    /**
     Size for section footer. Optional.
     
     @param collectionView - collectionView
     @param section - section for section footer view
     
     Returns size for section footer view.
     */
    @objc optional func collectionView(collectionView: UICollectionView,
                                       sizeForSectionFooterViewForSection section: Int) -> CGSize
    /**
     Height for image view in cell.
     
     @param collectionView - collectionView
     @param indexPath - index path for cell
     
     Returns height of image view.
     */
    func collectionView(collectionView: UICollectionView,
                        heightForItemAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat
    
    /**
     Height for annotation view (label) in cell.
     
     @param collectionView - collectionView
     @param indexPath - index path for cell
     
     Returns height of annotation view.
     */
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat
}



/**
 PinterestLayout.
 */
public class PinterestLayout: UICollectionViewLayout {
    
    /**
     Delegate.
     */
    public var delegate: PinterestLayoutDelegate!
    /**
     Number of columns.
     */
    public var numberOfColumns: Int = 2
    /**
     Cell padding.
     */
    public var cellPadding: CGFloat = 8
    
    
    private var cache = [PinterestLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        get {
            let bounds = collectionView.bounds
            let insets = collectionView.contentInset
            return bounds.width - insets.left - insets.right
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        get {
            return CGSize(
                width: contentWidth,
                height: contentHeight
            )
        }
    }
    
    override public class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    override public var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    private var numberOfSections: Int {
        return collectionView.numberOfSections
    }
    
    private func numberOfItems(inSection section: Int) -> Int {
        return collectionView.numberOfItems(inSection: section)
    }
    
    /**
     Invalidates layout.
     */
    override public func invalidateLayout() {
        cache.removeAll()
        contentHeight = 0
        
        super.invalidateLayout()
    }
    
    override public func prepare() {
        if cache.isEmpty {
            let collumnWidth = contentWidth / CGFloat(numberOfColumns)
            let cellWidth = collumnWidth - (cellPadding * 2)
            
            var xOffsets = [CGFloat]()
            
            for collumn in 0..<numberOfColumns {
                xOffsets.append(CGFloat(collumn) * collumnWidth)
            }
            
            for section in 0..<numberOfSections {
                let numberOfItems = self.numberOfItems(inSection: section)
                
                if let headerSize = delegate.collectionView?(
                    collectionView: collectionView,
                    sizeForSectionHeaderViewForSection: section
                    ) {
                    let headerX = (contentWidth - headerSize.width) / 2
                    let headerFrame = CGRect(
                        origin: CGPoint(
                            x: headerX,
                            y: contentHeight
                        ),
                        size: headerSize
                    )
                    let headerAttributes = PinterestLayoutAttributes(
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        with: IndexPath(item: 0, section: section)
                    )
                    headerAttributes.frame = headerFrame
                    cache.append(headerAttributes)
                    
                    contentHeight = headerFrame.maxY
                }
                
                var yOffsets = [CGFloat](
                    repeating: contentHeight,
                    count: numberOfColumns
                )
                
                for item in 0..<numberOfItems {
                    let indexPath = IndexPath(item: item, section: section)
                    
                    let column = yOffsets.index(of: yOffsets.min() ?? 0) ?? 0
                    
                    let imageHeight = delegate.collectionView(
                        collectionView: collectionView,
                        heightForItemAtIndexPath: indexPath,
                        withWidth: cellWidth
                    )
                    let annotationHeight = delegate.collectionView(
                        collectionView: collectionView,
                        heightForAnnotationAtIndexPath: indexPath,
                        withWidth: cellWidth
                    )
                    let cellHeight = cellPadding + imageHeight + annotationHeight + cellPadding
                    
                    let frame = CGRect(
                        x: xOffsets[column],
                        y: yOffsets[column],
                        width: collumnWidth,
                        height: cellHeight
                    )
                    
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    let attributes = PinterestLayoutAttributes(
                        forCellWith: indexPath
                    )
                    attributes.frame = insetFrame
                    attributes.imageHeight = imageHeight
                    cache.append(attributes)
                    
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[column] = yOffsets[column] + cellHeight
                }
                
                if let footerSize = delegate.collectionView?(
                    collectionView: collectionView,
                    sizeForSectionFooterViewForSection: section
                    ) {
                    let footerX = (contentWidth - footerSize.width) / 2
                    let footerFrame = CGRect(
                        origin: CGPoint(
                            x: footerX,
                            y: contentHeight
                        ),
                        size: footerSize
                    )
                    let footerAttributes = PinterestLayoutAttributes(
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        with: IndexPath(item: 0, section: section)
                    )
                    footerAttributes.frame = footerFrame
                    cache.append(footerAttributes)
                    
                    contentHeight = footerFrame.maxY
                }
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
}


/////

public class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    /**
     Image height to be set to contstraint in collection view cell.
     */
    public var imageHeight: CGFloat = 0
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
