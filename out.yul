object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      let method_id := shr(0xe0, calldataload(0x0))
switch method_id
case 0xd33f752c {
  let calldata_offset$ := 4
let init_calldata_offset$ := calldata_offset$
let memory_offset$ := 0
  let tuple := memory_offset$
  mstore8(memory_offset$, 3)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, 4)
memory_offset$ := add(memory_offset$, 32)

let calldata_offset$$tuple := add(init_calldata_offset$, calldataload(calldata_offset$))


let init_calldata_offset$$tuple_init := calldata_offset$$tuple

mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$$tuple))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$$tuple := add(calldata_offset$$tuple, 32)
mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$$tuple$tuple1 := add(init_calldata_offset$$tuple_init, calldataload(calldata_offset$$tuple))

let calldata_offset$$tuple$tuple1length := calldataload(calldata_offset$$tuple$tuple1)
calldata_offset$$tuple$tuple1 := add(calldata_offset$$tuple$tuple1, 32)


mstore(memory_offset$, calldata_offset$$tuple$tuple1length)
memory_offset$ := add(memory_offset$, 32)

let init_calldata_offset$$tuple_init$tuple1init := calldata_offset$$tuple$tuple1

for { let tuple1$init_calldata_offset$$tuple_initi := 0 } lt(tuple1$init_calldata_offset$$tuple_initi, calldata_offset$$tuple$tuple1length) { tuple1$init_calldata_offset$$tuple_initi := add(tuple1$init_calldata_offset$$tuple_initi, 1) } {
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$$tuple$tuple1))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$$tuple$tuple1 := add(calldata_offset$$tuple$tuple1, 32)

}

calldata_offset$$tuple := add(calldata_offset$$tuple, 32)
mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

mstore(memory_offset$, 2)
memory_offset$ := add(memory_offset$, 32)

let calldata_offset$$tuple$tuple2init := calldata_offset$$tuple

for { let tuple2$calldata_offset$$tuplei := 0 } lt(tuple2$calldata_offset$$tuplei, 2) { tuple2$calldata_offset$$tuplei := add(tuple2$calldata_offset$$tuplei, 1) } {
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$$tuple))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$$tuple := add(calldata_offset$$tuple, 32)

}
mstore8(memory_offset$, 103)
memory_offset$ := add(memory_offset$, 1)

let calldata_offset$$tuple$tuple3 := add(init_calldata_offset$$tuple_init, calldataload(calldata_offset$$tuple))

let calldata_offset$$tuple$tuple3length := calldataload(calldata_offset$$tuple$tuple3)
calldata_offset$$tuple$tuple3 := add(calldata_offset$$tuple$tuple3, 32)


mstore(memory_offset$, calldata_offset$$tuple$tuple3length)
memory_offset$ := add(memory_offset$, 32)

let init_calldata_offset$$tuple_init$tuple3init := calldata_offset$$tuple$tuple3

for { let tuple3$init_calldata_offset$$tuple_initi := 0 } lt(tuple3$init_calldata_offset$$tuple_initi, calldata_offset$$tuple$tuple3length) { tuple3$init_calldata_offset$$tuple_initi := add(tuple3$init_calldata_offset$$tuple_initi, 1) } {
  mstore8(memory_offset$, 67)
memory_offset$ := add(memory_offset$, 1)
mstore(memory_offset$, calldataload(calldata_offset$$tuple$tuple3))
memory_offset$ := add(memory_offset$, 32)
calldata_offset$$tuple$tuple3 := add(calldata_offset$$tuple$tuple3, 32)

}

calldata_offset$$tuple := add(calldata_offset$$tuple, 32)



  let return_value$ := hard_tuple(tuple)

  let processed_return_value$ := msize()
let processed_return_value_init$ := processed_return_value$
let where_to_store_head$ := processed_return_value$
let where_to_store_head_init$ := where_to_store_head$
processed_return_value$ := add(processed_return_value$, 32)
switch byte(0, mload(return_value$))
  case 3 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
switch mload(return_value$)
  case 4 {}
  default {
    // Return type mismatch length tuple
    revert(0, 0)
  }

return_value$ := add(return_value$, 32)

let where_to_store_head$i$_$ := processed_return_value$
let where_to_store_head_init$i$_$ := where_to_store_head$i$_$

mstore(where_to_store_head$, sub(processed_return_value$, where_to_store_head_init$))
where_to_store_head$ := add(where_to_store_head$, 32)
processed_return_value$ := add(processed_return_value$, 160)


switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$i$_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$i$_$ := add(where_to_store_head$i$_$, 32)
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$1 := mload(return_value$)
return_value$ := add(return_value$, 32)



mstore(where_to_store_head$i$_$, sub(processed_return_value$, where_to_store_head_init$i$_$))
where_to_store_head$i$_$ := add(where_to_store_head$i$_$, 32)

mstore(processed_return_value$, size$1)
processed_return_value$ := add(processed_return_value$, 32)


let where_to_store_head$i$_$i$1_$ := processed_return_value$
let where_to_store_head_init$i$_$i$1_$ := where_to_store_head$i$_$i$1_$

processed_return_value$ := add(processed_return_value$, mul(size$1, 32))

for { let i$1 := 0 } lt(i$1, size$1) { i$1 := add(i$1, 1) } {
// for { let i$1 := 0 } lt(i$1, 2) { i$1 := add(i$1, 1) } {
  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$i$_$i$1_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$i$_$i$1_$ := add(where_to_store_head$i$_$i$1_$, 32)

}
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)
let size$2 := mload(return_value$)

switch size$2
  case 2 {}
  default {
    // Array size mismatch
    revert(0, 0)
  }

return_value$ := add(return_value$, 32)

for { let i$2 := 0 } lt(i$2, size$2) { i$2 := add(i$2, 1) } {
//for { let i$2 := 0 } lt(i$2, 2) { i$2 := add(i$2, 1) } {

  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$i$_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$i$_$ := add(where_to_store_head$i$_$, 32)

}
switch byte(0, mload(return_value$))
  case 103 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }
return_value$ := add(return_value$, 1)

let size$3 := mload(return_value$)
return_value$ := add(return_value$, 32)



mstore(where_to_store_head$i$_$, sub(processed_return_value$, where_to_store_head_init$i$_$))
where_to_store_head$i$_$ := add(where_to_store_head$i$_$, 32)

mstore(processed_return_value$, size$3)
processed_return_value$ := add(processed_return_value$, 32)


let where_to_store_head$i$_$i$3_$ := processed_return_value$
let where_to_store_head_init$i$_$i$3_$ := where_to_store_head$i$_$i$3_$

processed_return_value$ := add(processed_return_value$, mul(size$3, 32))

for { let i$3 := 0 } lt(i$3, size$3) { i$3 := add(i$3, 1) } {
// for { let i$3 := 0 } lt(i$3, 2) { i$3 := add(i$3, 1) } {
  switch byte(0, mload(return_value$))
  case 67 {}
  default {
    // Return type mismatch abi
    revert(0, 0)
  }

return_value$ := add(return_value$, 1)
mstore(where_to_store_head$i$_$i$3_$, mload(return_value$))
return_value$ := add(return_value$, 32)
where_to_store_head$i$_$i$3_$ := add(where_to_store_head$i$_$i$3_$, 32)

}


return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))

}

default {revert(0, 0)}


      function hard_tuple(tuple) -> return_value$ {
  let offset$ := msize()
  
  
  return_value$ := tuple
}

    }
  }
}
