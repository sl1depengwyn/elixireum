
/// @use-src 0:"sources/storage.sol"
object "Storage_42" {
    code {
        /// @src 0:70:454  "contract Storage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_Storage_42()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Storage_42_deployed"), datasize("Storage_42_deployed"))

        return(_1, datasize("Storage_42_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:70:454  "contract Storage {..."
        function constructor_Storage_42() {

            /// @src 0:70:454  "contract Storage {..."

        }
        /// @src 0:70:454  "contract Storage {..."

    }
    /// @use-src 0:"sources/storage.sol"
    object "Storage_42_deployed" {
        code {
            /// @src 0:70:454  "contract Storage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2e64cec1
                {
                    // retrieve()

                    external_fun_retrieve_33()
                }

                case 0x5ea802c0
                {
                    // store_1(string)

                    external_fun_store_1_25()
                }

                case 0x6057361d
                {
                    // store(uint256)

                    external_fun_store_15()
                }

                case 0xb6bf8c32
                {
                    // retrieve_1()

                    external_fun_retrieve_1_41()
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

            function cleanup_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_retrieve_33() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_retrieve_33()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
                revert(0, 0)
            }

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
            }

            function revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() {
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

            function array_allocation_size_t_string_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function copy_calldata_to_memory_with_cleanup(src, dst, length) {
                calldatacopy(dst, src, length)
                mstore(add(dst, length), 0)
            }

            function abi_decode_available_length_t_string_memory_ptr(src, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_string_memory_ptr(length))
                mstore(array, length)
                let dst := add(array, 0x20)
                if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
                copy_calldata_to_memory_with_cleanup(src, dst, length)
            }

            // string
            function abi_decode_t_string_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_string_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_string_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_store_1_25() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_string_memory_ptr(4, calldatasize())
                fun_store_1_25(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function validator_revert_t_uint256(value) {
                if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
            }

            function abi_decode_t_uint256(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_uint256(value)
            }

            function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function external_fun_store_15() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_store_15(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function array_length_t_string_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function copy_memory_to_memory_with_cleanup(src, dst, length) {
                let i := 0
                for { } lt(i, length) { i := add(i, 32) }
                {
                    mstore(add(dst, i), mload(add(src, i)))
                }
                mstore(add(dst, length), 0)
            }

            function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value, pos) -> end {
                let length := array_length_t_string_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, round_up_to_mul_of_32(length))
            }

            function abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_retrieve_1_41() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_retrieve_1_41()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            function shift_right_0_unsigned(value) -> newValue {
                newValue :=

                shr(0, value)

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

            /// @ast-id 33
            /// @src 0:280:359  "function retrieve() public view returns (uint256){..."
            function fun_retrieve_33() -> var__28 {
                /// @src 0:321:328  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__28 := zero_t_uint256_1

                /// @src 0:346:352  "number"
                let _2 := read_from_storage_split_offset_0_t_uint256(0x01)
                let expr_30 := _2
                /// @src 0:339:352  "return number"
                var__28 := expr_30
                leave

            }
            /// @src 0:70:454  "contract Storage {..."

            function panic_error_0x00() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x00)
                revert(0, 0x24)
            }

            function panic_error_0x22() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x22)
                revert(0, 0x24)
            }

            function extract_byte_array_length(data) -> length {
                length := div(data, 2)
                let outOfPlaceEncoding := and(data, 1)
                if iszero(outOfPlaceEncoding) {
                    length := and(length, 0x7f)
                }

                if eq(outOfPlaceEncoding, lt(length, 32)) {
                    panic_error_0x22()
                }
            }

            function array_dataslot_t_string_storage(ptr) -> data {
                data := ptr

                mstore(0, ptr)
                data := keccak256(0, 0x20)

            }

            function divide_by_32_ceil(value) -> result {
                result := div(add(value, 31), 32)
            }

            function shift_left_dynamic(bits, value) -> newValue {
                newValue :=

                shl(bits, value)

            }

            function update_byte_slice_dynamic32(value, shiftBytes, toInsert) -> result {
                let shiftBits := mul(shiftBytes, 8)
                let mask := shift_left_dynamic(shiftBits, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                toInsert := shift_left_dynamic(shiftBits, toInsert)
                value := and(value, not(mask))
                result := or(value, and(toInsert, mask))
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_uint256_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_uint256(value)))
            }

