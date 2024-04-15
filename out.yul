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
  let num_offset := msize()
mstore8(num_offset, 67)
mstore(add(1, num_offset), calldataload(add(4, 0)))
let num := num_offset
let fake_num_offset := msize()
mstore8(fake_num_offset, 67)
mstore(add(1, fake_num_offset), calldataload(add(4, 32)))
let fake_num := fake_num_offset

  let return_value := store(num,fake_num)
  return(0, 0)
}
case 0xfc040071 {
  let arr_offset := msize()
let arr := arr_offset
mstore8(arr_offset, 103)

let arr_calldata_offset := add(4, calldataload(4))
let arr_size := calldataload(arr_calldata_offset)
mstore(add(1, arr_offset), arr_size)

for { let i := 1 } lt(i, add(1, arr_size)) { i := add(i, 1) } {
  mstore8(add(arr_offset, mul(i, 33)), 67)
  mstore(add(add(1, arr_offset), mul(i, 33)), calldataload(add(arr_calldata_offset, mul(i, 32))))
}

  let return_value := arr_test(arr)
  switch byte(0, mload(return_value))
 case 103 {}
 default {
   // Return type mismatch abi
   revert(0, 0)
 }

let ptr := add(return_value, 1)
let size := mload(ptr)

ptr := add(ptr, 32)

let offset := msize()
let init_offset := offset
mstore(offset, 32)
mstore(add(offset, 32), size)
offset := add(offset, 64)

for { let i := 0 } lt(i, size) { i := add(i, 1) } {
 let type := byte(0, mload(ptr))

 switch type
   case 67 {}
   default {
     // Array item's type mismatch
     revert(0, 0)
   }

 let value := mload(add(ptr, 1))

 ptr := add(ptr, 33)

 mstore(add(offset, mul(i, 32)), value)
}

return(init_offset, mul(add(size, 2), 32))

}
case 0x2e64cec1 {
  
  let return_value := retrieve()
  if not(eq(byte(0, mload(return_value)), 67)) {
  // Return type mismatch abi
  revert (0, 0)
}

return(add(return_value, 1), 32)

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
function take_32_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_31_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_30_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_29_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_28_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_27_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_26_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_25_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_24_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_23_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_22_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_21_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_20_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_19_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_18_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_17_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_16_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_15_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_14_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_13_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_12_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFF)
}

function take_11_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFFFF)
}

function take_10_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFFFF)
}

function take_9_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFFFF)
}

function take_8_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFFFF)
}

function take_7_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFFFF)
}

function take_6_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFFFF)
}

function take_5_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFFFF)
}

function take_4_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFFFF)
}

function take_3_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFFFF)
}

function take_2_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFFFF)
}

function take_1_bytes$(value) -> return_value$ {
  return_value$ := and(value, 0xFF)
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

    }
  }
}
