import XCTest

class RMQExchangeTest: XCTestCase {

    func testPublishCallsPublishOnChannel() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(channel: ch)
        ex.publish("foo", routingKey: "my.q")

        XCTAssertEqual("foo", ch.lastReceivedBasicPublishMessage)
        XCTAssertEqual("my.q", ch.lastReceivedBasicPublishRoutingKey)
        XCTAssertEqual("", ch.lastReceivedBasicPublishExchange)
    }

    func testPublishWithPersistence() {
        let ch = ChannelSpy(1)
        let ex = RMQExchange(channel: ch)
        ex.publish("foo", routingKey: "my.q", persistent: true)

        XCTAssertEqual("foo", ch.lastReceivedBasicPublishMessage)
        XCTAssertEqual("my.q", ch.lastReceivedBasicPublishRoutingKey)
        XCTAssertEqual("", ch.lastReceivedBasicPublishExchange)
        XCTAssertEqual(true, ch.lastReceivedBasicPublishPersistent)
    }

}