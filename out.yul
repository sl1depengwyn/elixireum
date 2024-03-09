object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      let method_id := shr(0xe0, calldataload(0x0))
switch method_id
case 0x6ed28ed0 {
  let num := calldataload(add(4, 0))
let fake_num := calldataload(add(4, 32))

  let return_value := store(num,fake_num)
return(0, 0)

}
case 0x2e64cec1 {
  
  let return_value := retrieve()
mstore(0, return_value)
return(0, 32)

}



      function store(num, fake_num) -> return_value {
  let test := abc(1)

  sstore(1, test)
}
function retrieve() -> return_value {
  


  return_value := sload(1)
}


      function abc(qwe) -> return_value {
  let _ := get_0()


  return_value := get_0()
}
function get_0() -> return_value {
  


  return_value := 100
}

    }
  }
}
