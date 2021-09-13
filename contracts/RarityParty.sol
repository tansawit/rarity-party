pragma solidity 0.8.2;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/utils/structs/EnumerableSet.sol";
import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/token/ERC721/ERC721.sol";

import "../interfaces/IRarityParty.sol";
import "./RartiyUtils.sol";

contract RarityParty is IRarityParty {
    using EnumerableSet for EnumerableSet.UintSet;

    address public constant rarity = 0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb;
    address public immutable rarityUtils;

    string public name;
    string public description;

    address public immutable factory;
    uint256 public immutable leader;
    address public immutable leaderOwner;
    EnumerableSet.UintSet internal _members;

    mapping(uint256 => address) public summonerOwner;

    constructor(
        address _factory,
        address _utils,
        uint256 _leader,
        address _leaderOwner,
        string memory _name,
        string memory _description
    ) {
        factory = _factory;
        rarityUtils = _utils;
        leader = _leader;
        leaderOwner = _leaderOwner;

        name = _name;
        description = _description;
    }

    modifier onlyLeader() {
        require(msg.sender == leaderOwner);
        _;
    }

    function members()
        external
        view
        override
        returns (uint256[] memory _partyMember)
    {
        return _members.values();
    }

    function addMembers(uint256[] calldata summonersArray)
        external
        override
        onlyLeader
    {
        for (uint256 i; i < summonersArray.length; i++) {
            _addMember(summonersArray[i]);
        }
    }

    function addMember(uint256 summonerID) external override onlyLeader {
        _addMember(summonerID);
    }

    function _addMember(uint256 _summoner) internal {
        require(
            rarityUtils._isApprovedOrOwner(summonerID),
            "not-owner-or-approved"
        );
        IERC721(address(rarity)).transferFrom(
            msg.sender,
            address(this),
            _summoner
        );
        summonerOwner[_summoner] = msg.sender;
        _members.add(_summoner);
    }

    function getSummonersFromParty(uint256[] calldata summonersArray)
        external
        override
    {
        for (uint256 i; i < summonersArray.length; i++) {
            _getSummonerFromParty(summonersArray[i]);
        }
    }

    function getSummonerFromParty(uint256 summoner) external override {
        _getSummonerFromParty(summoner);
    }

    function _getSummonerFromParty(uint256 summoner) internal {
        require(
            summonerOwner[summoner] != msg.sender,
            "invalid-summoner-owner"
        );
        IERC721(address(rarity)).transferFrom(
            address(this),
            msg.sender,
            summoner
        );
        delete summonerOwner[summoner];
        _members.remove(summoner);
    }

    function forceSummonersOffParty(uint256[] calldata summonersArray)
        external
        override
        onlyLeader
    {
        for (uint256 i; i < summonersArray.length; i++) {
            _forceSummonerOffParty(summonersArray[i]);
        }
    }

    function forceSummonerOffParty(uint256 summoner)
        external
        override
        onlyLeader
    {
        _forceSummonerOffParty(summoner);
    }

    function _forceSummonerOffParty(uint256 summoner) internal {
        IERC721(address(rarity)).transferFrom(
            address(this),
            summonerOwner[summoner],
            summoner
        );
        delete summonerOwner[summoner];
        _members.remove(summoner);
    }

    function action(address destContract, bytes memory data)
        external
        override
        onlyLeader
    {
        destContract.call(data);
    }

    function disband() external override {
        require(msg.sender == factory, "disband-called-outside-of-factory");
        for (uint256 i; i < _members.length(); i++) {
            _forceSummonerOffParty(_members.at(i));
        }
    }
}
