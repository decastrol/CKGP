//
//  Request.swift
//  CKGP
//
//  Created by Luke de Castro on 5/8/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

var races = [raceObject]()
class Request {
    static func getToken(completion: (token: Token)-> Void) {
        let objResponseMap = RKObjectMapping(forClass: Token.self)
        objResponseMap.addAttributeMappingsFromArray(["token"])
        let responseDescriptor = RKResponseDescriptor(mapping: objResponseMap, method: RKRequestMethod.Any, pathPattern: nil, keyPath: nil, statusCodes: nil)
        
        let objRequestMap = RKObjectMapping.requestMapping()
        objRequestMap.addAttributeMappingsFromDictionary(["username":"username", "password":"password"])
        let requestDescriptor = RKRequestDescriptor(mapping: objRequestMap , objectClass: TokenUser.self, rootKeyPath: nil, method: RKRequestMethod.Any)
        
        
        let objManager = RKObjectManager(baseURL: NSURL(string: "https://boiling-chamber-8329.herokuapp.com/"))
        objManager.addResponseDescriptor(responseDescriptor)
        objManager.addRequestDescriptor(requestDescriptor)
        
        let user = TokenUser()
        objManager.postObject(user, path: "api/auth/token/", parameters: nil, success: { (operation: RKObjectRequestOperation!, result: RKMappingResult!) in
            print(result.firstObject())
            
            token = result.firstObject() as! Token
            completion(token: token)
        }) { (errorOp: RKObjectRequestOperation!, error: NSError!) in
            print(error)
        }
    }
    
    static func getRaces(completion: (races : [raceObject]) -> Void) {
        
        Request.getToken { (token) in
            
        
        let objectResponseMap = RKObjectMapping(forClass: raceObject.self)
        let raceArr = ["raceid","date","distance","name"]
        objectResponseMap.addAttributeMappingsFromArray(raceArr)
        
        let baseUrl = NSURL(string: "https://boiling-chamber-8329.herokuapp.com/api/races/")
        let objectManager = RKObjectManager(baseURL: baseUrl)
        objectManager.HTTPClient.setAuthorizationHeaderWithToken("JWT \(token.token)")
        
        let responseDescriptor = RKResponseDescriptor(mapping: objectResponseMap, method: RKRequestMethod.Any, pathPattern: nil, keyPath: "", statusCodes: nil)
        objectManager.addResponseDescriptor(responseDescriptor)
        
        var request = NSURLRequest(URL: baseUrl!)
        let mutableRequest = request.mutableCopy()
        mutableRequest.addValue("JWT \(token.token)", forHTTPHeaderField: "Authorization")
        request = mutableRequest.copy() as! NSURLRequest
        
        let operation = RKObjectRequestOperation(request: request, responseDescriptors: [responseDescriptor])
        operation.setCompletionBlockWithSuccess({ (operation: RKObjectRequestOperation!, result: RKMappingResult!) in
            
            var racesFound = result.array() as! [raceObject]
            racesFound.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
            races = racesFound
            completion(races: races)
            for race in races {
                race.printMe()
            }
            
        }) { (operation: RKObjectRequestOperation!, error: NSError!) in
            print(error)
        }
        operation.start()
    }
    }
    
    static func getPeople(completion: ([checkedPersonObject]) -> Void, errorCompletion: (NSError) -> Void) {
        Request.getToken { (token) in
            
            
            let baseURL: NSURL = NSURL(string: "https://boiling-chamber-8329.herokuapp.com/api/")!
            let objectMapper: RKObjectManager = RKObjectManager(baseURL: baseURL)
            objectMapper.HTTPClient.setAuthorizationHeaderWithToken("JWT \(token.token)")
            print("Here is the token: \(token.token)")
            
            
            let objectMapping = RKObjectMapping(forClass: checkedPersonObject.self)
            let personDict = ["id":"personId", "checkin_race_id": "raceId", "checkin_bib": "bibNumber","email":"email", "firstname":"firstName", "lastname":"lastName", "checkin_date":"date" ]
            objectMapping.addAttributeMappingsFromDictionary(personDict)
            
            
            let responseDescriptor = RKResponseDescriptor(mapping: objectMapping, method: RKRequestMethod.Any, pathPattern: nil, keyPath: "", statusCodes: nil)
            objectMapper.addResponseDescriptor(responseDescriptor)
            
            
            
            var request = NSURLRequest(URL: NSURL(string: "https://boiling-chamber-8329.herokuapp.com/api/checkin/")!)
            let mutableRequest = request.mutableCopy()
            mutableRequest.addValue("JWT \(token.token)", forHTTPHeaderField: "Authorization")
            request = mutableRequest.copy() as! NSURLRequest
            
            print("doing the thing")
            let operation: RKObjectRequestOperation = RKObjectRequestOperation(request: request, responseDescriptors: [responseDescriptor])
            // Request.getToken()
            operation.setCompletionBlockWithSuccess({ (operation: RKObjectRequestOperation!, result: RKMappingResult!) -> Void in
                var peopleArr = result.array() as! [checkedPersonObject]
                peopleArr.sortInPlace({ $0.personId > $1.personId})
                
                completion(peopleArr)
                print("doing the other thing")
                
                
            }) { (operation : RKObjectRequestOperation!, error: NSError!) in
                let alert = UIAlertView(title: "Error", message: "Sorry, we couldn't fetch the runners right now", delegate: nil, cancelButtonTitle: "Ok")
                errorCompletion(error)
                alert.show()
            }
            operation.start()
        }

    }
}
