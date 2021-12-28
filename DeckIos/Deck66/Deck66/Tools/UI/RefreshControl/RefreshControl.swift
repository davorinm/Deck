import UIKit

class RefreshControl {
    
    enum RefreshControlState: Equatable {
        case resting // Default state, nothing is happening with refresh control.
        case assembling // User is dragging towards loading threshold, control is assembling.
        case showing // Triggered by startRefreshing
        case loading // User dragged over loading threshold, control is in loading animation.
        case error(String) // Error appears after progress and shutsdown after delay
        case hiding
        
        static func ==(lhs: RefreshControl.RefreshControlState, rhs: RefreshControl.RefreshControlState) -> Bool {
            switch (lhs, rhs) {
            case (.resting, .resting):
                return true
            case (.assembling, .assembling):
                return true
            case (.showing, .showing):
                return true
            case (.loading, .loading):
                return true
            case (.error, .error):
                return true
            case (.hiding, .hiding):
                return true
            default:
                return false
            }
        }
    }
    
    private let refreshViewContainer: RefreshViewContainer
    
    var refreshHandler: (() -> Void)?
    var isEnabled: Bool = true

    var isHidden: Bool {
        get {
            return refreshViewContainer.isHidden
        }
        set {
            refreshViewContainer.isHidden = newValue
        }
    }
    
    var backgroundColor: UIColor? {
        get {
            return refreshViewContainer.backgroundColor
        }
        set {
            refreshViewContainer.backgroundColor = newValue
        }
    }

    var tintColor: UIColor {
        get {
            return refreshViewContainer.tintColor
        }
        set {
            refreshViewContainer.tintColor = newValue
        }
    }
    
    private(set) var refreshState: RefreshControlState = .resting {
        didSet {
            if oldValue != refreshState {
                updateRefreshView()
            }
        }
    }
    
    var originInsetTop: CGFloat
    
    weak var scrollView: UIScrollView?
    private var scrollViewObserver: KeyValueObserver?
    
    private let height: CGFloat = 50.0
    
    init(with scrollView: UIScrollView) {
        
        originInsetTop = scrollView.contentInset.top
        
        let container = RefreshViewContainer(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: scrollView.frame.width,
                                                           height: height))
        scrollView.addSubview(container)
        scrollView.sendSubviewToBack(container)
        refreshViewContainer = container
        
        scrollViewObserver = KeyValueObserver(object: scrollView)
        scrollViewObserver?.observeCallback = { [unowned self] (keyPath: String?, change: [NSKeyValueChangeKey: AnyObject]?) -> Void in
            guard let keyPath = keyPath else {
                return
            }
            
            switch keyPath {
            case "contentOffset", "contentInset":
                self.updateRefreshLayout()
            default:
                break
            }
        }
        scrollViewObserver?.observeKeyPaths(keyPaths: ["contentOffset", "contentInset"])
        
