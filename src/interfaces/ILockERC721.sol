// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

/*
 *     ,_,
 *    (',')
 *    {/"\}
 *    -"-"-
 */

import {IERC721} from "../../lib/openzeppelin-contracts/contracts/interfaces/IERC721.sol";

interface ILockERC721 is IERC721 {
	function lockId(uint256 tokenId) external;
	function unlockId(uint256 tokenId) external;
	function freeId(uint256 tokenId, address lockingContract) external;
}