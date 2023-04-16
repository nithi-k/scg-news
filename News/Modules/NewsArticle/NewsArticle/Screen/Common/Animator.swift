//
//  Animator.swift
//  CoreUI
//
//  Created by Nithi Kulasiriswatdi on 16/4/2566 BE.
//

import UIKit
import CoreUI
import Utils

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.25

    private let type: PresentationType
    private let rootViewController: ArticleListViewController
    private let destinationViewController: ArticleDetailViewController
    private var cellImageSnapShot: UIView
    private let cellImageViewRect: CGRect
    
    /// Init Animator
    /// - Parameters:
    ///   - type: PresentType (present or dismiss)
    ///   - rootViewController: Root viewcontroller
    ///   - destinationViewController: Destination viewContoller
    ///   - cellImageSnapShot: Snap imageShort (Article image)
    init?(
        type: PresentationType,
        rootViewController: ArticleListViewController,
        destinationViewController: ArticleDetailViewController,
        cellImageSnapShot: UIView
    ) {
        self.type = type
        self.rootViewController = rootViewController
        self.destinationViewController = destinationViewController
        self.cellImageSnapShot = cellImageSnapShot
        cellImageSnapShot.clipsToBounds = true
        
        guard
            let window = rootViewController.view.window ?? destinationViewController.view.window,
            let selectedCell = rootViewController.selectedCell
        else { return nil }
        self.cellImageViewRect = selectedCell.articleImageView.convert(selectedCell.articleImageView.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = destinationViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)

        guard
            let selectedCell = rootViewController.selectedCell,
            let window = rootViewController.view.window ?? destinationViewController.view.window,
            let cellImageSnapshot = selectedCell.articleImageView.snap(),
            let controllerImageSnapshot = destinationViewController.articleImageView.snap() else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = destinationViewController.view.backgroundColor

        if isPresenting {
            cellImageSnapShot = cellImageSnapshot
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = rootViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        toView.alpha = 0

        [backgroundView, cellImageSnapShot, controllerImageSnapshot].forEach {
            containerView.addSubview($0)
        }
        
        let articleImageView = destinationViewController.articleImageView
        let controllerImageViewRect = articleImageView.convert(articleImageView.bounds, to: window)
        [cellImageSnapShot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }

        [controllerImageSnapshot, cellImageSnapShot].forEach {
            $0.alpha = isPresenting ? 0 : 1
        }

        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.cellImageSnapShot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                fadeView.alpha = isPresenting ? 1 : 0
                [controllerImageSnapshot, self.cellImageSnapShot].forEach {
                    if isPresenting {
                        $0.roundCorners(
                            radius: CUIStyler.layout.standardSpace,
                            corners: [.topLeft, .topRight]
                        )
                    } else {
                        $0.roundCorners(
                            radius: CUIStyler.layout.standardSpace,
                            corners: [.topRight, .bottomRight]
                        )
                    }
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.cellImageSnapShot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            self.cellImageSnapShot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}

private extension UIView {
    func snap() -> UIView? {
        return self.snapshotView(afterScreenUpdates: true)
    }
}

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