        self.scrollView = scrollView
    }
    
    deinit {
        refreshViewContainer.removeFromSuperview()
    }
    
    /**
     Start refreshing
     */
    func startRefreshing() {
        refreshState = .showing
    }
    
    /**
     Ends refreshing
     */
    func endRefreshing() {
        refreshState = .hiding
    }
    
    /**
     Report error
     */
    func reportError(message: String) {
        refreshState = .error(message)
    }
    
    private func updateRefreshLayout() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        let spaceHeight = -(scrollView.contentOffset.y - scrollView.contentInset.top)
        let progress = spaceHeight / height
        
        if self.isEnabled {
            if progress >= 1.0 && scrollView.isDragging == false {
                refreshState = .loading
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // delay added so loading animation is shown for at least a bit
                    self.refreshHandler?()
                }
            } else if progress > 0.0 && scrollView.isDragging && !scrollView.isDecelerating {
                refreshState = .assembling
            } else if progress == 0.0 {
                refreshState = .resting
            }
        }
        
        switch refreshState {
        case .showing :
            var fram = refreshViewContainer.frame
            fram.origin.y = -height
            fram.size.height = height
            refreshViewContainer.frame = fram
            
        case .loading, .error:
            var fram = refreshViewContainer.frame
            fram.origin.y = scrollView.contentOffset.y
            fram.size.height = height
            refreshViewContainer.frame = fram
            
        case .hiding:
            var fram = refreshViewContainer.frame
            fram.origin.y = scrollView.contentOffset.y
            fram.size.height = height
            refreshViewContainer.frame = fram
            
        default:
            var fram = refreshViewContainer.frame
            fram.origin.y = -spaceHeight
            fram.size.height = min(spaceHeight, height)
            refreshViewContainer.frame = fram
        }
        
        refreshViewContainer.progress = progress
    }
    
    private func updateRefreshView() {
        switch refreshState {
        case .assembling:
            let refreshView = RefreshControlAssembleView()
            self.refreshViewContainer.present(view: refreshView)
            
        case .showing, .loading:
            let refreshView = RefreshControlLoadingView()
            self.refreshViewContainer.present(view: refreshView)
            
            self.isEnabled = false
            
            showAnimatedIfNeeded(finished: {
                    self.isEnabled = true
            })
            
        case .resting:
            break
            
        case .error(let errorDescription):
            let errorView = RefreshControlErrorView()
            errorView.errorDescription = errorDescription
            self.refreshViewContainer.present(view: errorView)
            
            self.refreshState = .resting
            
        case .hiding:
            self.isEnabled = false
            
            hideAnimatedIfNeeded(finished: {
                self.refreshViewContainer.removeSubviews()
                self.isEnabled = true
            })
        }
        
        scrollView?.sendSubviewToBack(refreshViewContainer)
    }
    
    // MARK: - Animation
    
    private class AnimationData {
        var link: CADisplayLink?
        var startTime: TimeInterval = 0
        let animTime: TimeInterval = 0.33
        var operation: ((Double, AnimationData) -> Void)?
        var finished: (() -> Void)?
    }
    
    private var animationInProgress: Bool = false
    private var animationData: AnimationData?
    
    private func showAnimatedIfNeeded(finished: @escaping (() -> Void)) {
        guard let scrollView = scrollView, !self.animationInProgress else {
            return
        }
        
        if scrollView.contentOffset.y == 0 {
            // Expand scroll
            self.animationInProgress = true
            
            let animationData = startAnimation()
            animationData.operation = { progress, data in
                
                let diff = self.height * CGFloat(progress)
                
                var inset = scrollView.contentInset
                inset.top = self.originInsetTop + diff
                scrollView.contentInset = inset
                
                scrollView.contentOffset.y = -diff
            }
            animationData.finished = { [weak self] in
                
                self?.animationInProgress = false
                finished()
            }
            self.animationData = animationData
        } else if scrollView.contentOffset.y < -height {
            // Collapse scroll
            let distance = scrollView.contentOffset.y
            
            self.animationInProgress = true
            
            let animationData = startAnimation()
            animationData.operation = { progress, data in
                
                let diff = self.height * CGFloat(progress)
                
                var inset = scrollView.contentInset
                inset.top = self.originInsetTop + diff
                scrollView.contentInset = inset
                
                let rty = distance + self.height
                let ttt = distance - (rty * CGFloat(progress))
                scrollView.contentOffset.y = ttt
            }
            animationData.finished = { [weak self] in
                
                self?.animationInProgress = false
                finished()
            }
            self.animationData = animationData
        } else {
            DispatchQueue.main.async {
                finished()
            }
        }
    }
    
    private func hideAnimatedIfNeeded(finished: @escaping (() -> Void)) {
        guard let scrollView = scrollView else {
            return
        }
        
        self.animationInProgress = false
        
        if scrollView.contentInset.top != originInsetTop {
            let distance = scrollView.contentInset.top - originInsetTop
            
            let animationData = startAnimation()
            animationData.operation = { [weak self] progress, data in
                
                var inset = scrollView.contentInset
                inset.top = (self?.originInsetTop ?? 0) + distance * CGFloat(1.0 - progress)
                scrollView.contentInset = inset
            }
            animationData.finished = { [weak self] in
                
                self?.animationInProgress = false
                finished()
            }
            self.animationData = animationData
            
        } else {
            finished()
        }
    }
    
    private func stopAnimation() {
        if animationData?.link != nil {
            animationData!.link!.isPaused = true
            animationData!.link!.remove(from: RunLoop.main, forMode:RunLoop.Mode.common)
            animationData!.link = nil
        }
    }
    
    private func startAnimation() -> AnimationData {
        stopAnimation()
        
        let animationData = AnimationData()
        animationData.link = CADisplayLink(target: self, selector: #selector(onTick) )
        animationData.startTime = CACurrentMediaTime()
        animationData.link!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        
        return animationData
    }
    
    @objc func onTick() {
        guard let data = animationData else {
            return
        }
        
        let elapsed = CACurrentMediaTime() - data.startTime
        let frac = min(max(0,elapsed / data.animTime),1)
        
        data.operation?(frac, data)
        
        if (elapsed > data.animTime) {
            data.link!.isPaused = true
            animationData!.link!.remove(from: RunLoop.main, forMode:RunLoop.Mode.common)
            data.link = nil
            data.operation?(1.0, data)
            data.finished?()
            self.animationData = nil
        }
    }
}

fileprivate class RefreshViewContainer: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            for subview in self.subviews {
                if let loading = subview as? RefreshControlView {
                    loading.progress = progress
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepare()
    }
    
    private func prepare() {
        clipsToBounds = true
    }
    
    func present(view: UIView) {
        removeSubviews()
        self.addSubview(view)
        view.expandToParent()
    }
    
    func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
