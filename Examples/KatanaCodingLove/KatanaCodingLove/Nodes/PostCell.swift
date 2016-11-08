//
//  PostCell.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements




extension PostCell {
    enum Keys: String {
        case titleLabel
        case gifImage
    }
    
    struct Props: NodeProps {
        var frame: CGRect = .zero
        var post: Post? = nil
    }
}

struct PostCell: NodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
    typealias StateType = EmptyState
    typealias PropsType = Props
    typealias NativeView = UIView
    
    var props: Props
    
    static var referenceSize: CGSize {
        return CGSize(width: 640, height: 300)
    }
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        return [
            Label(props: LabelProps.build({
                $0.key = Keys.titleLabel.rawValue
                $0.text = NSAttributedString(string: (props.post?.title)!, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 16)
                ])
                $0.textAlignment = NSTextAlignment.center
            })),
            Image(props: ImageProps.build({
                $0.key = Keys.gifImage.rawValue
                $0.image = props.post?.image
            })),
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>, props: Props, state: EmptyState) {
        let rootView = views.nativeView
        let title = views[Keys.titleLabel]!
        let imageView = views[Keys.gifImage]!

        title.asHeader(rootView, insets: .scalable(30, 0, 0, 0))
        title.height = .scalable(50)

        imageView.fillHorizontally(rootView)
        imageView.top = title.bottom
        imageView.bottom = rootView.bottom
    }
    
}
