object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      let method_id := shr(0xe0, calldataload(0x0))
switch method_id
case 0xdde0f413 {
  let calldata_offset$ := 4
  let memory_offset$ := 0
    let num := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)

  let fake_num := memory_offset$
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := store(num,fake_num)

  return(0, 0)

}
case 0x9361fd77 {
  let calldata_offset$ := 4
  let memory_offset$ := 0
    let arr := memory_offset$
  mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$arr := add(calldata_offset$, calldataload(calldata_offset$))

let calldata_offset$arr_length := calldataload(calldata_offset$arr)
mstore(memory_offset$, calldata_offset$arr_length)
memory_offset$ := add(memory_offset$, 32)
calldata_offset$arr := add(calldata_offset$arr, 32)
let calldata_offset$arr_init := calldata_offset$arr

for { let arrcalldata_offset$_i := 0 } lt(arrcalldata_offset$_i, calldata_offset$arr_length) { arrcalldata_offset$_i := add(arrcalldata_offset$_i, 1) } {
  mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$arrarr := add(calldata_offset$arr_init, calldataload(calldata_offset$arr))

let calldata_offset$arrarr_length := calldataload(calldata_offset$arrarr)
mstore(memory_offset$, calldata_offset$arrarr_length)
memory_offset$ := add(memory_offset$, 32)
calldata_offset$arrarr := add(calldata_offset$arrarr, 32)
let calldata_offset$arrarr_init := calldata_offset$arrarr

for { let arrcalldata_offset$arr_i := 0 } lt(arrcalldata_offset$arr_i, calldata_offset$arrarr_length) { arrcalldata_offset$arr_i := add(arrcalldata_offset$arr_i, 1) } {
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$arrarr))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$arrarr := add(calldata_offset$arrarr, 32)

}

calldata_offset$arr := add(calldata_offset$arr, 32)

}

calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := arr_test(arr)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)
let where_to_store_head$_$ := processed_return_value$
let where_to_store_head_init$_$ := where_to_store_head$_$

processed_return_value$ := add(processed_return_value$, mul(size$, 32))

for { let i$ := 0 } lt(i$, size$) { i$ := add(i$, 1) } {
// for { let i$ := 0 } lt(i$, 2) { i$ := add(i$, 1) } {
  switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$_ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(where_to_store_head$_$, sub(processed_return_value$, where_to_store_head_init$_$))
where_to_store_head$_$ := add(where_to_store_head$_$, 32)

mstore(processed_return_value$, size$_)
processed_return_value$ := add(processed_return_value$, 32)
let where_to_store_head$_$_$ := processed_return_value$
let where_to_store_head_init$_$_$ := where_to_store_head$_$_$

processed_return_value$ := add(processed_return_value$, mul(size$_, 32))

for { let i$_ := 0 } lt(i$_, size$_) { i$_ := add(i$_, 1) } {
// for { let i$_ := 0 } lt(i$_, 2) { i$_ := add(i$_, 1) } {
  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$_$_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$_$_$ := add(where_to_store_head$_$_$, 32)

}

}

return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0xdc9905ae {
  let calldata_offset$ := 4
  let memory_offset$ := 0
    let arr := memory_offset$
  mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$arr := add(calldata_offset$, calldataload(calldata_offset$))

let calldata_offset$arr_length := calldataload(calldata_offset$arr)
mstore(memory_offset$, calldata_offset$arr_length)
memory_offset$ := add(memory_offset$, 32)
calldata_offset$arr := add(calldata_offset$arr, 32)
let calldata_offset$arr_init := calldata_offset$arr

for { let arrcalldata_offset$_i := 0 } lt(arrcalldata_offset$_i, calldata_offset$arr_length) { arrcalldata_offset$_i := add(arrcalldata_offset$_i, 1) } {
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$arr))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$arr := add(calldata_offset$arr, 32)

}

calldata_offset$ := add(calldata_offset$, 32)


  let return_value$ := arr_test_1(arr)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$ := mload(return_value$)
return_value$ := add(return_value$, 32)

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)

mstore(processed_return_value$, size$)
processed_return_value$ := add(processed_return_value$, 32)
let where_to_store_head$_$ := processed_return_value$
let where_to_store_head_init$_$ := where_to_store_head$_$

processed_return_value$ := add(processed_return_value$, mul(size$, 32))

for { let i$ := 0 } lt(i$, size$) { i$ := add(i$, 1) } {
// for { let i$ := 0 } lt(i$, 2) { i$ := add(i$, 1) } {
  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$_$ := add(where_to_store_head$_$, 32)

}

return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}
case 0x2e64cec1 {
  let calldata_offset$ := 4
  let memory_offset$ := 0
  
  let return_value$ := retrieve()

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



      function store(num, fake_num) -> return_value$ {
  let offset$ := msize()
  
let test := abc(num)

  
  sstore(0, take_32_bytes$(mload(add(test, 1))))
}
function arr_test(arr) -> return_value$ {
  let offset$ := msize()
  
  
  return_value$ := arr
}
function arr_test_1(arr) -> return_value$ {
  let offset$ := msize()
  
  
  return_value$ := arr
}
function retrieve() -> return_value$ {
  let offset$ := msize()
  
  mstore8(add(0, offset$), 67)
mstore(add(1, offset$), sload(0))

  return_value$ := add(0, offset$)
}
function abc(qwe) -> return_value$ {
  let offset$ := msize()
  
  
mstore8(add(0, offset$), 67)
mstore(add(1, offset$), 1)


  return_value$ := add$(add$(qwe, add(0, offset$)), get_0())
}
function get_0() -> return_value$ {
  let offset$ := msize()
  
  mstore8(add(0, offset$), 67)
mstore(add(1, offset$), 100)

  return_value$ := add(0, offset$)
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

function take_23_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_31_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_2_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFF)
}

function take_8_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFF)
}

function take_27_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_22_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_26_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_28_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_24_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_17_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_30_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_32_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_10_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFF)
}

function take_4_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFF)
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

function take_29_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_6_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFF)
}

function take_5_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFF)
}

function take_11_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFF)
}

function take_16_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_18_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_20_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_3_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFF)
}

function take_13_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_15_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_25_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_1_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFF)
}

function take_19_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_12_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_21_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_14_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_9_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFF)
}

function take_7_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFF)
}

    }
  }
}
