// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LegacyToken is ERC20("LegacyToken", "LGT"), Ownable {
    DelegateERC20 public delegate;

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
        delegate = newContract;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        if (address(delegate) == address(0)) {
            return super.transfer(to, value);
        } else {
            return delegate.delegateTransfer(to, value, msg.sender);
        }
    }
}

/*
    Argument encoding: Starting from the fifth byte, the encoded arguments follow
*/
contract DetectionBot is IDetectionBot {
    address private victim;

    constructor(address _monitoredSource) {
        victim = _monitoredSource;
    }


    function handleTransaction(address user, bytes calldata msgData) external override {
        
        //  function selector (4 bytes) and the function payload
        (,, address origSender) = abi.decode(msgData[4:], (address, uint256, address));

        // reconstruct the calling signature by merging the first 4 bytes of the msgData
        bytes memory callSig = abi.encodePacked(msgData[0], msgData[1], msgData[2], msgData[3]);
        // compare with monitores call sig
        bytes memory monitoredCall = abi.encodeWithSignature("delegateTransfer(address,uint256,address)");

        if (origSender == victim && keccak256(monitoredCall) == keccak256(callSig)) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}