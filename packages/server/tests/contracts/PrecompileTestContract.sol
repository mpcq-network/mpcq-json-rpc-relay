// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./MPCQTokenService.sol";
import "./MPCQResponseCodes.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";


contract PrecompileTestContract is MPCQTokenService {
    event ResponseCode(int256);

    function isTokenAddress(address token) external returns (bool) {
        (int256 response, bool tokenFlag) = MPCQTokenService.isToken(token);

        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isTokenAddress failed!");
        }
        return tokenFlag;
    }
    function handleResponseCode(int responseCode) internal pure {
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function isTokenFrozen(address token, address account) external returns (bool) {
        (int256 response, bool frozen) = MPCQTokenService.isFrozen(token, account);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isFrozen failed!");
        }
        return frozen;
    }

    function isKycGranted(address token, address account) external returns (bool){
        (int256 response, bool kycGranted) = MPCQTokenService.isKyc(token, account);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isKyc failed!");
        }
        return kycGranted;
    }

    function getTokenDefaultFreeze(address token) external returns (bool) {
        (int256 response, bool frozen) = MPCQTokenService.getTokenDefaultFreezeStatus(token);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("getTokenDefaultFreezeStatus failed!");
        }
        return frozen;
    }

    function getTokenDefaultKyc(address token) external returns (bool) {
        (int256 response, bool kyc) = MPCQTokenService.getTokenDefaultKycStatus(token);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("getTokenDefaultKycStatus failed!");
        }
        return kyc;
    }

    function getCustomFeesForToken(address token) external returns (
        IMPCQTokenService.FixedFee[] memory fixedFees,
        IMPCQTokenService.FractionalFee[] memory fractionalFees,
        IMPCQTokenService.RoyaltyFee[] memory royaltyFees
    )
    {
        int64 responseCode;
        (responseCode, fixedFees, fractionalFees, royaltyFees) = MPCQTokenService.getTokenCustomFees(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function getInformationForToken(address token) external returns (IMPCQTokenService.TokenInfo memory tokenInfo)
    {
        (int256 responseCode,IMPCQTokenService.TokenInfo memory retrievedTokenInfo) = MPCQTokenService.getTokenInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        tokenInfo = retrievedTokenInfo;
    }

    function getInformationForFungibleToken(address token) external returns (IMPCQTokenService.FungibleTokenInfo memory fungibleTokenInfo)
    {
        (int256 responseCode,IMPCQTokenService.FungibleTokenInfo memory retrievedTokenInfo) = MPCQTokenService.getFungibleTokenInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        fungibleTokenInfo = retrievedTokenInfo;
    }

    function getInformationForNonFungibleToken(address token, int64 serialNumber) external returns (
        IMPCQTokenService.NonFungibleTokenInfo memory nonFungibleTokenInfo
    )
    {
        (int256 responseCode,IMPCQTokenService.NonFungibleTokenInfo memory retrievedTokenInfo) = MPCQTokenService.getNonFungibleTokenInfo(token, serialNumber);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        nonFungibleTokenInfo = retrievedTokenInfo;
    }

    function getType(address token) external returns (int256) {
        (int256 statusCode, int256 tokenType) = MPCQTokenService.getTokenType(token);
        if (statusCode != MPCQResponseCodes.SUCCESS) {
            revert("Token type appraisal failed!");
        }
        return tokenType;
    }

    function getExpiryInfoForToken(address token) external returns (IMPCQTokenService.Expiry memory expiry)
    {
        (int256 responseCode,IMPCQTokenService.Expiry memory retrievedExpiry) = MPCQTokenService.getTokenExpiryInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        expiry = retrievedExpiry;
    }

    function getTokenKeyPublic(address token, uint256 keyType) public returns (IMPCQTokenService.KeyValue memory)
    {
        (int256 responseCode,IMPCQTokenService.KeyValue memory key) = MPCQTokenService.getTokenKey(token, keyType);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return key;
    }

    function balanceOfRedirect(address token, address account) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.balanceOf.selector, account));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function nameRedirect(address token) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20Metadata.name.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function symbolRedirect(address token) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20Metadata.symbol.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function nameNFTRedirect(address token) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721Metadata.name.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function symbolNFTRedirect(address token) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721Metadata.symbol.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function decimalsRedirect(address token) external
    returns(bytes memory result)
    {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20Metadata.decimals.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return responseResult;
    }

    function totalSupplyRedirect(address token) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.totalSupply.selector));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ("Token redirect failed");
        }
        return responseResult;
    }

    function allowanceRedirect(address token, address owner, address spender) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.allowance.selector, owner, spender));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function getApprovedRedirect(address token, uint256 tokenId) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721.getApproved.selector, tokenId));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function getOwnerOfRedirect(address token, uint256 serialNo) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721.ownerOf.selector, serialNo));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function tokenURIRedirect(address token, uint256 tokenId) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721Metadata.tokenURI.selector, tokenId));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function isApprovedForAllRedirect(address token, address owner, address operator) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721.isApprovedForAll.selector, owner, operator));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function transferRedirect(address token, address recipient, uint256 amount) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.transfer.selector, recipient, amount));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function transferFromRedirect(address token, address sender, address recipient, uint256 amount) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.transferFrom.selector, sender, recipient, amount));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function approveRedirect(address token, address spender, uint256 amount) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC20.approve.selector, spender, amount));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function transferFromNFTRedirect(address token, address from, address to, uint256 tokenId) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721.transferFrom.selector, from, to, tokenId));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function setApprovalForAllRedirect(address token, address operator, bool approved) external
    returns (bytes memory result) {
        (int responseCode, bytes memory responseResult) = this.redirectForToken(token, abi.encodeWithSelector(IERC721.setApprovalForAll.selector, operator, approved));
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        return responseResult;
    }

    function associateTokenExternal(address account, address token) external {
        int responseCode = MPCQTokenService.associateToken(account, token);
        handleResponseCode(responseCode);
        emit ResponseCode(responseCode);
    }

    function grantTokenKycExternal(address token, address account) external {
        int responseCode = MPCQTokenService.grantTokenKyc(token, account);
        handleResponseCode(responseCode);
    }
}
