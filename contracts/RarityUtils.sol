pragma solidity 0.8.2;

import "../interfaces/IRarity.sol";

contract RarityUtils {
    IRarity constant rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);

    function _isApprovedOrOwner(uint256 _summoner)
        internal
        view
        returns (bool)
    {
        return
            rm.getApproved(_summoner) == msg.sender ||
            rm.ownerOf(_summoner) == msg.sender;
    }
}
