object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
return(0, datasize("runtime"))

  }
  object "runtime" {
    code {
      let method_id := shr(224, calldataload(0x0))
switch method_id
case 0x0ac298dc {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := get_owner()

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
switch byte(0, mload(return_value$))
  case 68 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$, shr(96, mload(return_value$)))
return_value$ := add(return_value$, 20)
where_to_store_head$ := add(where_to_store_head$, 32)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x4980500b {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := event()

  return(0, 0)

}
case 0x957592d6 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := test_address_storage()

  return(0, 0)

}

default {revert(0, 0)}


      function get_owner() -> return_value_1$ {
  let offset$ := msize()
  
  

let $storage_get$0$ := offset$
mstore8(offset$, 68)
mstore(add(1, offset$), sload(0xf2ee15ea639b73fa3db9b34a245bdfa015c260c598b211bf05a1ecc4b3e3b4f2))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 21)

  return_value_1$ := $storage_get$0$
}
function event() -> return_value_1$ {
  let offset$ := msize()
  
  let var0$ := offset$
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, shl(0, 1))
offset$ := add(offset$, 32)
let indexed_a_pointer$ := var0$
switch byte(0, mload(indexed_a_pointer$))
  case 67 {}
  default {
    revert(0, 0)
  }

indexed_a_pointer$ := add(indexed_a_pointer$, 1)
let indexed_a_keccak_var$ := shr(0, mload(indexed_a_pointer$))

let list4$ := offset$
mstore8(offset$, 103)
offset$ := add(offset$, 1)
mstore(offset$, 3)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 1)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 2)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 3)
offset$ := add(offset$, 32)

let indexed_b_keccak_init$ := offset$
let indexed_b_pointer$ := list4$
  switch byte(0, mload(indexed_b_pointer$))
    case 103 {}
    default {revert(0, 0)}

  indexed_b_pointer$ := add(indexed_b_pointer$, 1)
  let size_of_indexed_b_pointer$_0$ := mload(indexed_b_pointer$)
  indexed_b_pointer$ := add(indexed_b_pointer$, 32)

  for {let i_indexed_b_pointer$0$ := 0} lt(i_indexed_b_pointer$0$, size_of_indexed_b_pointer$_0$)
  {
    i_indexed_b_pointer$0$ := add(i_indexed_b_pointer$0$, 1)
  }
  {
      switch byte(0, mload(indexed_b_pointer$))
    case 67 {}
    default {revert(0, 0)}

  indexed_b_pointer$ := add(indexed_b_pointer$, 1)
  mstore(offset$, shr(0, indexed_b_pointer$))
  offset$ := add(offset$, 32)
  indexed_b_pointer$ := add(indexed_b_pointer$, 32)

    offset$ := add(indexed_b_keccak_init$, mul(32, add(1, div(sub(sub(offset$, indexed_b_keccak_init$), 1), 32))))
  }

let indexed_b_keccak_var$ := keccak256(indexed_b_keccak_init$, sub(offset$, indexed_b_keccak_init$))

//let indexed_data_init$ := msize()
//let indexed_data$ := indexed_data_init$
//indexed_data$ := add(indexed_data$, 64)
let return_value$ := 0
let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
processed_return_value$ := add(processed_return_value$, 64)
let var5$ := offset$
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, shl(0, 2))
offset$ := add(offset$, 32)
let list9$ := offset$
mstore8(offset$, 103)
offset$ := add(offset$, 1)
mstore(offset$, 3)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 1)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 2)
offset$ := add(offset$, 32)
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, 3)
offset$ := add(offset$, 32)

let c_$ := processed_return_value$
let c_init$ := c_$
let c_where_to_store_head$ := add(processed_return_value_init$, 0)
let c_where_to_store_head_init$ := c_where_to_store_head$
return_value$ := var5$
switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(c_where_to_store_head$, shr(0, mload(return_value$)))
return_value$ := add(return_value$, 32)
c_where_to_store_head$ := add(c_where_to_store_head$, 32)

// processed_return_value$ := add(processed_return_value$, 32)
// return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
let d_$ := processed_return_value$
let d_init$ := d_$
let d_where_to_store_head$ := add(processed_return_value_init$, 32)
let d_where_to_store_head_init$ := d_where_to_store_head$
return_value$ := list9$
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)



mstore(d_where_to_store_head$, sub(processed_return_value$, d_where_to_store_head_init$))
d_where_to_store_head$ := add(d_where_to_store_head$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)


let d_where_to_store_head$i$_$ := processed_return_value$
let d_where_to_store_head_init$i$_$ := d_where_to_store_head$i$_$

processed_return_value$ := add(processed_return_value$, mul(size$, 32))

for { let i$ := 0 } lt(i$, size$) { i$ := add(i$, 1) } {
  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(d_where_to_store_head$i$_$, shr(0, mload(return_value$)))
return_value$ := add(return_value$, 32)
d_where_to_store_head$i$_$ := add(d_where_to_store_head$i$_$, 32)

}

// processed_return_value$ := add(processed_return_value$, 32)
// return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))


  log3(processed_return_value_init$, sub(processed_return_value_init$, processed_return_value$), 0x440e3ef808cab35cf3ac3f28adaf173b52d585f1f2d9e6fb1b705b96b3542b71, indexed_a_keccak_var$, indexed_b_keccak_var$)

}
function test_address_storage() -> return_value_1$ {
  let offset$ := msize()
  
  let tx_origin$0 := offset$
mstore8(offset$, 68)
offset$ := add(offset$, 1)
mstore(offset$, shl(96, origin()))
offset$ := add(offset$, 20)




  sstore(0xf2ee15ea639b73fa3db9b34a245bdfa015c260c598b211bf05a1ecc4b3e3b4f2, mload(add(tx_origin$0, 1)))
}

    }
  }
}
