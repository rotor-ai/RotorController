

/*
Just a simple class for identifying individual Bluetooth Devices.
 */

class GenericBTDevice {

  String name     = "";
  String address  = "";
  String uuid     = "";

  GenericBTDevice(String name, String address, String uuid ) {
    this.name = name;
    this.address = address;
    this.uuid = uuid;
  }

}