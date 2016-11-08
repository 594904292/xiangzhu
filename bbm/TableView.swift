

import UIKit
enum ChatBubbleTypingType
{
    case nobody
    case me
    case somebody
}
class TableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    
    var bubbleSection:NSMutableArray!
    var chatDataSource:ChatDataSource!
    
    var  snapInterval:TimeInterval!
    var  typingBubble:ChatBubbleTypingType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect)
    {
        //the snap interval in seconds implements a headerview to seperate chats
        self.snapInterval = 60 * 60 * 24 as TimeInterval; //one day
        self.typingBubble = ChatBubbleTypingType.nobody
        self.bubbleSection = NSMutableArray()
        
        super.init(frame:frame,  style:UITableViewStyle.grouped)
        
        self.backgroundColor = UIColor.clear
        
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.delegate = self
        self.dataSource = self
        
        
    }
    //按日期排序方法
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> ComparisonResult {
        if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970)
        {
            return ComparisonResult.orderedAscending
        }
        else
        {
            return ComparisonResult.orderedDescending
        }
    }
    
    override func reloadData()
    {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        var count =  0
        if ((self.chatDataSource != nil))
        {
            count = self.chatDataSource.rowsForChatTable(self)
            
            if(count > 0)
            {
                
                let bubbleData =  NSMutableArray(capacity:count)
                
                for i:Int in 0 ..< count
                    
                {
                    
                    let object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    
                    bubbleData.add(object)
                    
                }
                //var arrays:NSMutableArray=NSMutableArray()
                //bubbleData.sort(
                 //   comparator: {
                 //       (m1:AnyObject!,m2:AnyObject!)->ComparisonResult in
                  //      if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970)
                 //       {
                 //           return ComparisonResult.orderedAscending
                  //      }
                 //       else
                  //      {
                   //         return ComparisonResult.orderedDescending
                 //       }
               // } as! (Any, Any) -> ComparisonResult)

                
                 //bubbleData.sort(comparator: sortDate as! (Any, Any) -> ComparisonResult)
                
                var last =  ""
                
                var currentSection = NSMutableArray()
                // 创建一个日期格式器
                let dformatter = DateFormatter()
                // 为日期格式器设置格式字符串
                dformatter.dateFormat = "dd"
                
                
                for i:Int in 0 ..< count
                {
                    let data =  bubbleData[i] as! MessageItem
                    // 使用日期格式器格式化日期，日期不同，就新分组
                    let datestr = dformatter.string(from: data.date)
                    if (datestr != last)
                    {
                        currentSection = NSMutableArray()
                        self.bubbleSection.add(currentSection)
                    }
                    (self.bubbleSection[self.bubbleSection.count-1] as AnyObject).add(data)
                    
                    last = datestr
                }
            }
        }
        super.reloadData()
        
        //滑向最后一部分
//        var secno = self.bubbleSection.count - 1
//        if(secno>0)
//        {
//            var indexPath =  NSIndexPath(forRow:self.bubbleSection[secno].count,inSection:secno)
//            self.scrollToRowAtIndexPath(indexPath,                atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
//        }
    }
    func numberOfSections(in tableView:UITableView)->Int
    {
        var result = self.bubbleSection.count
        if (self.typingBubble != ChatBubbleTypingType.nobody)
        {
            result += 1;
        }
        return result;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return (self.bubbleSection[section] as AnyObject).count+1
    }
    
    
    func tableView(_ tableView:UITableView,heightForRowAt  indexPath:IndexPath) -> CGFloat
    {
        
        // Header
        if (indexPath.row == 0)
        {
            return TableHeaderViewCell.getHeight()
        }
        let section : NSArray  =  self.bubbleSection[indexPath.section] as! NSArray
        let pos:Int=indexPath.row - 1
        let data:AnyObject = section[pos] as AnyObject
        
        let item =  data as! MessageItem
        let height  = max(item.insets.top + item.view.frame.size.height + item.insets.bottom, 52)
        print("height:\(height)")
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Header based on snapInterval
        if (indexPath.row == 0)
        {
            let cellId = "HeaderCell"
            
            let hcell =  TableHeaderViewCell(reuseIdentifier:cellId)
            _ = indexPath.section
            let section : NSArray  =  self.bubbleSection[indexPath.section] as! NSArray
            let pos:Int=indexPath.row
            let data:AnyObject = section[pos] as AnyObject
            
            let item =  data as! MessageItem
            
            //var msgdata:MessageItem = section[indexPath.row] as! MessageItem
            
            hcell.setDate(item.date)
            return hcell
        }
        // Standard
        let cellId = "ChatCell"
        
        let section : NSArray  =  self.bubbleSection[indexPath.section] as! NSArray
        
        let pos:Int=indexPath.row - 1
        let data:AnyObject = section[pos] as AnyObject

       
        
        let cell =  TableViewCell(data:data as! MessageItem, reuseIdentifier:cellId)
        return cell
    }
}
