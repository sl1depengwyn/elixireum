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
