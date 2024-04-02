// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
/*
* Onchain Metadata for BLOKs
*/
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
contract OnChainMetadata {
    string[] public pool = ['pink', 'gold', 'blue', 'lime', 'orange',  'white', 'black'];

   // string[11] private classes = ["cls-2", "cls-1", "cls-3", "cls-1", "cls-2", "cls-1", "cls-3", "cls-1", "cls-2", "cls-1", "cls-2"];
    //string[11] private paths = [?];
    
    
    struct Metadata {
        string index;
        string blokType;
        string encoded;
        string image;
    }

    mapping(string => Metadata) public metadata;
    mapping(string => uint256) public distribution;
    mapping(string => uint256) public totalMinted;

    /// Setup

    constructor() {
    totalMinted["pink"] = 0;
    totalMinted["gold"] = 0;
    totalMinted["blue"] = 0;
    totalMinted["lime"] = 0;
    totalMinted["orange"] = 0;
    totalMinted["white"] = 0;
    totalMinted["black"] = 0;
    distribution["pink"] = 1319;
    distribution["gold"] = 1764;
    distribution["blue"] = 2898;
    distribution["lime"] = 3045;
    distribution["orange"] = 5002;
    distribution["white"] = 13986;
    distribution["black"] = 13986;
}

    /// TODO: create the batch setup function
    function _setUp(string memory _index, string[] memory data) internal {
        metadata[_index] = Metadata({
            index: data[0],
            blokType: data[1],
            encoded: data[3],
            image: data[4]
        });
    }

    function updatePool(string memory _blokType) private {
        totalMinted[_blokType]++;
        if(totalMinted[_blokType] >= distribution[_blokType]) {
            for (uint256 i = 0; i < pool.length; i++) {
                if (totalMinted[pool[i]] >= distribution[pool[i]]) {
                    pool[i] = pool[pool.length - 1];
                    pool.pop();
                }
            }
        }
    }

    function getRandomBlok() internal returns (string memory) {
        uint256 _total = 0;
        for (uint256 i = 0; i < pool.length; i++) {
            _total += distribution[pool[i]] - totalMinted[pool[i]];
        }
        if(_total == 0) revert('No options left');
        uint256 _random = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % _total;

        uint256 range_a = 0;
        uint256 range_b = 0;
        
        for (uint256 i = 0; i < pool.length; i++) {
            range_b += distribution[pool[i]] - totalMinted[pool[i]];
            if(_random >= range_a && _random < range_b && 
                keccak256(abi.encodePacked(metadata[pool[i]].index)) == keccak256(abi.encodePacked(pool[i]))
            ) {
                string memory _blokType = pool[i];
                updatePool(_blokType);
                return _blokType;
            }
            range_a = range_b;
        }
        revert('BlokType not found');
    }

  ///  function renderAndEncodeFromSVG(string memory _beanType) internal view returns (bytes memory) {
       // Metadata memory _metadata = metadata[_beanType];
       // bytes memory svg;
    // for(uint8 i = 0; i < paths.length; i++) {
        //    svg = abi.encodePacked(svg, '<path d="', paths[i], '" class="', classes[i], '"/>');
       // }
       // svg = abi.encodePacked(
       //     '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2500 2500" width="600" height="600">',
       //         '<style>.cls-1{fill:', _metadata.colors.cls_1,';}.cls-1,.cls-2,.cls-3{stroke-width:0px;}.cls-2{fill:', _metadata.colors.cls_2,';}.cls-3{fill:', _metadata.colors.cls_3,';}</style>',
       //         svg,
       //     '</svg>'
      //  );
      //  return abi.encodePacked(
      //      'data:image/svg+xml;base64,',
      //      Base64.encode(svg)
      //  );
   // }

   // function getMetadataBytes(string memory _blokType) internal view returns (bytes memory, bytes memory) {
  //      Metadata memory _metadata = metadata[_blokType];
  //      bytes memory _encodedSVG = renderAndEncodeFromSVG(_beanType);
 //       bytes memory _rawMetadata = abi.encodePacked(
 //           '{"LSP4Metadata": {"name": "GM Bean","description": "Celebrate being UP early and boost your day with coffee.","links": [],"icon":[],"images": [[{"width": 600,"height": 600,',
 //           '"url": "',_encodedSVG,'","verification": {"method": "keccak256(bytes)","data": "',_metadata.encoded,'"}}]],',
//'"attributes":[{"key": "Type","value": "',_metadata.beanType,'","type": "string"}, {"key": "Variation","value": "',_metadata.variation,'","type": "string"}]}}'
 //       );
 //       return (_rawMetadata, abi.encodePacked(
 //           "data:application/json;base64,",
 //           Base64.encode(_rawMetadata)
 //       ));
    }    
//}