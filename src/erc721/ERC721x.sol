// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

/*
 *     ,_,
 *    (',')
 *    {/"\}
 *    -"-"-
 */

import {ERC721} from "../../lib/solady/src/tokens/ERC721.sol";
import {LockRegistry, Ownable} from "../LockRegistry.sol";
import {IERC721x} from "../interfaces/IERC721x.sol";

abstract contract ERC721x is ERC721, LockRegistry {
	/*
	 *     bytes4(keccak256('freeId(uint256,address)')) == 0x94d216d6
	 *     bytes4(keccak256('isUnlocked(uint256)')) == 0x72abc8b7
	 *     bytes4(keccak256('lockCount(uint256)')) == 0x650b00f6
	 *     bytes4(keccak256('lockId(uint256)')) == 0x2799cde0
	 *     bytes4(keccak256('lockMap(uint256,uint256)')) == 0x2cba8123
	 *     bytes4(keccak256('lockMapIndex(uint256,address)')) == 0x09308e5d
	 *     bytes4(keccak256('unlockId(uint256)')) == 0x40a9c8df
	 *     bytes4(keccak256('approvedContract(address)')) == 0xb1a6505f
	 *
	 *     => 0x94d216d6 ^ 0x72abc8b7 ^ 0x650b00f6 ^ 0x2799cde0 ^
	 *        0x2cba8123 ^ 0x09308e5d ^ 0x40a9c8df ^ 0xb1a6505f == 0x706e8489
	 */

	bytes4 private constant _INTERFACEtokenId_ERC721x = 0x706e8489;

	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
		return interfaceId == _INTERFACEtokenId_ERC721x
			|| super.supportsInterface(interfaceId);
	}

	function transferFrom(address from, address to, uint256 tokenId) public payable override virtual {
		if (!isUnlocked(tokenId)) revert IERC721x.Locked(tokenId);
		ERC721.transferFrom(from, to, tokenId);
	}

	function safeTransferFrom(address from, address to, uint256 tokenId) public payable override virtual {
		if (!isUnlocked(tokenId)) revert IERC721x.Locked(tokenId);
		ERC721.safeTransferFrom(from, to, tokenId);
	}

	function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public payable override virtual {
		if (!isUnlocked(tokenId)) revert IERC721x.Locked(tokenId);
		ERC721.safeTransferFrom(from, to, tokenId, data);
	}

	function lockId(uint256 tokenId) public override virtual {
		if (!_exists(tokenId)) revert TokenDoesNotExist();
		_lockId(tokenId);
	}

	function unlockId(uint256 tokenId) public override virtual {
		if (!_exists(tokenId)) revert TokenDoesNotExist();
		_unlockId(tokenId);
	}

	function freeId(uint256 tokenId, address lockingContract) public override virtual {
		if (!_exists(tokenId)) revert TokenDoesNotExist();
		_freeId(tokenId, lockingContract);
	}
}