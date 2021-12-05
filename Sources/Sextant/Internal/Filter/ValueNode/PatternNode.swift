import Foundation
import Hitch

fileprivate let typeHitch = Hitch("pattern")

class PatternNode: ValueNode {
    let hitch: Hitch
    let pattern: Hitch
    let flags: Hitch
    
    let regex: NSRegularExpression
    
    init?(regex: Hitch) {
        let begin = regex.firstIndex(of: UInt8.forwardSlash) ?? 0
        let end = regex.lastIndex(of: UInt8.forwardSlash) ?? 0
        
        self.hitch = regex
        self.pattern = regex.substring(begin + 1, end - begin) ?? Hitch()
        self.flags = regex.substring(end + 1, regex.count) ?? Hitch()
        
        let localError = error
        do {
            self.regex = try NSRegularExpression(pattern: self.pattern.description,
                                                 options: PatternFlags(flags))
        } catch {
            localError("\(error)")
            return nil
        }
    }
    
    override var description: String {
        return hitch.description
    }
        
    override var typeName: Hitch {
        return typeHitch
    }
    
    override func evaluate(context: PredicateContext) -> ValueNode? {
        fatalError("TO BE IMPLEMENTED")
    }
}


/*
#pragma mark SMJPatternNode

@implementation SMJPatternNode
{
	NSString *_string;
	NSString *_pattern;
	NSString *_flags;
	
	BOOL				_done;
	NSRegularExpression	*_compiledPattern;
	NSError				*_error;
}
 
- (nullable NSRegularExpression *)underlayingObjectWithError:(NSError **)error
{
	if (!_done)
	{
		NSError *lerror = nil;
		
		_compiledPattern = [NSRegularExpression regularExpressionWithPattern:_pattern options:[SMJPatternFlags parseFlags:_flags] error:&lerror];
		_error = lerror;
		_done = YES;
	}

	if (error)
		*error = _error;
	
	return _compiledPattern;
}

- (nullable id)comparableUnderlayingObjectWithError:(NSError **)error
{
	return _string;
}
*/