            function prepare_store_t_uint256(value) -> ret {
                ret := value
            }

            function update_storage_value_t_uint256_to_t_uint256(slot, offset, value_0) {
                let convertedValue_0 := convert_t_uint256_to_t_uint256(value_0)
                sstore(slot, update_byte_slice_dynamic32(sload(slot), offset, prepare_store_t_uint256(convertedValue_0)))
            }

            function storage_set_to_zero_t_uint256(slot, offset) {
                let zero_0 := zero_value_for_split_t_uint256()
                update_storage_value_t_uint256_to_t_uint256(slot, offset, zero_0)
            }

            function clear_storage_range_t_bytes1(start, end) {
                for {} lt(start, end) { start := add(start, 1) }
                {
                    storage_set_to_zero_t_uint256(start, 0)
                }
            }

            function clean_up_bytearray_end_slots_t_string_storage(array, len, startIndex) {

                if gt(len, 31) {
                    let dataArea := array_dataslot_t_string_storage(array)
                    let deleteStart := add(dataArea, divide_by_32_ceil(startIndex))
                    // If we are clearing array to be short byte array, we want to clear only data starting from array data area.
                    if lt(startIndex, 32) { deleteStart := dataArea }
                    clear_storage_range_t_bytes1(deleteStart, add(dataArea, divide_by_32_ceil(len)))
                }

            }

            function shift_right_unsigned_dynamic(bits, value) -> newValue {
                newValue :=

                shr(bits, value)

            }

            function mask_bytes_dynamic(data, bytes) -> result {
                let mask := not(shift_right_unsigned_dynamic(mul(8, bytes), not(0)))
                result := and(data, mask)
            }
            function extract_used_part_and_set_length_of_short_byte_array(data, len) -> used {
                // we want to save only elements that are part of the array after resizing
                // others should be set to zero
                data := mask_bytes_dynamic(data, len)
                used := or(data, mul(2, len))
            }
            function copy_byte_array_to_storage_from_t_string_memory_ptr_to_t_string_storage(slot, src) {

                let newLen := array_length_t_string_memory_ptr(src)
                // Make sure array length is sane
                if gt(newLen, 0xffffffffffffffff) { panic_error_0x41() }

                let oldLen := extract_byte_array_length(sload(slot))

                // potentially truncate data
                clean_up_bytearray_end_slots_t_string_storage(slot, oldLen, newLen)

                let srcOffset := 0

                srcOffset := 0x20

                switch gt(newLen, 31)
                case 1 {
                    let loopEnd := and(newLen, not(0x1f))

                    let dstPtr := array_dataslot_t_string_storage(slot)
                    let i := 0
                    for { } lt(i, loopEnd) { i := add(i, 0x20) } {
                        sstore(dstPtr, mload(add(src, srcOffset)))
                        dstPtr := add(dstPtr, 1)
                        srcOffset := add(srcOffset, 32)
                    }
                    if lt(loopEnd, newLen) {
                        let lastValue := mload(add(src, srcOffset))
                        sstore(dstPtr, mask_bytes_dynamic(lastValue, and(newLen, 0x1f)))
                    }
                    sstore(slot, add(mul(newLen, 2), 1))
                }
                default {
                    let value := 0
                    if newLen {
                        value := mload(add(src, srcOffset))
                    }
                    sstore(slot, extract_used_part_and_set_length_of_short_byte_array(value, newLen))
                }
            }

            function update_storage_value_offset_0t_string_memory_ptr_to_t_string_storage(slot, value_0) {

                copy_byte_array_to_storage_from_t_string_memory_ptr_to_t_string_storage(slot, value_0)
            }

