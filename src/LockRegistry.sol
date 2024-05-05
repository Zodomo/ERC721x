// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

/*
 *     ,_,
 *    (',')
 *    {/"\}
 *    -"-"-
 */

import {Ownable} from "../lib/solady/src/auth/Ownable.sol";
import {IERC721x} from "./interfaces/IERC721x.sol";

abstract contract LockRegistry is Ownable, IERC721x {
	mapping(address lockingContract => bool status) public override approvedContract;
	mapping(uint256 tokenId => uint256 count) public override lockCount;
	mapping(uint256 tokenId => mapping(uint256 lockIndex => address lockingContract)) public override lockMap;
	mapping(uint256 tokenId => mapping(address lockingContract => uint256 lockIndex)) public override lockMapIndex;

	event TokenLocked(uint256 indexed tokenId, address indexed approvedContract);
	event TokenUnlocked(uint256 indexed tokenId, address indexed approvedContract);

	function isUnlocked(uint256 tokenId) public view override returns(bool status) {
		return lockCount[tokenId] == 0;
	}

	function updateApprovedContracts(address[] calldata contracts, bool[] calldata values) external onlyOwner {
		if (contracts.length != values.length) revert IERC721x.ArrayLengthMismatch();
		for (uint256 i = 0; i < contracts.length; ++i) {
			approvedContract[contracts[i]] = values[i];
		}
	}

	function _lockId(uint256 tokenId) internal {
		if (!approvedContract[msg.sender]) revert IERC721x.NotApprovedContract();
		if (lockMapIndex[tokenId][msg.sender] != 0) revert IERC721x.AlreadyLocked();

		unchecked {
			uint256 count = lockCount[tokenId] + 1;
			lockMap[tokenId][count] = msg.sender;
			lockMapIndex[tokenId][msg.sender] = count;
			lockCount[tokenId] = count;
		}
		
		emit TokenLocked(tokenId, msg.sender);
	}

	function _unlockId(uint256 tokenId) internal {
		if (!approvedContract[msg.sender]) revert IERC721x.NotApprovedContract();
		uint256 index = lockMapIndex[tokenId][msg.sender];
		if (index == 0) revert IERC721x.NotLocked();
		
		uint256 last = lockCount[tokenId];
		if (index != last) {
			address lastContract = lockMap[tokenId][last];
			lockMap[tokenId][index] = lastContract;
			lockMap[tokenId][last] = address(0);
			lockMapIndex[tokenId][lastContract] = index;
		} else {
			lockMap[tokenId][index] = address(0);
		}

		lockMapIndex[tokenId][msg.sender] = 0;
		unchecked {
			--lockCount[tokenId];
		}
		
		emit TokenUnlocked(tokenId, msg.sender);
	}

	function _freeId(uint256 tokenId, address lockingContract) internal {
		if (approvedContract[lockingContract]) revert IERC721x.ApprovedContract();
		uint256 index = lockMapIndex[tokenId][lockingContract];
		if (index == 0) revert IERC721x.NotLocked();

		uint256 last = lockCount[tokenId];
		if (index != last) {
			address lastContract = lockMap[tokenId][last];
			lockMap[tokenId][index] = lastContract;
			lockMap[tokenId][last] = address(0);
			lockMapIndex[tokenId][lastContract] = index;
		}
		else {
			lockMap[tokenId][index] = address(0);
		}

		lockMapIndex[tokenId][lockingContract] = 0;
		unchecked {
			--lockCount[tokenId];
		}
		emit TokenUnlocked(tokenId, lockingContract);
	}
}
