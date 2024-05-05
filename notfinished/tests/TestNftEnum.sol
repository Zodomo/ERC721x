// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ERC721xEnum} from "../enumerable/ERC721xEnum.sol";

contract TestNFTEnum is ERC721xEnum("", "") {
	function mint(uint256 _id) external {
		_mint(msg.sender, _id);
	}
}