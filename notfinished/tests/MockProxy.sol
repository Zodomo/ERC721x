pragma solidity ^0.8.23;

import {TransparentUpgradeableProxy} from "../../lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";


contract MockProxy is TransparentUpgradeableProxy {
	constructor(address _logic, address _admin, bytes memory _data) public  TransparentUpgradeableProxy(_logic, _admin, _data) {}
}