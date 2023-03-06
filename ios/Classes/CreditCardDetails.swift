public struct CardDetails: Hashable, Identifiable {
    public var number: String?
    public var name: String?
    public var expiryDate: String?
    public var cvcNumber: String?
    
    public init(numberWithDelimiters: String? = nil, name: String? = nil, expiryDate: String? = nil, cvcNumber: String? = nil) {
        self.number = numberWithDelimiters
        self.name = name
        self.expiryDate = expiryDate
        self.cvcNumber = cvcNumber
    }
    
    public var id: Int { hashValue }
}
