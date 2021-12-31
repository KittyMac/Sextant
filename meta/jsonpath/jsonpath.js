const {JSONPath} = require('jsonpath-plus');
const jp = require('jsonpath');

const fs = require('fs');

window = {}

function print(s) {
    console.log(s)
}

function runJsonPathTest(title, json, path, result) {
    
    var totalTime = 0;
    for(i = 0; i < 3; i++) {
        var start = process.hrtime();
        let results = jp.query(json, path);
        let queryCount = results.length;
        if (queryCount == 0) {
            print(jp.parse(path));
        }
        var stop = process.hrtime(start);
        var thisTime = (stop[0] * 1e9 + stop[1])/1e9;
        
        if (queryCount != result) {
            print(`${title} - Failed - ${queryCount} != ${result}`)
        } else {
            console.log(`  ${title}: ${thisTime} seconds`);
        }
        
        totalTime += thisTime;
        
    }
    totalTime /= 3
    
    console.log(`${title}: ${totalTime} seconds`);
}

function runJsonPathPlusTest(title, json, path, result) {
    
    var totalTime = 0;
    for(i = 0; i < 3; i++) {
        var start = process.hrtime();
        let queryCount = JSONPath({path: path, json}).length;
        var stop = process.hrtime(start);
        var thisTime = (stop[0] * 1e9 + stop[1])/1e9;
        
        if (queryCount != result) {
            print(`${title} - Failed - ${queryCount} != ${result}`)
        } else {
            console.log(`  ${title}: ${thisTime} seconds`);
        }
        
        totalTime += thisTime;
        
    }
    totalTime /= 3
    
    console.log(`${title}: ${totalTime} seconds`);
}

try {
    const data = fs.readFileSync('/Volumes/Storage/large.json', 'utf8');
    let json = JSON.parse(data);
    
    print(json.length)
    
    print("jsonpath")
    runJsonPathTest("Test 1", json, "$[*]", 11351)
    runJsonPathTest("Test 2", json, "$..type", 17906)
    runJsonPathTest("Test 3", json, `$[?(@.payload.ref==='master')].payload`, 388)
    runJsonPathTest("Test 4", json, `$..[?(@.repo.name.match(/-/i))].repo`, 4209)
    
    print("\njsonpath-plus")
    runJsonPathPlusTest("Test 1", json, "$[*]", 11351)
    runJsonPathPlusTest("Test 2", json, "$..type", 17906)
    runJsonPathPlusTest("Test 3", json, `$[?(@.payload.ref==='master')].payload`, 388)
    runJsonPathPlusTest("Test 4", json, `$..[?(@property === 'repo' && @.name.match(/-/i))]`, 4209)
    
    
} catch (err) {
    console.error(err)
}

