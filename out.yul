object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      let method_id := shr(0xe0, calldataload(0x0))
switch method_id
case 0xeb319a69 {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let a := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)

  let b := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)

  let c := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := increment_mapping(a,b,c)

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
mstore(where_to_store_head$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$ := add(where_to_store_head$, 32)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0xe872416a {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let a := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := increment_int(a)

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
mstore(where_to_store_head$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$ := add(where_to_store_head$, 32)

processed_return_value$ := add(processed_return_value$, 32)
return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}

default {revert(0, 0)}


      function increment_mapping(a, b, c) -> return_value$ {
  let offset$ := msize()
  


mstore(offset$, 1)
offset$ := add(offset$, 32)
switch byte(0, mload(b))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, b)))
offset$ := add(offset$, 32)
switch byte(0, mload(a))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, a)))
offset$ := add(offset$, 32)

let $storage_get$0$ := offset$
mstore8(offset$, 67)
mstore(add(1, offset$), sload(keccak256(sub(offset$, 96), 96)))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 33)


let add$1 := add$($storage_get$0$, c)
offset$ := msize()




mstore(offset$, 1)
offset$ := add(offset$, 32)
switch byte(0, mload(b))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, b)))
offset$ := add(offset$, 32)
switch byte(0, mload(a))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, a)))
offset$ := add(offset$, 32)


sstore(keccak256(sub(offset$, 96), 96), take_32_bytes$(mload(add(add$1, 1))))

  


mstore(offset$, 1)
offset$ := add(offset$, 32)
switch byte(0, mload(b))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, b)))
offset$ := add(offset$, 32)
switch byte(0, mload(a))
  case 67 {}
  default {revert(0, 0)}

mstore(offset$, mload(add(1, a)))
offset$ := add(offset$, 32)

let $storage_get$2$ := offset$
mstore8(offset$, 67)
mstore(add(1, offset$), sload(keccak256(sub(offset$, 96), 96)))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 33)

  return_value$ := $storage_get$2$
}
function increment_int(a) -> return_value$ {
  let offset$ := msize()
  



sstore(0xbc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a, take_32_bytes$(mload(add(a, 1))))

  

let $storage_get$0$ := offset$
mstore8(offset$, 67)
mstore(add(1, offset$), sload(0xbc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a))
//offset$ := add(offset$, 1)
offset$ := add(offset$, 33)

  return_value$ := $storage_get$0$
}
  function load_integer$(ptr) -> return_value$, size$ {
    size$ := byte(0, mload(ptr))
    let value := mload(add(ptr, 1))
    switch size$
      case 36 {
  return_value$ := take_1_bytes$(value)
}
case 37 {
  return_value$ := take_2_bytes$(value)
}
case 38 {
  return_value$ := take_3_bytes$(value)
}
case 39 {
  return_value$ := take_4_bytes$(value)
}
case 40 {
  return_value$ := take_5_bytes$(value)
}
case 41 {
  return_value$ := take_6_bytes$(value)
}
case 42 {
  return_value$ := take_7_bytes$(value)
}
case 43 {
  return_value$ := take_8_bytes$(value)
}
case 44 {
  return_value$ := take_9_bytes$(value)
}
case 45 {
  return_value$ := take_10_bytes$(value)
}
case 46 {
  return_value$ := take_11_bytes$(value)
}
case 47 {
  return_value$ := take_12_bytes$(value)
}
case 48 {
  return_value$ := take_13_bytes$(value)
}
case 49 {
  return_value$ := take_14_bytes$(value)
}
case 50 {
  return_value$ := take_15_bytes$(value)
}
case 51 {
  return_value$ := take_16_bytes$(value)
}
case 52 {
  return_value$ := take_17_bytes$(value)
}
case 53 {
  return_value$ := take_18_bytes$(value)
}
case 54 {
  return_value$ := take_19_bytes$(value)
}
case 55 {
  return_value$ := take_20_bytes$(value)
}
case 56 {
  return_value$ := take_21_bytes$(value)
}
case 57 {
  return_value$ := take_22_bytes$(value)
}
case 58 {
  return_value$ := take_23_bytes$(value)
}
case 59 {
  return_value$ := take_24_bytes$(value)
}
case 60 {
  return_value$ := take_25_bytes$(value)
}
case 61 {
  return_value$ := take_26_bytes$(value)
}
case 62 {
  return_value$ := take_27_bytes$(value)
}
case 63 {
  return_value$ := take_28_bytes$(value)
}
case 64 {
  return_value$ := take_29_bytes$(value)
}
case 65 {
  return_value$ := take_30_bytes$(value)
}
case 66 {
  return_value$ := take_31_bytes$(value)
}
case 67 {
  return_value$ := take_32_bytes$(value)
}

      default {
        // TypeError
        revert(0, 0)
      }
  }

function take_8_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFF)
}

function take_27_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_19_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_31_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_10_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFF)
}

function take_22_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_7_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFF)
}

function take_18_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_28_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_2_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFF)
}

function take_30_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_24_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_17_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function add$(a, b) -> return_value$ {
  let a$, a_size$ := load_integer$(a)
  let b$, b_size$ := load_integer$(b)
  b$ := add(a$, b$)
  let c := a_size$
  if gt(b_size$, a_size$) {
    c := b_size$
  }
  let offset$ := msize()
  mstore8(offset$, c)
  mstore(add(offset$, 1), b$)
  return_value$ := offset$
}

function take_6_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFF)
}

function take_26_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_9_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFF)
}

function take_23_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_20_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_21_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_14_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_1_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFF)
}

function take_12_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_25_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_13_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_16_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_4_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFF)
}

function take_3_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFF)
}

function take_29_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_15_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_5_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFF)
}

function take_11_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFF)
}

function take_32_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

    }
  }
}
