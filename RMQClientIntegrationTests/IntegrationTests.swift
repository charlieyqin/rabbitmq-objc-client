import XCTest

class IntegrationTests: XCTestCase {
    
    func XtestIntegration() {
        let conn = RMQConnection()
        conn.start()
        
        let ch = conn.createChannel()
        let q = ch.queue("rmqclient.examples.hello_world", autoDelete: true, exclusive: false)
        let x = ch.defaultExchange()
        
        let expectation = self.expectationWithDescription("subscription data received")
        
        let expectedInfo = ["consumer_tag": "foo"]
        let expectedMeta = ["foo": "bar"]
        let expectedPayload = ["baz": "qux"]
        
        q.subscribe { (info, meta, p) -> Void in
            if NSDictionary(dictionary: info).isEqualToDictionary(expectedInfo) &&
                NSDictionary(dictionary: meta).isEqualToDictionary(expectedMeta) &&
                NSDictionary(dictionary: p).isEqualToDictionary(expectedPayload) {
                    expectation.fulfill()
            } else {
                XCTFail("subscribe response unexpected")
            }
            
        }
        
        x.publish("Hello!", routingKey: q.name)
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
    
}