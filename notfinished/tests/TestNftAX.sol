// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ERC721Ax} from "../erc721A/ERC721Ax.sol";

contract TestNFTAX is ERC721Ax("", "") {
	function mint(uint256 _id) external {
		_mint(msg.sender, _id);
	}
}