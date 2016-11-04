import Foundation

protocol ChatDelegate{
    func newBuddyOnline(_ buddyName:String)
    func buddyWentOffline(_ buddyName:String)
    func didDisconnect()
}
