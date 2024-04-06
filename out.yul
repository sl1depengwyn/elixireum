object "contract" {
  code {
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      let method_id := shr(0xe0, calldataload(0x0))
switch method_id



      

      function a() -> return_value {
  


  return_value := LIST TO IMPLEMENT
}

    }
  }
}
