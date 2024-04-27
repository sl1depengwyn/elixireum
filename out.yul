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
case 0x4315a5eb {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := qwe()

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 1 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)

mcopy(processed_return_value$, return_value$, size$)
processed_return_value$ := add(processed_return_value$, mul(32, add(1, div(sub(size$, 1), 32))))
return_value$ := add(return_value$, size$)

return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x8a2266d3 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let contract_symbol := memory_offset$
  mstore8(memory_offset$, 1)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$$contract_symboloffset := add(init_calldata_offset$, calldataload(calldata_offset$))
calldata_offset$ := add(calldata_offset$, 32)

let calldata_offset$$contract_symbollength := calldataload(calldata_offset$$contract_symboloffset)
calldata_offset$$contract_symboloffset := add(calldata_offset$$contract_symboloffset, 32)
mstore(memory_offset$, calldata_offset$$contract_symbollength)
memory_offset$ := add(memory_offset$, 32)

calldatacopy(memory_offset$, calldata_offset$$contract_symboloffset, calldata_offset$$contract_symbollength)
memory_offset$ := add(memory_offset$, calldata_offset$$contract_symbollength)


  let return_value$ := store_name(contract_symbol)

  return(0, 0)

}
case 0x54d85f73 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := retrieve_name()

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 1 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)

mcopy(processed_return_value$, return_value$, size$)
processed_return_value$ := add(processed_return_value$, mul(32, add(1, div(sub(size$, 1), 32))))
return_value$ := add(return_value$, size$)

return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x23ffe214 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let a := memory_offset$
  mstore8(memory_offset$, 84)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 15)
calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := test_bytes15(a)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
switch byte(0, mload(return_value$))
  case 84 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

mstore(where_to_store_head$, shl(136, shr(136, mload(return_value$))))
where_to_store_head$ := add(where_to_store_head$, 32)

return_value$ := add(return_value$, 15)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x16e560f4 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let a := memory_offset$
  mstore8(memory_offset$, 1)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$$aoffset := add(init_calldata_offset$, calldataload(calldata_offset$))
calldata_offset$ := add(calldata_offset$, 32)

let calldata_offset$$alength := calldataload(calldata_offset$$aoffset)
calldata_offset$$aoffset := add(calldata_offset$$aoffset, 32)
mstore(memory_offset$, calldata_offset$$alength)
memory_offset$ := add(memory_offset$, 32)

calldatacopy(memory_offset$, calldata_offset$$aoffset, calldata_offset$$alength)
memory_offset$ := add(memory_offset$, calldata_offset$$alength)


  let return_value$ := test_string(a)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 1 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)

mcopy(processed_return_value$, return_value$, size$)
processed_return_value$ := add(processed_return_value$, mul(32, add(1, div(sub(size$, 1), 32))))
return_value$ := add(return_value$, size$)

return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0xea54e440 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := test_address()

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
case 0x68aa6be9 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let num := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, shl(0, calldataload(calldata_offset$)))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := abc(num)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$, shr(0, mload(return_value$)))
return_value$ := add(return_value$, 32)
where_to_store_head$ := add(where_to_store_head$, 32)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0xe2179b7f {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := return_origin()

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
case 0x0c8f9aa2 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := get_int_test()

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$, shr(0, mload(return_value$)))
return_value$ := add(return_value$, 32)
where_to_store_head$ := add(where_to_store_head$, 32)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x0131222f {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := get_address()

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
case 0x957592d6 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0

  let return_value$ := test_address_storage()

  return(0, 0)

}

