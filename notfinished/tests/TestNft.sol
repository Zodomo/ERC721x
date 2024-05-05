// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ERC721x} from "../erc721/ERC721x.sol";

abstract contract TestNFT is ERC721x {
	function mint(uint256 _id) external {
		_mint(msg.sender, _id);
	}
}