import Vapor

public class PasswordISO123: ValidationSuite {
    public static func validate(input value: String) throws {
        // TODO - do not validate hashed
        
        let evaluation = OnlyAlphanumeric.self
            && Count.min(8)
        
        // TOOD add has numeric
        /// TODO has one big letter
        
        try evaluation.validate(input: value)
    }
}
