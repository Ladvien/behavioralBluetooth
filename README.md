# behavioralBluetooth
![](http://ladvien.github.io/images/bluetoothBehaveSmall.png)

Behaviorally based redefinition of CoreBluetooth.

CoreBluetooth is amazing! It's good times, for real.  Sadly, it is lacks a few features I find very useful when dealing with lesser devices such as the HM-10.  For example, a search which is based on a timer.  Of course, it's fairly easy to implement these features, but I got tired of rewriting the same helpers over-and-over.

I am pushing the design of the module to be behavior based.  I'm not sure this is the correct term, but it does describe what I am trying to accomplish.  Often, I want to switch how the iOS BLE device acts, these "behaviors" are really all I care about.  Well, that and actually getting data from the iOS to a nearby microcontroller.  Anyway, I decided to try and focus on getting these desired behaviors out the iOS device, rather than conforming to sound OO code.

## It's an expirement!

## Getting Started
The full code to get connected to a remote device would be,

```swift
import UIKit

class ViewController: UIViewController, LocalBehavioralSerialDeviceDelegate {
  var myLocal = LocalBluetoothLECentral()
  var myRemote = RemoteBluetoothLEPeripheral()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Attach the delegate to ViewController.
    myLocal.delegate = self

    // Tells the iOS BLE to attempt to retry connecting 3 times, with 1.5
    // seconds inbetween attempts.
    myLocalBLE.reconnectOnDisconnect(tries: 3, timeBetweenTries: 1.5)
    // Instructs the iOS BLE to gather advertizing data on search
    myLocalBLE.discoverAdvertizingDataOnSearch = false
    // Tells the iOS BLE to search for peripherals for two seconds.
    myLocalBLE.search(2)
  }
  
  func searchTimerExpired() {
    // Look up a discovered remote device by its advertized name.
    if let foundRemote = myLocal.getDiscoveredRemoteDeviceByName("HMSoft"){
        myRemote = foundRemote
        // Connect to the device, returning true if successful.
        let didConnect = myLocal.connectToDevice(myRemote)
    }
  }
}
```

## Functions and Behaviors

### Write to Device

```swift


@IBAction func sendButton(sender: AnyObject) {
	// Make sure we are connected to something.
	if(myLocal.getConnectionState() == DeviceState.connectionStates.connected){
    		// Get the device ID.
    		if let deviceID = myLocal.getConnectedDeviceIdByName("ALABTU"){
        		// Write a string to the device
        		myLocal.writeToDevice(deviceID, string: "DOUGHNUTS!\n\r")
    		} else {
        		print("Device was not in connected device list.")
    		}
	} else {
    		print("Oh my! Your iOS device isn't connected to anything.")
	}
}

```

### List of Devices sorted by RSSI

```swift
let sortedDeviceArrayByRSSI = myLocal.getAscendingSortedArraysBasedOnRSSI()

for(var i = 0; i < sortedDeviceArrayByRSSI.nsuuids.count; i++){
    if let name = myLocal.getDeviceName(sortedDeviceArrayByRSSI.nsuuids[i]){
        print(name)
    }
    print("NSUUID: " + String(sortedDeviceArrayByRSSI.nsuuids[i].UUIDString) 
    + "\n\tRSSI: " + String(sortedDeviceArrayByRSSI.rssies[i]))
}

```

Console output,
```
Apple TV
NSUUID: C35327C8-DAEE-0959-C047-F0D9B02ED90C
	RSSI: -85
Apple TV
NSUUID: A311FF27-FD16-8F62-971E-FEB023B0EA96
	RSSI: -87
Unknown_0
NSUUID: 12FE30E7-9DA0-A791-B9E4-F618CB4482C9
	RSSI: -95
```

### Debug Output

``` swift 
myLocal.verboseOutput(true)
```

Console output,
```
Started search with 2.0 sec timeout
Searching for BLE Devices
didDiscoverPeripheral A311FF27-FD16-8F62-971E-FEB023B0EA96
didDiscoverPeripheral 8BF37705-5698-8306-F8CF-5203D6DB16C9
didDiscoverPeripheral C35327C8-DAEE-0959-C047-F0D9B02ED90C
didDiscoverPeripheral 12FE30E7-9DA0-A791-B9E4-F618CB4482C9
Attempting to connect to: HMSoft
setConnectedDevice
didConnectToPeripheral: 8BF37705-5698-8306-F8CF-5203D6DB16C9
didDiscoverServices: FFE0
```

### Local Device State Change
This will start the search when the iOS BLE device is powered on and ready.  This allows the app to start scanning on load.  It is often tempting to put the Search method in the ViewDidLoad method, however, if the iOS BLE device had not yet powered on the scan will not discover peripherals resulting in the search always failing.

```swift
func localDeviceStateChange() {
    if(myLocal.deviceState == DeviceState.idle){
        myLocal.search(8)
    }
}
```

### Repeating Search
Often, there is a need for the iOS BLE scan to continue until a particular device is found.  The search property `myLocal.searchRepeats(numberOfRepeats)` will cause the search to continue a number of times before the search is stopped.  The `myLocal.searchRepeats(numberOfRepeats)` will changing this repeating behavior.  If set to an integer above zero the search will repeat until the number is reached.  If set to 0, the search will repeat until the `stopSearchTimer()` is called.  If searchRepeats is passed a nil, it will not repeat the search.

Note, a continuous search will make Apple very upset.  They treasure the user's battery life.  If the search is left to be repeating the code-consumer is responsible for calling stopSearchTimer to stop the iOS device from scanning.  This may be done from the `searchTimerExpired` method by calling `myLocal.stopSearchTimer()`.  When called this way the stopSearchTimer method updates the device state, invalidates the timer, stops the scan, and call the searchTimerExpired delegate for a final update on discovered devices.

```swift
var myLocal = bluetootBehaveLocal()

override func viewDidLoad() {
        super.viewDidLoad()
        
        // Starts a single search.
        myLoca.searchRepeats(nil)
        myLocal.search(1.0)
        
        // Starts a never ending search.
        myLoca.searchRepeats(0)
        myLocal.search(1.0)
        
        // Starts a repeating search; will repeat 5 times, including initial
        myLocal.searchRepeats(5)
        myLocal.verboseOutput(true)
}

```

[Documentation](http://ladvien.github.io/jazzy/behavioralBluetooth/index.html)

[Waka Report](https://wakatime.com/@ladvien/projects/ysdncpuqyt?start=2016-01-25&end=2016-01-31)

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.
