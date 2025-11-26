// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./MPCQTokenService.sol";
import { IMPCQTokenService } from "./IMPCQTokenService.sol";

contract TokenSend is MPCQTokenService {
    address public tokenId;
    address payable public recipient;
    int64 internal storedAmount;

    constructor() {
        recipient = payable(msg.sender);
    }

    function loadFunds(int64 _amount) public payable{
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = createTransferList(_amount);
        cryptoTransfer(tokenTransferList);
    }

    function createTransferList(int64 _amount) private view
    returns (IMPCQTokenService.TokenTransferList[] memory)
    {
        IMPCQTokenService.TokenTransferList[] memory tokenTransferListCollection = new IMPCQTokenService.TokenTransferList[](1);
        IMPCQTokenService.NftTransfer[] memory nftTransferList = new IMPCQTokenService.NftTransfer[](0);
        IMPCQTokenService.AccountAmount[] memory amountAccountList = new IMPCQTokenService.AccountAmount[](1);
        amountAccountList[0] = IMPCQTokenService.AccountAmount(recipient,  _amount != 0 ? _amount : storedAmount);
        tokenTransferListCollection[0] = IMPCQTokenService.TokenTransferList(tokenId, amountAccountList, nftTransferList);

        return tokenTransferListCollection;
    }

    function storeAmount(int64 number) public {
        storedAmount = number;
    }

    function getAmount() public view 
    returns (int64) 
    {
        return storedAmount;
    }
}
