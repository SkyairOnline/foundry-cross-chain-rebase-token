// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {TokenPool} from "@ccip/contracts/src/v0.8/ccip/pools/TokenPool.sol";
import {RateLimiter} from "@ccip/contracts/src/v0.8/ccip/libraries/RateLimiter.sol";

contract ConfigurePoolScript is Script {
    function run(
        address localPool,
        uint64 remoteChainSelctor,
        address remotePool,
        address remoteToken,
        bool outboundRateLimiterIsEnabled,
        uint128 outboundLimiterCapacity,
        uint128 outboundLimiterRate,
        bool inboundRateLimiterIsEnabled,
        uint128 inboundLimiterCapacity,
        uint128 inboundLimiterRate
    ) public {
        vm.startBroadcast();
        TokenPool.ChainUpdate[] memory chainToAdd = new TokenPool.ChainUpdate[](
            1
        );
        chainToAdd[0] = TokenPool.ChainUpdate({
            remoteChainSelector: remoteChainSelctor,
            remotePoolAddress: abi.encode(remotePool),
            remoteTokenAddress: abi.encode(remoteToken),
            outboundRateLimiterConfig: RateLimiter.Config({
                isEnabled: outboundRateLimiterIsEnabled,
                capacity: outboundLimiterCapacity,
                rate: outboundLimiterRate
            }),
            inboundRateLimiterConfig: RateLimiter.Config({
                isEnabled: inboundRateLimiterIsEnabled,
                capacity: inboundLimiterCapacity,
                rate: inboundLimiterRate
            }),
            allowed: true
        });
        TokenPool(localPool).applyChainUpdates(chainToAdd);
        vm.stopBroadcast();
    }
}
