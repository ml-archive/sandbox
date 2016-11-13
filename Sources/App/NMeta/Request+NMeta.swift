import HTTP

extension Request {
    var nMeta: NMeta? {
        get { return storage["nmeta"] as? NMeta }
        set { storage["nmeta"] = newValue }
    }
}
