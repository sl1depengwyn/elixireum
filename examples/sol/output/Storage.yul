
/// @use-src 0:"sources/storage.sol"
object "Storage_60" {
    code {
        /// @src 0:224:847  "contract Storage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1, _2 := copy_arguments_for_constructor_23_object_Storage_60()
        constructor_Storage_60(_1, _2)

        let _3 := allocate_unbounded()
        codecopy(_3, dataoffset("Storage_60_deployed"), datasize("Storage_60_deployed"))

        return(_3, datasize("Storage_60_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
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

        function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
            revert(0, 0)
        }

        function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
            revert(0, 0)
        }

        function cleanup_t_uint256(value) -> cleaned {
            cleaned := value
        }

        function validator_revert_t_uint256(value) {
            if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
        }

        function abi_decode_t_uint256_fromMemory(offset, end) -> value {
            value := mload(offset)
            validator_revert_t_uint256(value)
        }

        function cleanup_t_bool(value) -> cleaned {
            cleaned := iszero(iszero(value))
        }

        function validator_revert_t_bool(value) {
            if iszero(eq(value, cleanup_t_bool(value))) { revert(0, 0) }
        }

        function abi_decode_t_bool_fromMemory(offset, end) -> value {
            value := mload(offset)
            validator_revert_t_bool(value)
        }

        function abi_decode_tuple_t_uint256t_bool_fromMemory(headStart, dataEnd) -> value0, value1 {
            if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            {

                let offset := 0

                value0 := abi_decode_t_uint256_fromMemory(add(headStart, offset), dataEnd)
            }

            {

                let offset := 32

                value1 := abi_decode_t_bool_fromMemory(add(headStart, offset), dataEnd)
            }

        }

        function copy_arguments_for_constructor_23_object_Storage_60() -> ret_param_0, ret_param_1 {
            let programSize := datasize("Storage_60")
            let argSize := sub(codesize(), programSize)

            let memoryDataOffset := allocate_memory(argSize)
            codecopy(memoryDataOffset, programSize, argSize)

            ret_param_0, ret_param_1 := abi_decode_tuple_t_uint256t_bool_fromMemory(memoryDataOffset, add(memoryDataOffset, argSize))
        }

        function shift_left_0(value) -> newValue {
            newValue :=

            shl(0, value)

        }

        function update_byte_slice_1_shift_0(value, toInsert) -> result {
            let mask := 255
            toInsert := shift_left_0(toInsert)
            value := and(value, not(mask))
            result := or(value, and(toInsert, mask))
        }

        function convert_t_bool_to_t_bool(value) -> converted {
            converted := cleanup_t_bool(value)
        }

        function prepare_store_t_bool(value) -> ret {
            ret := value
        }

        function update_storage_value_offset_0t_bool_to_t_bool(slot, value_0) {
            let convertedValue_0 := convert_t_bool_to_t_bool(value_0)
            sstore(slot, update_byte_slice_1_shift_0(sload(slot), prepare_store_t_bool(convertedValue_0)))
        }

        function update_byte_slice_32_shift_0(value, toInsert) -> result {
            let mask := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            toInsert := shift_left_0(toInsert)
            value := and(value, not(mask))
            result := or(value, and(toInsert, mask))
        }

        function cleanup_t_rational_100_by_1(value) -> cleaned {
            cleaned := value
        }

        function cleanup_t_uint16(value) -> cleaned {
            cleaned := and(value, 0xffff)
        }

        function identity(value) -> ret {
            ret := value
        }

        function convert_t_rational_100_by_1_to_t_uint16(value) -> converted {
            converted := cleanup_t_uint16(identity(cleanup_t_rational_100_by_1(value)))
        }

        function prepare_store_t_uint16(value) -> ret {
            ret := value
        }

        function update_storage_value_offset_0t_rational_100_by_1_to_t_uint16(slot, value_0) {
            let convertedValue_0 := convert_t_rational_100_by_1_to_t_uint16(value_0)
            sstore(slot, update_byte_slice_2_shift_0(sload(slot), prepare_store_t_uint16(convertedValue_0)))
        }

        /// @ast-id 23
        /// @src 0:283:375  "constructor(uint256 num, bool fake) public {..."
        function constructor_Storage_60(var_num_9, var_fake_11) {

            /// @src 0:283:375  "constructor(uint256 num, bool fake) public {..."

            /// @src 0:342:346  "fake"
            let _4 := var_fake_11
            let expr_15 := _4
            /// @src 0:336:346  "asd = fake"
            update_storage_value_offset_0t_bool_to_t_bool(0x01, expr_15)
            let expr_16 := expr_15
            /// @src 0:365:368  "num"
            let _5 := var_num_9
            let expr_19 := _5
            /// @src 0:356:368  "number = num"
            update_storage_value_offset_0t_uint256_to_t_uint256(0x00, expr_19)
            let expr_20 := expr_19

        }
        /// @src 0:224:847  "contract Storage {..."

    }
    /// @use-src 0:"sources/storage.sol"
    object "Storage_60_deployed" {
        code {
            /// @src 0:224:847  "contract Storage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x4315a5eb
                {
                    // qwe()

                    external_fun_qwe_59()
                }

                case 0x6057361d
                {
                    // qwe()

                    external_fun_store_34()
                }

                case 0xa9bda418
                {
                    // storeblabla(uint16)

                    external_fun_retrieve_51()
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

            function abi_decode_tuple_(headStart, dataEnd)   {
                if slt(sub(dataEnd, headStart), 0) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            }

            function cleanup_t_bool(value) -> cleaned {
                cleaned := iszero(iszero(value))
            }

            function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
                mstore(pos, cleanup_t_bool(value))
            }

            function abi_encode_tuple_t_bool__to_t_bool__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_bool_to_t_bool_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_qwe_59() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_qwe_59()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bool__to_t_bool__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
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

            function abi_decode_tuple_t_uint16(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint16(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_store_34() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_store_34(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function abi_encode_t_uint16_to_t_uint16_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint16(value))
            }

            function abi_encode_tuple_t_uint16__to_t_uint16__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint16_to_t_uint16_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_retrieve_51() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_retrieve_51(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint16__to_t_uint16__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_bool() -> ret {
                ret := 0
            }

            /// @ast-id 59
            /// @src 0:780:845  "function qwe() public returns (bool) {..."
            function fun_qwe_59() -> var__54 {
                /// @src 0:811:815  "bool"
                let zero_t_bool_1 := zero_value_for_split_t_bool()
                var__54 := zero_t_bool_1

                /// @src 0:834:838  "true"
                let expr_56 := 0x01
                /// @src 0:827:838  "return true"
                var__54 := expr_56
                leave

            }
            /// @src 0:224:847  "contract Storage {..."

            function shift_left_0(value) -> newValue {
                newValue :=

                shl(0, value)

            }

            function update_byte_slice_2_shift_0(value, toInsert) -> result {
                let mask := 65535
                toInsert := shift_left_0(toInsert)
                value := and(value, not(mask))
                result := or(value, and(toInsert, mask))
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_uint16_to_t_uint16(value) -> converted {
                converted := cleanup_t_uint16(identity(cleanup_t_uint16(value)))
            }

            function prepare_store_t_uint16(value) -> ret {
                ret := value
            }

            function update_storage_value_offset_0t_uint16_to_t_uint16(slot, value_0) {
                let convertedValue_0 := convert_t_uint16_to_t_uint16(value_0)
                sstore(slot, update_byte_slice_2_shift_0(sload(slot), prepare_store_t_uint16(convertedValue_0)))
            }

            /// @ast-id 34
            /// @src 0:471:535  "function store(uint256 num) public {..."
            function fun_store_34(var_num_26) {

                /// @src 0:525:528  "num"
                let _2 := var_num_26
                let expr_30 := _2
                /// @src 0:516:528  "number = num"
                update_storage_value_offset_0t_uint256_to_t_uint256(0x00, expr_30)
                let expr_31 := expr_30

            }
            /// @src 0:224:847  "contract Storage {..."

            function zero_value_for_split_t_uint16() -> ret {
                ret := 0
            }

            function shift_right_0_unsigned(value) -> newValue {
                newValue :=

                shr(0, value)

            }

            function cleanup_from_storage_t_bool(value) -> cleaned {
                cleaned := and(value, 0xff)
            }

            function extract_from_storage_value_offset_0t_bool(slot_value) -> value {
                value := cleanup_from_storage_t_bool(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_bool(slot) -> value {
                value := extract_from_storage_value_offset_0t_bool(sload(slot))

            }

            function cleanup_from_storage_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function extract_from_storage_value_offset_0t_uint256(slot_value) -> value {
                value := cleanup_from_storage_t_uint256(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_uint256(slot) -> value {
                value := extract_from_storage_value_offset_0t_uint256(sload(slot))

            }

            function cleanup_t_rational_234_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_234_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_234_by_1(value)))
            }

            /// @ast-id 51
            /// @src 0:616:774  "function retrieve(uint256 a) public returns (uint256) {..."
            function fun_retrieve_51(var_a_37) -> var__40 {
                /// @src 0:661:668  "uint256"
                let zero_t_uint256_3 := zero_value_for_split_t_uint256()
                var__40 := zero_t_uint256_3

                /// @src 0:684:687  "asd"
                let _4 := read_from_storage_split_offset_0_t_bool(0x01)
                let expr_42 := _4
                /// @src 0:680:768  "if (asd) {..."
                switch expr_42
                case 0 {
                    /// @src 0:751:757  "number"
                    let _5 := read_from_storage_split_offset_0_t_uint256(0x00)
                    let expr_46 := _5
                    /// @src 0:744:757  "return number"
                    var__40 := expr_46
                    leave
                    /// @src 0:680:768  "if (asd) {..."
                }
                default {
                    /// @src 0:710:713  "234"
                    let expr_43 := 0xea
                    /// @src 0:703:713  "return 234"
                    var__40 := convert_t_rational_234_by_1_to_t_uint256(expr_43)
                    leave
                    /// @src 0:680:768  "if (asd) {..."
                }

            }
            /// @src 0:224:847  "contract Storage {..."

        }

        data ".metadata" hex"a2646970667358221220670c7c884ee045f9c971aeb708dfbd76ca29e2226b921e949b75481d35fd49f264736f6c63430008180033"
    }

}

