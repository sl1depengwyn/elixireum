object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
    let method_id := shr(0xe0, calldataload(0x0))
    switch method_id
      case 0x3e738e11 {
        
        let return_value := retrieve()
        mstore(0, return_value)
return(0, 32)

       let a := retrieve()
      }
      case 0xe41d8871 {
        let num := calldataload(add(4, 0))
let fake_num := calldataload(add(4, 32))

        let return_value := store(num,fake_num)
        return(0, 0)

      }



    function retrieve() -> return_value {

      


      return_value := sload(0x0db4ef449fd88e4ee42eed3709a81b61fe6183b9a5319f4b852e9231d9406849)

    }
    function store(num, fake_num) -> return_value {

      let test := 123
sstore(0x0db4ef449fd88e4ee42eed3709a81b61fe6183b9a5319f4b852e9231d9406849, 12332322)



      sstore(0x0db4ef449fd88e4ee42eed3709a81b61fe6183b9a5319f4b852e9231d9406849, num)

    }


    function abc(qwe) -> return_value {

      


      return_value := a
      return_value := qwe
    }

  }
}
}
