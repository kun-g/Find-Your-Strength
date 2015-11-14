//
//  ReportViewController.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/14.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import UIKit

class ReportViewController: UITableViewController {
    var survey : Survey!
    lazy var report : [(Survey.Strength, Int)] = {
        let originReport = self.survey.report()
        guard originReport != nil else {
            return []
        }
        let sortedReport = originReport!.sort({
            let (_, lv) = $0, (_, rv) = $1
            return lv > rv
        })
        return sortedReport
    }()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)
        let (strength, score) = report[indexPath.item]
        cell.textLabel!.text = strength.rawValue
        cell.detailTextLabel?.text = String(score)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.count
    }
}