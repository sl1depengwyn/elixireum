object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
    let method_id := shr(0xe0, calldataload(0x0))
    switch method_id
      case 0xe41d8871 {
        let num := calldataload(add(4, 0))
let fake_num := calldataload(add(4, 32))

        let return_value := store(num,fake_num)
        return(0, 0)

      }
      case 0x3e738e11 {
        
        let return_value := retrieve()
        mstore(0, return_value)
return(0, 32)

      }



    function store(num, fake_num) -> return_value {

      IGNORED111
IGNORED111

      IGNORED111
    }
    function retrieve() -> return_value {

      

      IGNORED111
    }


    function abc(qwe) -> return_value {

      

      IGNORED111
    }

  }
}
}