            /// @ast-id 25
            /// @src 0:203:274  "function store_1(string memory qwe) public {..."
            function fun_store_1_25(var_qwe_17_mpos) {

                /// @src 0:264:267  "qwe"
                let _3_mpos := var_qwe_17_mpos
                let expr_21_mpos := _3_mpos
                /// @src 0:256:267  "uri_1 = qwe"
                update_storage_value_offset_0t_string_memory_ptr_to_t_string_storage(0x00, expr_21_mpos)
                let _4_slot := 0x00
                let expr_22_slot := _4_slot

            }
            /// @src 0:70:454  "contract Storage {..."

            function shift_left_0(value) -> newValue {
                newValue :=

                shl(0, value)

            }

            function update_byte_slice_32_shift_0(value, toInsert) -> result {
                let mask := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                toInsert := shift_left_0(toInsert)
                value := and(value, not(mask))
                result := or(value, and(toInsert, mask))
            }

            function update_storage_value_offset_0t_uint256_to_t_uint256(slot, value_0) {
                let convertedValue_0 := convert_t_uint256_to_t_uint256(value_0)
                sstore(slot, update_byte_slice_32_shift_0(sload(slot), prepare_store_t_uint256(convertedValue_0)))
            }

            /// @ast-id 15
            /// @src 0:133:197  "function store(uint256 num) public {..."
            function fun_store_15(var_num_7) {

                /// @src 0:187:190  "num"
                let _5 := var_num_7
                let expr_11 := _5
                /// @src 0:178:190  "number = num"
                update_storage_value_offset_0t_uint256_to_t_uint256(0x01, expr_11)
                let expr_12 := expr_11

            }
            /// @src 0:70:454  "contract Storage {..."

            function zero_value_for_split_t_string_memory_ptr() -> ret {
                ret := 96
            }

            function array_storeLengthForEncoding_t_string_memory_ptr(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            // string -> string
            function abi_encode_t_string_storage_to_t_string_memory_ptr(value, pos) -> ret {
                let slotValue := sload(value)
                let length := extract_byte_array_length(slotValue)
                pos := array_storeLengthForEncoding_t_string_memory_ptr(pos, length)
                switch and(slotValue, 1)
                case 0 {
                    // short byte array
                    mstore(pos, and(slotValue, not(0xff)))
                    ret := add(pos, mul(0x20, iszero(iszero(length))))
                }
                case 1 {
                    // long byte array
                    let dataPos := array_dataslot_t_string_storage(value)
                    let i := 0
                    for { } lt(i, length) { i := add(i, 0x20) } {
                        mstore(add(pos, i), sload(dataPos))
                        dataPos := add(dataPos, 1)
                    }
                    ret := add(pos, i)
                }
            }

            function abi_encodeUpdatedPos_t_string_storage_to_t_string_memory_ptr(value0, pos) -> updatedPos {
                updatedPos := abi_encode_t_string_storage_to_t_string_memory_ptr(value0, pos)
            }

            function copy_array_from_storage_to_memory_t_string_storage(slot) -> memPtr {
                memPtr := allocate_unbounded()
                let end := abi_encodeUpdatedPos_t_string_storage_to_t_string_memory_ptr(slot, memPtr)
                finalize_allocation(memPtr, sub(end, memPtr))
            }

            function convert_array_t_string_storage_to_t_string_memory_ptr(value) -> converted  {

                // Copy the array to a free position in memory
                converted :=

                copy_array_from_storage_to_memory_t_string_storage(value)

            }

            /// @ast-id 41
            /// @src 0:365:451  "function retrieve_1() public view returns (string memory){..."
            function fun_retrieve_1_41() -> var__36_mpos {
                /// @src 0:408:421  "string memory"
                let zero_t_string_memory_ptr_6_mpos := zero_value_for_split_t_string_memory_ptr()
                var__36_mpos := zero_t_string_memory_ptr_6_mpos

                /// @src 0:439:444  "uri_1"
                let _7_slot := 0x00
                let expr_38_slot := _7_slot
                /// @src 0:432:444  "return uri_1"
                var__36_mpos := convert_array_t_string_storage_to_t_string_memory_ptr(expr_38_slot)
                leave

            }
            /// @src 0:70:454  "contract Storage {..."

        }

        data ".metadata" hex"a264697066735822122028e601c7184df54d01ec9702c08e0dcafbcfcefb113c3706663f45e20e5839d664736f6c63430008180033"
    }

}

