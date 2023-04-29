//SPDX-License-Identifier: unlicensed

pragma solidity ^0.8.0;
library search {
    function Indexof(uint [] storage self, uint value)public view returns(uint){
        for(uint i=0;i<self.length;i++) if(self[i]==value) return i;
        return uint(9);
    }
}

