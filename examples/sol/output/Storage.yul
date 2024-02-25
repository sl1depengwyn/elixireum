
/// @use-src 0:"sources/storage.sol"
object "Storage_39" {
    code {
        /// @src 0:199:680  "contract Storage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_Storage_39()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Storage_39_deployed"), datasize("Storage_39_deployed"))

        return(_1, datasize("Storage_39_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

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

        /// @src 0:199:680  "contract Storage {..."
        function constructor_Storage_39() {

            /// @src 0:199:680  "contract Storage {..."

            /// @src 0:239:242  "100"
            let expr_4 := 0x64
            update_storage_value_offset_0t_rational_100_by_1_to_t_uint16(0x00, expr_4)

        }
        /// @src 0:199:680  "contract Storage {..."

    }
    /// @use-src 0:"sources/storage.sol"
    object "Storage_39_deployed" {
        code {
            /// @src 0:199:680  "contract Storage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x4315a5eb
                {
                    // qwe()

                    external_fun_qwe_29()
                }

                case 0xa9bda418
                {
                    // storeblabla(uint16)

                    external_fun_storeblabla_16()
                }

                case 0xfdd8901d
                {
                    // retrieveBlaBla()

                    external_fun_retrieveBlaBla_38()
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

            function external_fun_qwe_29() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_qwe_29()
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

            function external_fun_storeblabla_16() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint16(4, calldatasize())
                fun_storeblabla_16(param_0)
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

            function external_fun_retrieveBlaBla_38() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_retrieveBlaBla_38()
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

            /// @ast-id 29
            /// @src 0:409:513  "function qwe() public returns (bool) {..."
            function fun_qwe_29() -> var__19 {
                /// @src 0:440:444  "bool"
                let zero_t_bool_1 := zero_value_for_split_t_bool()
                var__19 := zero_t_bool_1

                /// @src 0:468:484  "retrieveBlaBla()"
                let expr_23 := fun_retrieveBlaBla_38()
                fun_storeblabla_16(expr_23)
                /// @src 0:502:506  "true"
                let expr_26 := 0x01
                /// @src 0:495:506  "return true"
                var__19 := expr_26
                leave

            }
            /// @src 0:199:680  "contract Storage {..."

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

            /// @ast-id 16
            /// @src 0:334:403  "function storeblabla(uint16 num) public {..."
            function fun_storeblabla_16(var_num_8) {

                /// @src 0:393:396  "num"
                let _2 := var_num_8
                let expr_12 := _2
                /// @src 0:384:396  "number = num"
                update_storage_value_offset_0t_uint16_to_t_uint16(0x00, expr_12)
                let expr_13 := expr_12

            }
            /// @src 0:199:680  "contract Storage {..."

            function zero_value_for_split_t_uint16() -> ret {
                ret := 0
            }

            function shift_right_0_unsigned(value) -> newValue {
                newValue :=

                shr(0, value)

            }

            function cleanup_from_storage_t_uint16(value) -> cleaned {
                cleaned := and(value, 0xffff)
            }

            function extract_from_storage_value_offset_0t_uint16(slot_value) -> value {
                value := cleanup_from_storage_t_uint16(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_uint16(slot) -> value {
                value := extract_from_storage_value_offset_0t_uint16(sload(slot))

            }

            /// @ast-id 38
            /// @src 0:594:678  "function retrieveBlaBla() public view returns (uint16){..."
            function fun_retrieveBlaBla_38() -> var__33 {
                /// @src 0:641:647  "uint16"
                let zero_t_uint16_3 := zero_value_for_split_t_uint16()
                var__33 := zero_t_uint16_3

                /// @src 0:665:671  "number"
                let _4 := read_from_storage_split_offset_0_t_uint16(0x00)
                let expr_35 := _4
                /// @src 0:658:671  "return number"
                var__33 := expr_35
                leave

            }
            /// @src 0:199:680  "contract Storage {..."

        }

        data ".metadata" hex"a2646970667358221220a9867f963a85e5bcbd539e97e4b5d4cc64243fc54166fd6516c3aeaacae1f17264736f6c63430008180033"
    }

}

