import Foundation
import Hitch

class ArrayIndexToken: ArrayPathToken {
    let indexOperation: ArrayIndexOperation
    
    init(_ indexOperation: ArrayIndexOperation) {
        self.indexOperation = indexOperation
    }
    
    override func evaluate(currentPath: Hitch,
                           parentPath: Path,
                           jsonObject: JsonAny,
                           evaluationContext: EvaluationContext) -> EvaluationStatus {
        let checkResult = checkArray(currentPath: currentPath,
                                     jsonObject: jsonObject,
                                     evaluationContext: evaluationContext)
        switch checkResult {
        case .skip:
            return .done
        case .error(let message):
            return .error(message)
        case .handle:
            for index in indexOperation.indices {
                let result = handle(arrayIndex: index,
                                    currentPath: currentPath,
                                    jsonObject: jsonObject,
                                    evaluationContext: evaluationContext)
                
                switch result {
                case .error, .aborted:
                    return result
                default:
                    break
                }
            }
        }
        
        return .done
    }
    
    override func isTokenDefinite() -> Bool {
        return indexOperation.isSingleIndexOperation()
    }
}

/*

- (NSString *)pathFragment
{
	return [_indexOperation stringValue];
}

@end


NS_ASSUME_NONNULL_END
*/
