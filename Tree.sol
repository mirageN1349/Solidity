// SPDX-License-Identifier: GPL-3.0
pragma solidity <0.9.0;
// Древо Меркла

contract Tree {
    bytes32[] public hashes;
    string[8] public transactions = ["T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8"];

    constructor() {
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encode(transactions[i])));
        }

        uint count = transactions.length;
        uint offset = 0;
        
        while(count > 0) {
            for(uint i = 0; i < count - 1; i += 2) {
                bytes memory concatTransactions = abi.encode(hashes[offset + i], hashes[offset + i + 1]);
                hashes.push(keccak256(concatTransactions));
            }

            offset += count;
            count = count / 2;
        }
    }

    function getHashes() public view returns (bytes32[] memory) {
        return hashes;
    }

    function getTxHashByIndex(uint index) public view returns (bytes32) {
        return hashes[index];
    }

    function validateTx(string memory transaction, uint index, bytes32 rootHash, bytes32[] memory proof) public returns (bool) {
       bytes32 hash = keccak256(abi.encode(transaction));

        for(uint i = 0; i < proof.length; i++) {
            if(index % 2 == 0) {
                hash = keccak256(abi.encode(hash, proof[i]));
            } else {
                hash = keccak256(abi.encode(proof[i], hash));
            }
            index = index / 2;
        }

        return hash == rootHash;
    }
}
