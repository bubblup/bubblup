//
//  PageViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/20/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    var pageViewController : UIPageViewController?
    var index:Int!
    var ideas: [PFObject]!

    weak var controller:BubbleCollectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let firstViewController = getViewControllerAtIndex(index)
        
        
        self.pageViewController!.setViewControllers([firstViewController],
            direction: .Forward,
            animated: true,
            completion: nil)
        
      //  let startingViewController: PageContentViewController = self.viewControllerAtIndex(0)!
      //  let viewControllers: NSArray = [startingViewController]
      //  self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    func getViewControllerAtIndex(index: Int) -> OneBubbleViewController {
     //   if((ideas.count == 0) || (index >= ideas.count)) {
      //      return nil
       // }
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("BubbleController") as! OneBubbleViewController
        controller.controller = self.controller
        controller.idea = ideas[index]
        controller.pageIndex = index
        print("controller \(self.controller)")
        
        controller.delegate = self.controller
        return controller
        
    }
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            var previousIndex = (viewController as! OneBubbleViewController).pageIndex!
            
            if(previousIndex == 0){
                return nil
            }
            previousIndex -= 1
            return getViewControllerAtIndex(previousIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            var currentIndex = (viewController as! OneBubbleViewController).pageIndex!
           // print("view controller after view\(currentIndex)")
            
            currentIndex++
            if(currentIndex >= ideas.count){
                
                return nil
            }
            
            return getViewControllerAtIndex(currentIndex)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return ideas.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return index
    }

}
