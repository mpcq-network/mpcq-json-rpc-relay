// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./hts/MPCQTokenService.sol";
import "./hts/IMPCQTokenService.sol";
import "./hts/KeyHelper.sol";

contract CreateHTS is Ownable, KeyHelper, MPCQTokenService {
    address public htsTokenAddress;

    constructor(string memory _name, string memory _symbol, address _delegate) payable Ownable(_delegate) {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](2);
        keys[0] = getSingleKey(
            KeyType.ADMIN,
            KeyValueType.INHERIT_ACCOUNT_KEY,
            bytes("")
        );
        keys[1] = getSingleKey(
            KeyType.SUPPLY,
            KeyValueType.INHERIT_ACCOUNT_KEY,
            bytes("")
        );

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(0, address(this), 8000000);
        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            _name, _symbol, address(this), "memo", true, 5000, false, keys, expiry
        );

        (int responseCode, address tokenAddress) = MPCQTokenService.createFungibleToken(
            token, 1000, int32(int256(uint256(8)))
        );
        require(responseCode == MPCQTokenService.SUCCESS_CODE, "Failed to create HTS token");

        int256 transferResponse = MPCQTokenService.transferToken(tokenAddress, address(this), msg.sender, 1000);
        require(transferResponse == MPCQTokenService.SUCCESS_CODE, "HTS: Transfer failed");

        htsTokenAddress = tokenAddress;
    }

    function updateTokenKeysPublic(IMPCQTokenService.TokenKey[] memory keys) public returns (int64 responseCode) {
        (responseCode) = MPCQTokenService.updateTokenKeys(htsTokenAddress, keys);

        require(responseCode == MPCQTokenService.SUCCESS_CODE, "HTS: Update keys reverted");
    }
}
