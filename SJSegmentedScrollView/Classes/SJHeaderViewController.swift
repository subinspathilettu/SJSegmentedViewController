public class SJHeaderViewController: UIViewController {

    /**
     *  Array of ViewControllers for segments.
     */
    public var viewControllers = [UIViewController]()
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRectZero)
    var segmentScrollViewTopConstraint: NSLayoutConstraint?
    var bodyContentView:SJContentView?
    var timer:NSTimer?
    var autoScrollTime = 3.0
    var startingIndex = 0
    private var currentIndex = 0
    //TODO: actual number of pages, To get looping we will add a fake controller
    private var actualNumberOfPages:Int!
    var loopController:UIViewController!
    var pageControl = UIPageControl()


    convenience public init(viewControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        actualNumberOfPages = self.viewControllers.count
        }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        super.loadView()
        addSegmentedScrollView()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        //TODO: add page control
        self.addPageControl(actualNumberOfPages, startingPage: 0)
        makeInfiniteLoop()
        loadControllers()
        self.segmentedScrollView.showsVerticalScrollIndicator = false
        self.segmentedScrollView.showsHorizontalScrollIndicator = false
        self.segmentedScrollView.contentView?.showsHorizontalScrollIndicator
        bodyContentView?.addObserver(self,
                                     forKeyPath: "contentOffset",
                                     options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old],
                                     context: nil)

    }

    // To create infinite loop, duplicate the first controller
    func makeInfiniteLoop(){
        let firstControllerType = viewControllers[0].dynamicType
      //  loopController = firstControllerType.init()
        //self.viewControllers.append(loopController)
    }

    // Adding first header controller view to the loopController
    func setViewForLoopController(){
//        let lastView = viewControllers[0].view.snapshotViewAfterScreenUpdates(true)
//        lastView.translatesAutoresizingMaskIntoConstraints = false
//        loopController.view.addSubview(lastView)
//        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[lastView]-0-|",
//                                                                                   options: [],
//                                                                                   metrics: nil,
//                                                                                   views: ["lastView": lastView])
//        loopController.view.addConstraints(horizontalConstraints)
//
//        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[lastView]-0-|",
//                                                                                 options: [],
//                                                                                 metrics: nil,
//                                                                                 views: ["lastView": lastView])
//        loopController.view.addConstraints(verticalConstraints)
    }

    /**
     * Update view as per the current layout
     */
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing =  0//topSpacing
        segmentedScrollView.bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentScrollViewTopConstraint?.constant = 0//topSpacing
        segmentedScrollView.updateSubviewsFrame(self.view.bounds)
        setViewForLoopController()
    }


    func animateToNextPage(){

        var timerFireTime = autoScrollTime
        currentIndex += 1

        if currentIndex == viewControllers.count{
            //End of page
            currentIndex = 0
            timerFireTime = 0
        }
        pageControl.currentPage = currentIndex
      //  segmentedScrollView.contentView?.movePageToIndex(currentIndex, animated: currentIndex == 0 ? false: true)
        pageControl.currentPage = currentIndex
        // in infinte loop mode controllers count will be one ahead than actual count
        if currentIndex == actualNumberOfPages{
            pageControl.currentPage = 0
        }
        resetTimer(timerFireTime)
    }

    func resetTimer(fireTime:NSTimeInterval){
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(fireTime, target: self, selector: #selector(animateToNextPage), userInfo: nil, repeats: true)
    }
    override public func observeValueForKeyPath(keyPath: String?,
                                                ofObject object: AnyObject?,
                                                         change: [String : AnyObject]?,
                                                         context: UnsafeMutablePointer<Void>) {

        //update selected segment view x position
        //        let scrollView = object as? UIScrollView
        //        var changeOffset = (scrollView?.contentSize.width)! / self.contentSize.width
        //        let value = (scrollView?.contentOffset.x)! / changeOffset
        //
        //        if !value.isNaN {
        //            selectedSegmentView?.frame.origin.x = (scrollView?.contentOffset.x)! / changeOffset
        //        }
        //
        //        //update segment offset x position
        //        let segmentScrollWidth = self.contentSize.width - self.bounds.width
        //        let contentScrollWidth = scrollView!.contentSize.width - scrollView!.bounds.width
        //        changeOffset = segmentScrollWidth / contentScrollWidth
        //        self.contentOffset.x = (scrollView?.contentOffset.x)! * changeOffset
    }


    /**
     * Private method for adding the segmented scroll view.
     */
    func addSegmentedScrollView() {

        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing

        let bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentedScrollView.bottomSpacing = bottomSpacing

        self.view.addSubview(segmentedScrollView)

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(verticalConstraints)

        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .Top,
                                                            relatedBy: .Equal,
                                                            toItem: self.view,
                                                            attribute: .Top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        self.view.addConstraint(segmentScrollViewTopConstraint!)

        segmentedScrollView.setContentView()
    }

    func addPageControl(numberOfPages:Int, startingPage:Int){
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        segmentedScrollView.addSubview(pageControl)
        segmentedScrollView.bringSubviewToFront(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pageControl]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["pageControl": pageControl])
        segmentedScrollView.addConstraints(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl]-10-|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["pageControl": pageControl])
        segmentedScrollView.addConstraints(verticalConstraints)
    }


    /**
     Method for adding the array of content ViewControllers into the container

     - parameter contentControllers: array of ViewControllers
     */
    func addContentControllers(contentControllers: [UIViewController]) {


        segmentedScrollView.addSegmentView(contentControllers, frame: self.view.bounds)


        var index = 0
        for controller in contentControllers {

            self.addChildViewController(controller)
             segmentedScrollView.addContentView(controller.view, frame: self.view.bounds)
            controller.view.clipsToBounds = true
            controller.didMoveToParentViewController(self)

            //            let delegate = controller as? SJSegmentedViewControllerViewSource
            //            var observeView = controller.view
            //
            //            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange!(controller,
            //                                                                                          index: index) {
            //                observeView = view
            //            }
            //
            //            segmentedScrollView.addObserverFor(view: observeView)
            index += 1
        }

        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
        //TODO: page swipe change block, this will be called when user swipes
        segmentedScrollView.segmentView?.contentView?.didSelectPageAtIndex = { index in
            self.currentIndex = index
            if index == self.actualNumberOfPages{
                // end of page
                self.currentIndex = 0
                self.segmentedScrollView.contentView?.movePageToIndex(self.currentIndex, animated: false)

            }
            self.segmentedScrollView.segmentView?.contentView?.shouldObserveContentView = false
            self.pageControl.currentPage = self.currentIndex
          //  self.resetTimer(self.autoScrollTime)
        }
    }

    /**
     * Method for loading content ViewControllers and header ViewController
     */
    func loadControllers() {

        addContentControllers(viewControllers)
        // Page Controller
        //TODO:
        //        segmentedScrollView.contentView?.addSubview(<#T##view: UIView##UIView#>)
    }

}
