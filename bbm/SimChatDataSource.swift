
import Foundation

/*
数据提供协议
*/
protocol SimChatDataSource
{
    
    /*返回对话记录中的全部行数*/
    func rowsForChatTable( _ tableView:SimTableView) -> Int
    /*返回某一行的内容*/
    func chatTableView(_ tableView:SimTableView, dataForRow:Int)-> SimMessageItem
    
}