default {revert(0, 0)}


      function get_owner() -> return_value$ {
  let offset$ := msize()
  
  

let $storage_get$0$ := offset$
mstore8(offset$, 68)
mstore(add(1, offset$), sload(0xf2ee15ea639b73fa3db9b34a245bdfa015c260c598b211bf05a1ecc4b3e3b4f2))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 21)

  return_value$ := $storage_get$0$
}
function qwe() -> return_value$ {
  let offset$ := msize()
  
  let str0$ := offset$
mstore8(offset$, 1)
offset$ := add(offset$, 1)
mstore(offset$, 25)
offset$ := add(offset$, 32)
mstore(offset$, 0x72657475726e2031323331323331323331323331323331323300000000000000)
offset$ := add(offset$, 25)



  return_value$ := str0$
}
function store_name(contract_symbol) -> return_value$ {
  let offset$ := msize()
  
  
  let storage_i_0$ := contract_symbol
switch byte(0, mload(storage_i_0$))
case 1 {}
default {
  // Return type mismatch
  revert(0, 0)
}
storage_i_0$ := add(storage_i_0$, 1)
let slot_storage0$ := 0x69c322e3248a5dfc29d73c5b0553b0185a35cd5bb6386747517ef7e53b15e287

let str_size$0$ := mload(storage_i_0$)
storage_i_0$ := add(storage_i_0$, 32)
let storage_i_0$end := add(storage_i_0$, str_size$0$)

sstore(slot_storage0$, str_size$0$)
slot_storage0$ := add(slot_storage0$, 1)

 for { } lt(storage_i_0$, storage_i_0$end)
 {
   storage_i_0$ := add(storage_i_0$, 32)
   slot_storage0$ := add(slot_storage0$, 1)
 }
 {
  sstore(slot_storage0$, mload(storage_i_0$))
 }

}
function retrieve_name() -> return_value$ {
  let offset$ := msize()
  
  let $storage_get$0$ := offset$

mstore8(offset$, 1)
offset$ := add(offset$, 1)

let slot_storage0$ := 0x69c322e3248a5dfc29d73c5b0553b0185a35cd5bb6386747517ef7e53b15e287
let str_size$0$ := sload(slot_storage0$)
slot_storage0$ := add(slot_storage0$, 1)
let storage_i_0$end := add(slot_storage0$, add(1, div(sub(str_size$0$, 1), 32)))

mstore(offset$, str_size$0$)
offset$ := add(offset$, 32)

 for { } lt(slot_storage0$, storage_i_0$end)
 {
   offset$ := add(offset$, 32)
   slot_storage0$ := add(slot_storage0$, 1)
 }
 {
  mstore(offset$, sload(slot_storage0$))
 }

  return_value$ := $storage_get$0$
}
function test_bytes15(a) -> return_value$ {
  let offset$ := msize()
  
  
  return_value$ := a
}
function test_string(a) -> return_value$ {
  let offset$ := msize()
  
  
  return_value$ := a
}
function test_address() -> return_value$ {
  let offset$ := msize()
  
  let address3$ := offset$
mstore8(offset$, 68)
offset$ := add(offset$, 1)
mstore(offset$, shl(96, 0x8a258309B8177Df36c48de82885A56cCF576979C))
offset$ := add(offset$, 20)

  return_value$ := address3$
}
function abc(num) -> return_value$ {
  let offset$ := msize()
  
  let var0$ := offset$
mstore8(offset$, 67)
offset$ := add(offset$, 1)
mstore(offset$, shl(0, 10))
offset$ := add(offset$, 32)


let add$1 := add$(var0$, num)
offset$ := msize()

  return_value$ := add$1
}
function return_origin() -> return_value$ {
  let offset$ := msize()
  
  let tx_origin$0 := offset$
mstore8(offset$, 68)
offset$ := add(offset$, 1)
mstore(offset$, shl(96, origin()))
offset$ := add(offset$, 20)

  return_value$ := tx_origin$0
}
function get_int_test() -> return_value$ {
  let offset$ := msize()
  
  

let $storage_get$0$ := offset$
mstore8(offset$, 67)
mstore(add(1, offset$), sload(0xbc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 33)

  return_value$ := $storage_get$0$
}
function get_address() -> return_value$ {
  let offset$ := msize()
  
  

let $storage_get$0$ := offset$
mstore8(offset$, 68)
mstore(add(1, offset$), sload(0x5fe7f977e71dba2ea1a68e21057beebb9be2ac30c6410aa38d4f3fbe41dcffd2))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 21)

  return_value$ := $storage_get$0$
}
function test_address_storage() -> return_value$ {
  let offset$ := msize()
  
  let tx_origin$0 := offset$
mstore8(offset$, 68)
offset$ := add(offset$, 1)
mstore(offset$, shl(96, origin()))
offset$ := add(offset$, 20)




  sstore(0xf2ee15ea639b73fa3db9b34a245bdfa015c260c598b211bf05a1ecc4b3e3b4f2, mload(add(tx_origin$0, 1)))
}
function add$(a, b) -> return_value$ {
  let a$, a_type$ := load_integer$(a)
  let b$, b_type$ := load_integer$(b)
  b$ := add(a$, b$)
  let max_type := a_type$
  if gt(b_type$, a_type$) {
    max_type := b_type$
  }
  let offset$ := msize()
  mstore8(offset$, max_type)
  mstore(add(offset$, 1), shl(mul(8, sub(32, type_to_byte_size$(max_type))), b$))
  return_value$ := offset$
}

  function load_integer$(ptr) -> return_value, type {
    type := byte(0, mload(ptr))
    let value := mload(add(ptr, 1))
    let size := type_to_byte_size$(type)
    return_value := shr(mul(sub(32, size), 8), value)
  }

function type_to_byte_size$(type) -> size {
  switch type
  case 1 {size := 32}
  case 2 {size := 1}
  case 3 {size := 32}
  case 68 {size := 20}
  case 102 {size := 32}
  default {
    if lt(type, 36) {
      size := sub(type, 3)
      leave
    }
    if lt(type, 68) {
      size := sub(type, 35)
      leave
    }
    if lt(type, 102) {
      size := sub(type, 69)
      leave
    }
  }
}

    }
  }
}
