// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

/*
 *     ,_,
 *    (',')
 *    {/"\}
 *    -"-"-
 */

interface IERC721x {
	/**
	 * @dev Thrown when array parameter lengths do not match.
	 */
	error ArrayLengthMismatch();

	/**
	 * @dev Thrown when a token locked by an approved contract is freed.
	 */
	error ApprovedContract();

	/**
	 * @dev Thrown when unapproved contract tries to lock/unlock tokens.
	 */
	error NotApprovedContract();

	/**
	 * @dev Thrown if a locked token is transferred.
	 */
	error Locked(uint256 tokenId);

	/**
	 * @dev Thrown when caller tries to lock a tokenId they've already locked.
	 */
	error AlreadyLocked();

	/**
	 * @dev Thrown when caller tries to unlock a tokenId they haven't locked.
	 */
	error NotLocked();

	/**
	 * @dev Returns if the token is locked (non-transferrable) or not.
	 */
	function isUnlocked(uint256 tokenId) external view returns(bool status);

	/**
	 * @dev Returns the amount of locks on the token.
	 */
	function lockCount(uint256 tokenId) external view returns(uint256 count);

	/**
	 * @dev Returns if a contract is allowed to lock/unlock tokens.
	 */
	function approvedContract(address lockingContract) external view returns(bool status);

	/**
	 * @dev Returns the contract that locked a token at a specific index in the mapping.
	 */
	function lockMap(uint256 tokenId, uint256 lockIndex) external view returns(address lockingContract);

	/**
	 * @dev Returns the mapping index of a contract that locked a token.
	 */
	function lockMapIndex(uint256 tokenId, address lockingContract) external view returns(uint256 lockIndex);

	/**
	 * @dev Locks a token, preventing it from being transferrable
	 */
	function lockId(uint256 tokenId) external;

	/**
	 * @dev Unlocks a token.
	 */
	function unlockId(uint256 tokenId) external;

	/**
	 * @dev Unlocks a token from a given contract if the contract is no longer approved.
	 */
	function freeId(uint256 tokenId, address lockingContract) external;
}