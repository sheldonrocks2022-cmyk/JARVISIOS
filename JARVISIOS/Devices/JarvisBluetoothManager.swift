import CoreBluetooth
final class JarvisBluetoothManager:NSObject,ObservableObject,CBCentralManagerDelegate{
 @Published var state="Unknown";private var central:CBCentralManager!
 override init(){super.init();central=CBCentralManager(delegate:self,queue:nil)}
 func centralManagerDidUpdateState(_ c:CBCentralManager){state=String(describing:c.state)}
}
