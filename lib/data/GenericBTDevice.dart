

/*
This is just a simple class for identifying individual Bluetooth Devices.
It is intended to be used during the connection stage, as we are scanning multiple
devices and don't yet know which ones are vehicles and which are headphones/speakers etc.
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