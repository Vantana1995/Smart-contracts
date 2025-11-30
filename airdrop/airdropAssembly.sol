// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract MrPiculeAirDrop {
    address public owner;
    uint256 public airdropCount;
    mapping(uint256 => Airdrop) public airdrop;

    struct Airdrop {
        address token;
        address winner;
        uint256 amountToReceive;
        uint id;
        bool isCompleted;
        string airdropAddress;
        string ipfsData;
    }

    event WinnerSelected(
        uint256 indexed airdropId,
        address indexed winner,
        uint256 participantCount,
        string ipfsData
    );

    event AirdropCreated(
        uint256 indexed airdropId,
        address indexed token,
        uint256 id,
        uint256 amount,
        string xPage
    );

    constructor() {
        owner = msg.sender;
    }

    function createAirdrop(
        address _ercToken,
        uint256 _amountToReceive,
        uint256 _id,
        string memory _airdropAddress
    ) public {
        assembly {
            if iszero(eq(caller(), sload(owner.slot))) {
                // Unauthorized()
                mstore(0x00, shl(224, 0x82b42900))
                revert(0x00, 0x04)
            }

            let ptr := mload(0x40)

            let airdropId := sload(airdropCount.slot)
            sstore(airdropCount.slot, add(airdropId, 1))
            // hash for current aidrop address
            mstore(ptr, airdropId)
            mstore(add(ptr, 0x20), airdrop.slot)
            let currentAirdrop := keccak256(ptr, 0x40)

            //store data in Struct
            sstore(currentAirdrop, _ercToken)
            sstore(add(currentAirdrop, 2), _amountToReceive)

            // prepair and store string
            {
                // data length
                switch iszero(lt(mload(_airdropAddress), 0x20))
                case 1 {
                    sstore(
                        add(currentAirdrop, 5),
                        add(mul(mload(_airdropAddress), 2), 1)
                    )
                    // calculate address hash where data slot
                    mstore(0x00, add(currentAirdrop, 5))
                    // address where data must be stored
                    mstore(0x00, keccak256(0x00, 0x20))
                    // amount of words
                    mstore(0x20, div(add(mload(_airdropAddress), 31), 32))
                    // copy data
                    for {
                        let i := 0
                    } lt(i, mload(0x20)) {
                        i := add(i, 1)
                    } {
                        // check if its last slot of data
                        switch eq(i, sub(mload(0x20), 1))
                        case 1 {
                            // remaining bytes
                            mstore(
                                add(ptr, 0x20),
                                sub(mload(_airdropAddress), mul(i, 32))
                            )
                            // remaining data
                            mstore(
                                add(ptr, 0x40),
                                mload(
                                    add(add(_airdropAddress, 0x20), mul(i, 32))
                                )
                            )
                            // check if data is less than 32 bytes to store it in upper bytes
                            if lt(mload(add(ptr, 0x20)), 32) {
                                // calculate shift
                                mstore(
                                    add(ptr, 0x60),
                                    mul(sub(32, mload(add(ptr, 0x20))), 8)
                                )
                                // data to store
                                mstore(
                                    add(ptr, 0x40),
                                    shl(
                                        mload(add(ptr, 0x60)),
                                        shr(
                                            mload(add(ptr, 0x60)),
                                            mload(add(ptr, 0x40))
                                        )
                                    )
                                )
                            }
                            //store last bytes
                            sstore(add(mload(0x00), i), mload(add(ptr, 0x40)))
                        }
                        default {
                            sstore(
                                add(mload(0x00), i),
                                mload(
                                    add(add(_airdropAddress, 0x20), mul(i, 32))
                                )
                            )
                        }
                    }
                    mstore(add(ptr, 0x20), 0)
                    mstore(add(ptr, 0x40), 0)
                    mstore(add(ptr, 0x60), 0)
                }
                default {
                    //let strData
                    mstore(0x00, shl(1, mload(add(_airdropAddress, 0x20))))
                    //let packed
                    mstore(
                        0x20,
                        or(mload(0x00), mul(mload(_airdropAddress), 2))
                    )
                    sstore(add(currentAirdrop, 5), mload(0x20))
                }
            }

            // transferFrom
            {
                mstore(ptr, shl(224, 0x23b872dd))
                mstore(add(ptr, 0x04), caller())
                mstore(add(ptr, 0x24), address())
                switch iszero(_id)
                case 1 {
                    // for erc20 store amount
                    mstore(add(ptr, 0x44), _amountToReceive)
                }
                default {
                    // for erc721 store id
                    mstore(add(ptr, 0x44), _id)
                    // store erc721 id only if its erc721 airdrop
                    sstore(add(currentAirdrop, 3), _id)
                }
                if iszero(call(gas(), _ercToken, 0, ptr, 0x64, 0x00, 0x00)) {
                    // TransferFailed = 0xbf7e4b28
                    mstore(0x00, shl(224, 0xbf7e4b28))
                    revert(0x00, 0x04)
                }
            }

            // emit event
            {
                let words := mload(0x20)
                mstore(ptr, _id)
                mstore(add(ptr, 0x20), _amountToReceive)
                switch iszero(lt(mload(_airdropAddress), 0x20))
                case 1 {
                    mstore(add(ptr, 0x40), 0x60)
                    mstore(add(ptr, 0x60), mload(_airdropAddress))
                    for {
                        let i := 0
                    } lt(i, words) {
                        i := add(i, 1)
                    } {
                        // check if its last slot
                        switch eq(i, sub(words, 1))
                        case 1 {
                            // remaining bytes
                            mstore(
                                0x00,
                                sub(mload(_airdropAddress), mul(i, 32))
                            )
                            // remainig data
                            mstore(
                                0x20,
                                mload(
                                    add(add(_airdropAddress, 0x20), mul(i, 32))
                                )
                            )
                            // check if data is less than 32 bytes to store it in upper bytes
                            if lt(mload(0x00), 32) {
                                // calculate shift
                                mstore(0x00, mul(sub(32, mload(0x00)), 8))
                                // data to store
                                mstore(
                                    0x20,
                                    shl(
                                        mload(0x00),
                                        shr(mload(0x00), mload(0x20))
                                    )
                                )
                            }
                            // store last bytes of data
                            mstore(add(add(ptr, 0x80), mul(i, 32)), mload(0x20))
                        }
                        default {
                            mstore(
                                add(add(ptr, 0x80), mul(i, 32)),
                                mload(
                                    add(add(_airdropAddress, 0x20), mul(i, 32))
                                )
                            )
                        }
                    }
                    log3(
                        ptr,
                        add(0x80, mul(words, 32)),
                        0x8eda42eb155cde3b744cf21aed2a465c5ded54a24fa9691e2cc7c9747148daed,
                        airdropId,
                        _ercToken
                    )
                }
                default {
                    mstore(add(ptr, 0x40), 0x60)
                    mstore(add(ptr, 0x60), mload(_airdropAddress))
                    mstore(add(ptr, 0x80), mload(add(_airdropAddress, 0x20)))
                    log3(
                        ptr,
                        0xA0,
                        0x8eda42eb155cde3b744cf21aed2a465c5ded54a24fa9691e2cc7c9747148daed, // event selector
                        airdropId,
                        _ercToken
                    )
                }
            }
        }
    }

    function getWinner(
        address[] calldata participants,
        uint256 numOfAirdrop,
        string memory _ipfsData
    ) public {
        assembly {
            if iszero(eq(caller(), sload(owner.slot))) {
                // Unauthorized()
                mstore(0x00, shl(224, 0x82b42900))
                revert(0x00, 0x04)
            }

            // hash for current aidrop address
            mstore(0x00, numOfAirdrop)
            mstore(0x20, airdrop.slot)
            let currentAirdrop := keccak256(0x00, 0x40)
            let ptr := mload(0x40)

            // chose winner
            {
                // hash of all addresses participates
                let offset := calldataload(participants.offset)
                let len := calldataload(offset)
                let dataPtr := add(offset, 0x20)
                let dataLen := mul(len, 0x20)
                mstore(0x00, keccak256(dataPtr, dataLen))
                mstore(add(ptr, 0x20), numOfAirdrop)
                // erc address
                mstore(add(ptr, 0x40), sload(currentAirdrop))
                // amount to receive
                mstore(add(ptr, 0x60), sload(add(currentAirdrop, 2)))
                // hash of participants
                mstore(add(ptr, 0x80), mload(0x00))
                // block.timestamp
                mstore(add(ptr, 0xA0), timestamp())
                // block.prevrandao
                mstore(add(ptr, 0xC0), prevrandao())
                // block.number
                mstore(add(ptr, 0xE0), number())
                // tx.origin
                mstore(add(ptr, 0x100), origin())
                // msg.sender
                mstore(add(ptr, 0x120), caller())
                // hash for random number
                mstore(0x00, keccak256(add(ptr, 0x20), 0x120))
                // winner index
                mstore(0x20, mod(mload(0x00), mload(ptr)))
            }
            // winner address = participants[winnerIndex];
            mstore(
                0x00,
                calldataload(
                    add(add(participants.offset, 0x20), mul(mload(0x20), 0x20))
                )
            )
            let winner := mload(0x00)
            // clean memory slots
            {
                mstore(add(ptr, 0x80), 0)
                mstore(add(ptr, 0xA0), 0)
                mstore(add(ptr, 0xC0), 0)
                mstore(add(ptr, 0xE0), 0)
                mstore(add(ptr, 0x100), 0)
                mstore(add(ptr, 0x120), 0)
            }

            // store ipfs data address
            {
                switch iszero(lt(mload(_ipfsData), 0x20))
                case 1 {
                    // store 0xfff...1 for EVM uderstand that we have long string
                    sstore(
                        add(currentAirdrop, 6),
                        add(mul(mload(_ipfsData), 2), 1)
                    )
                    // address where data must be stored
                    mstore(0x00, add(currentAirdrop, 6))
                    mstore(0x00, keccak256(0x00, 0x20))
                    // amount of words
                    mstore(0x20, div(add(mload(_ipfsData), 31), 32))
                    // copy data
                    for {
                        let i := 0
                    } lt(i, mload(0x20)) {
                        i := add(i, 1)
                    } {
                        // check if its last slot
                        switch eq(i, sub(mload(0x20), 1))
                        case 1 {
                            // remaining bytes
                            mstore(
                                add(ptr, 0x80),
                                sub(mload(_ipfsData), mul(i, 32))
                            )
                            mstore(
                                add(ptr, 0xA0),
                                mload(add(add(_ipfsData, 0x20), mul(i, 32)))
                            )
                            if lt(mload(add(ptr, 0x80)), 32) {
                                // calculate shift
                                mstore(
                                    add(ptr, 0xC0),
                                    mul(sub(32, mload(add(ptr, 0x80))), 8)
                                )
                                // data to store
                                mstore(
                                    add(ptr, 0xA0),
                                    shl(
                                        mload(add(ptr, 0xC0)),
                                        shr(
                                            mload(add(ptr, 0xC0)),
                                            mload(add(ptr, 0xA0))
                                        )
                                    )
                                )
                            }
                            // store last bytes of data
                            sstore(add(mload(0x00), i), mload(add(ptr, 0xA0)))
                        }
                        default {
                            sstore(
                                add(mload(0x00), i),
                                mload(add(add(_ipfsData, 0x20), mul(i, 32)))
                            )
                        }
                    }
                }
                default {
                    // let strData + move left side for 1 byte to avoid collision
                    mstore(0x00, shl(1, mload(add(_ipfsData, 0x20))))
                    // let packed
                    mstore(0x20, or(mload(0x00), mul(mload(_ipfsData), 2)))
                    sstore(add(currentAirdrop, 6), mload(0x20))
                }
            }
            sstore(add(currentAirdrop, 1), winner)
            // bool isComplete = true
            sstore(add(currentAirdrop, 4), 1)
            // id token
            mstore(0x00, sload(add(currentAirdrop, 3)))
            // check if its erc721 and trasfer tokens
            {
                switch gt(mload(0x00), 0)
                case 1 {
                    mstore(add(ptr, 0x80), shl(224, 0x23b872dd))
                    mstore(add(ptr, 0x84), address())
                    mstore(add(ptr, 0xA4), winner)
                    mstore(add(ptr, 0xC4), mload(0x00))
                    if iszero(
                        call(
                            gas(),
                            mload(add(ptr, 0x40)),
                            0,
                            add(ptr, 0x80),
                            0x64,
                            0x00,
                            0x00
                        )
                    ) {
                        // TransferAtAirdropFailed
                        mstore(0x00, shl(224, 0x5cb71482))
                        revert(0x00, 0x04)
                    }
                }
                default {
                    mstore(add(ptr, 0x80), shl(224, 0xa9059cbb))
                    mstore(add(ptr, 0x84), winner)
                    mstore(add(ptr, 0xA4), mload(add(ptr, 0x60)))
                    if iszero(
                        call(
                            gas(),
                            mload(add(ptr, 0x40)),
                            0,
                            add(ptr, 0x80),
                            0x44,
                            0x00,
                            0x00
                        )
                    ) {
                        mstore(0x00, shl(224, 0x5cb71482))
                        revert(0x00, 0x04)
                    }
                }
            }
            // emit event
            {
                let words := mload(0x20)
                switch iszero(lt(mload(_ipfsData), 0x20))
                case 1 {
                    mstore(add(ptr, 0x20), 0x40)
                    mstore(add(ptr, 0x40), mload(_ipfsData))
                    for {
                        let i := 0
                    } lt(i, words) {
                        i := add(i, 1)
                    } {
                        // check if its last slot
                        switch eq(i, sub(words, 1))
                        case 1 {
                            // remaining bytes
                            mstore(0x00, sub(mload(_ipfsData), mul(i, 32)))
                            mstore(
                                0x20,
                                mload(add(add(_ipfsData, 0x20), mul(i, 32)))
                            )
                            if lt(mload(0x00), 32) {
                                // calculate shift
                                mstore(0x00, mul(sub(32, mload(0x00)), 8))
                                // data to store
                                mstore(
                                    0x20,
                                    shl(
                                        mload(0x00),
                                        shr(mload(0x00), mload(0x20))
                                    )
                                )
                            }
                            // store last bytes of data
                            mstore(add(add(ptr, 0x60), mul(i, 32)), mload(0x20))
                        }
                        default {
                            mstore(
                                add(add(ptr, 0x60), mul(i, 32)),
                                mload(add(add(_ipfsData, 0x20), mul(i, 32)))
                            )
                        }
                    }
                    log3(
                        ptr,
                        add(0x60, mul(words, 32)),
                        0x3d5e70cba244dd8ace94c8e4c250e315aa9cb3e5324c9e9dbed8202b639a90cb,
                        numOfAirdrop,
                        winner
                    )
                }
                default {
                    mstore(0x00, shl(1, mload(add(_ipfsData, 0x20))))
                    mstore(
                        add(ptr, 0x20),
                        or(mload(0x00), mul(mload(_ipfsData), 2))
                    )
                    log3(
                        ptr,
                        0x40,
                        0x3d5e70cba244dd8ace94c8e4c250e315aa9cb3e5324c9e9dbed8202b639a90cb,
                        numOfAirdrop,
                        winner
                    )
                }
            }
        }
    }
}
