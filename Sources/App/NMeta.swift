final class NMeta {
    
    static var instance: NMeta?
    
    static func setInstance(nMeta: String) {
        self.instance = NMeta(nMeta: nMeta)
    }
    
    static func getInstance() -> NMeta {
    
        guard let unwrappedInstance: NMeta = instance else {
            throw Abort.custom(status: .badRequest, message: "Missing N-Meta header")
        }
        
        return unwrappedInstance
        
    }
    
    
    init(nMeta: String) {
        print(nMeta)
    }
}
