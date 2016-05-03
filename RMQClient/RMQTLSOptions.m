#import "RMQTLSOptions.h"
#import "RMQTCPSocketTransport.h"
#import "RMQPKCS12CertificateConverter.h"

@interface RMQTLSOptions ()
@property (nonatomic, readwrite) BOOL useTLS;
@property (nonatomic, readwrite) NSString *peerName;
@property (nonatomic, readwrite) BOOL verifyPeer;
@property (nonatomic, readwrite) NSData *pkcs12data;
@property (nonatomic, readwrite) NSString *pkcs12password;
@end

@implementation RMQTLSOptions

+ (instancetype)noTLS {
    return [[RMQTLSOptions alloc] initWithUseTLS:NO peerName:@"" verifyPeer:NO pkcs12:nil pkcs12Password:@""];
}

- (instancetype)initWithPeerName:(NSString *)peerName
                      verifyPeer:(BOOL)verifyPeer
                          pkcs12:(NSData *)pkcs12data
                  pkcs12Password:(NSString *)password {
    return [self initWithUseTLS:YES
                       peerName:peerName
                     verifyPeer:verifyPeer
                         pkcs12:pkcs12data
                 pkcs12Password:password];
}

- (NSString *)authMechanism {
    return self.pkcs12data ? @"EXTERNAL" : @"PLAIN";
}

- (NSArray *)certificatesWithError:(NSError **)error {
    RMQPKCS12CertificateConverter *converter = [[RMQPKCS12CertificateConverter alloc] initWithData:self.pkcs12data
                                                                                          password:self.pkcs12password];
    return [converter certificatesWithError:error];
}

# pragma mark - Private

- (instancetype)initWithUseTLS:(BOOL)useTLS
                      peerName:(NSString *)peerName
                    verifyPeer:(BOOL)verifyPeer
                        pkcs12:(NSData *)pkcs12data
                pkcs12Password:(NSString *)password {
    self = [super init];
    if (self) {
        self.useTLS = useTLS;
        self.peerName = peerName;
        self.verifyPeer = verifyPeer;
        self.pkcs12data = pkcs12data;
        self.pkcs12password = password;
    }
    return self;
}

@end
