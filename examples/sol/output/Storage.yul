
/// @use-src 0:"sources/array.sol"
object "Storage_34" {
    code {
        /// @src 0:199:422  "contract Storage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_Storage_34()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Storage_34_deployed"), datasize("Storage_34_deployed"))

        return(_1, datasize("Storage_34_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:199:422  "contract Storage {..."
        function constructor_Storage_34() {

            /// @src 0:199:422  "contract Storage {..."

        }
        /// @src 0:199:422  "contract Storage {..."

    }
    /// @use-src 0:"sources/array.sol"
    object "Storage_34_deployed" {
        code {
            /// @src 0:199:422  "contract Storage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0xf1f8caa4
                {
                    // qwe(uint16[])

                    external_fun_qwe_33()
                }

                default {}
            }

            revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74()

            function shift_right_224_unsigned(value) -> newValue {
                newValue :=

                shr(224, value)

            }

            function allocate_unbounded() -> memPtr {
                memPtr := mload(64)
            }

            function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
                revert(0, 0)
            }

            function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
                revert(0, 0)
            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
                revert(0, 0)
            }

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
            }

            function round_up_to_mul_of_32(value) -> result {
                result := and(add(value, 31), not(31))
            }

            function panic_error_0x41() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x41)
                revert(0, 0x24)
            }

            function finalize_allocation(memPtr, size) {
                let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
                // protect against overflow
                if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
                mstore(64, newFreePtr)
            }

            function allocate_memory(size) -> memPtr {
                memPtr := allocate_unbounded()
                finalize_allocation(memPtr, size)
            }

            function array_allocation_size_t_array$_t_uint16_$dyn_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := mul(length, 0x20)

                // add length slot
                size := add(size, 0x20)

            }

            function revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() {
                revert(0, 0)
            }

            function cleanup_t_uint16(value) -> cleaned {
                cleaned := and(value, 0xffff)
            }

            function validator_revert_t_uint16(value) {
                if iszero(eq(value, cleanup_t_uint16(value))) { revert(0, 0) }
            }

            function abi_decode_t_uint16(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_uint16(value)
            }

            // uint16[]
            function abi_decode_available_length_t_array$_t_uint16_$dyn_memory_ptr(offset, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_array$_t_uint16_$dyn_memory_ptr(length))
                let dst := array

                mstore(array, length)
                dst := add(array, 0x20)

                let srcEnd := add(offset, mul(length, 0x20))
                if gt(srcEnd, end) {
                    revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef()
                }
                for { let src := offset } lt(src, srcEnd) { src := add(src, 0x20) }
                {

                    let elementPos := src

                    mstore(dst, abi_decode_t_uint16(elementPos, end))
                    dst := add(dst, 0x20)
                }
            }

            // uint16[]
            function abi_decode_t_array$_t_uint16_$dyn_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_array$_t_uint16_$dyn_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_array$_t_uint16_$dyn_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_array$_t_uint16_$dyn_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function array_length_t_array$_t_uint16_$dyn_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_array$_t_uint16_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function array_dataslot_t_array$_t_uint16_$dyn_memory_ptr(ptr) -> data {
                data := ptr

                data := add(ptr, 0x20)

            }

            function abi_encode_t_uint16_to_t_uint16(value, pos) {
                mstore(pos, cleanup_t_uint16(value))
            }

            function abi_encodeUpdatedPos_t_uint16_to_t_uint16(value0, pos) -> updatedPos {
                abi_encode_t_uint16_to_t_uint16(value0, pos)
                updatedPos := add(pos, 0x20)
            }

            function array_nextElement_t_array$_t_uint16_$dyn_memory_ptr(ptr) -> next {
                next := add(ptr, 0x20)
            }

            // uint16[] -> uint16[]
            function abi_encode_t_array$_t_uint16_$dyn_memory_ptr_to_t_array$_t_uint16_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
                let length := array_length_t_array$_t_uint16_$dyn_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_array$_t_uint16_$dyn_memory_ptr_fromStack(pos, length)
                let baseRef := array_dataslot_t_array$_t_uint16_$dyn_memory_ptr(value)
                let srcPtr := baseRef
                for { let i := 0 } lt(i, length) { i := add(i, 1) }
                {
                    let elementValue0 := mload(srcPtr)
                    pos := abi_encodeUpdatedPos_t_uint16_to_t_uint16(elementValue0, pos)
                    srcPtr := array_nextElement_t_array$_t_uint16_$dyn_memory_ptr(srcPtr)
                }
                end := pos
            }

            function abi_encode_tuple_t_array$_t_uint16_$dyn_memory_ptr__to_t_array$_t_uint16_$dyn_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_array$_t_uint16_$dyn_memory_ptr_to_t_array$_t_uint16_$dyn_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_qwe_33() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_array$_t_uint16_$dyn_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_qwe_33(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_array$_t_uint16_$dyn_memory_ptr__to_t_array$_t_uint16_$dyn_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_array$_t_uint16_$dyn_memory_ptr() -> ret {
                ret := 96
            }

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint16(value) -> converted {
                converted := cleanup_t_uint16(identity(cleanup_t_rational_0_by_1(value)))
            }

            function panic_error_0x11() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x11)
                revert(0, 0x24)
            }

            function increment_t_uint16(value) -> ret {
                value := cleanup_t_uint16(value)
                if eq(value, 0xffff) { panic_error_0x11() }
                ret := add(value, 1)
            }

            function cleanup_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function convert_t_uint16_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_uint16(value)))
            }

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1_by_1_to_t_uint16(value) -> converted {
                converted := cleanup_t_uint16(identity(cleanup_t_rational_1_by_1(value)))
            }

            function panic_error_0x32() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x32)
                revert(0, 0x24)
            }

            function memory_array_index_access_t_array$_t_uint16_$dyn_memory_ptr(baseRef, index) -> addr {
                if iszero(lt(index, array_length_t_array$_t_uint16_$dyn_memory_ptr(baseRef))) {
                    panic_error_0x32()
                }

                let offset := mul(index, 32)

                offset := add(offset, 32)

                addr := add(baseRef, offset)
            }

            function read_from_memoryt_uint16(ptr) -> returnValue {

                let value := cleanup_t_uint16(mload(ptr))

                returnValue :=

                value

            }

            function checked_add_t_uint16(x, y) -> sum {
                x := cleanup_t_uint16(x)
                y := cleanup_t_uint16(y)
                sum := add(x, y)

                if gt(sum, 0xffff) { panic_error_0x11() }

            }

            function write_to_memory_t_uint16(memPtr, value) {
                mstore(memPtr, cleanup_t_uint16(value))
            }

            /// @ast-id 33
            /// @src 0:223:420  "function qwe(uint16[] memory qbe) public returns (uint16[] memory) {..."
            function fun_qwe_33(var_qbe_5_mpos) -> var__9_mpos {
                /// @src 0:273:288  "uint16[] memory"
                let zero_t_array$_t_uint16_$dyn_memory_ptr_1_mpos := zero_value_for_split_t_array$_t_uint16_$dyn_memory_ptr()
                var__9_mpos := zero_t_array$_t_uint16_$dyn_memory_ptr_1_mpos

                /// @src 0:300:376  "for (uint16 i = 0; i < qbe.length; i++) {..."
                for {
                    /// @src 0:316:317  "0"
                    let expr_13 := 0x00
                    /// @src 0:305:317  "uint16 i = 0"
                    let var_i_12 := convert_t_rational_0_by_1_to_t_uint16(expr_13)
                    } 1 {
                    /// @src 0:335:338  "i++"
                    let _3 := var_i_12
                    let _2 := increment_t_uint16(_3)
                    var_i_12 := _2
                    let expr_20 := _3
                }
                {
                    /// @src 0:319:320  "i"
                    let _4 := var_i_12
                    let expr_15 := _4
                    /// @src 0:323:326  "qbe"
                    let _5_mpos := var_qbe_5_mpos
                    let expr_16_mpos := _5_mpos
                    /// @src 0:323:333  "qbe.length"
                    let expr_17 := array_length_t_array$_t_uint16_$dyn_memory_ptr(expr_16_mpos)
                    /// @src 0:319:333  "i < qbe.length"
                    let expr_18 := lt(convert_t_uint16_to_t_uint256(expr_15), cleanup_t_uint256(expr_17))
                    if iszero(expr_18) { break }
                    /// @src 0:364:365  "1"
                    let expr_25 := 0x01
                    /// @src 0:354:365  "qbe[i] += 1"
                    let _6 := convert_t_rational_1_by_1_to_t_uint16(expr_25)
                    /// @src 0:354:357  "qbe"
                    let _7_mpos := var_qbe_5_mpos
                    let expr_22_mpos := _7_mpos
                    /// @src 0:358:359  "i"
                    let _8 := var_i_12
                    let expr_23 := _8
                    /// @src 0:354:365  "qbe[i] += 1"
                    let _9 := read_from_memoryt_uint16(memory_array_index_access_t_array$_t_uint16_$dyn_memory_ptr(expr_22_mpos, convert_t_uint16_to_t_uint256(expr_23)))
                    let expr_26 := checked_add_t_uint16(_9, _6)

                    let _10 := expr_26
                    write_to_memory_t_uint16(memory_array_index_access_t_array$_t_uint16_$dyn_memory_ptr(expr_22_mpos, convert_t_uint16_to_t_uint256(expr_23)), _10)
                }
                /// @src 0:410:413  "qbe"
                let _11_mpos := var_qbe_5_mpos
                let expr_30_mpos := _11_mpos
                /// @src 0:403:413  "return qbe"
                var__9_mpos := expr_30_mpos
                leave

            }
            /// @src 0:199:422  "contract Storage {..."

        }

        data ".metadata" hex"a264697066735822122088f413d14addbe8f4b56541da67be72de18c75471fe19ffee9bb44fbbc2aba6764736f6c63430008180033"
    }

}

