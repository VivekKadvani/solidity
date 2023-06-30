// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract TossPlay is VRFV2WrapperConsumerBase {
    event CoinFlipRequest (uint requestId);
    event CoinFlipResult(uint256 requestId,bool didWin);

    struct CoinFlipStatus{
        uint256 fees;
        uint256 randomWord;
        address player;
        bool didWin;
        bool fulfilled;
        CoinFlipSelection choice;
    }

    enum CoinFlipSelection {
        HEADS,
        TAILS
    }
    mapping(uint256=>CoinFlipStatus) public statuses; 
    
    address constant linkAddress =0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address constant vrfWrapperAddress = 0xab18414CD93297B0d12ac29E63Ca20f515b3DB46;
    
    uint32 constant callbackGasLimit = 1000000;
    uint32 constant numWords =1;
    uint16 constant requestConfirmation = 3;

    constructor() VRFV2WrapperConsumerBase(linkAddress,vrfWrapperAddress){

    }


    function flip(CoinFlipSelection choice) external returns(uint256){


    uint256 requestId = requestRandomness(callbackGasLimit,requestConfirmation,numWords );
    statuses[requestId] = CoinFlipStatus({
        fees:VRF_V2_WRAPPER.calculateRequestPrice (callbackGasLimit),
        randomWord : 0,
        player : msg.sender,
        didWin :false,
        fulfilled : false,
        choice : choice
    });
    emit CoinFlipRequest(requestId);
    return requestId;
    }

    function fulfillRandomWords(uint256 requestId,uint256[] memory randomWords)internal override{
        statuses[requestId].fulfilled =true;
        statuses[requestId].randomWord = randomWords[0];

        CoinFlipSelection result = CoinFlipSelection.HEADS;
        if(randomWords[0]%2 ==0){
            result =CoinFlipSelection.TAILS;
        }

        if(statuses[requestId].choice == result){
            statuses[requestId].didWin=true;
        }
        emit CoinFlipRequest(requestId);
    }

    function getStatus(uint256 requestId)public view returns(CoinFlipStatus memory){
        return statuses[requestId];
    }
}