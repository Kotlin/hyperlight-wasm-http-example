use crate::bindings::wasi;

use super::WasiImpl;

impl wasi::random::Random for WasiImpl {
    fn get_random_bytes(&mut self, len: u64) -> alloc::vec::Vec<u8> {
        let mut buf = vec![0u8; len as usize];
        getrandom::fill(&mut buf).unwrap();
        buf
    }

    fn get_random_u64(&mut self) -> u64 {
        let mut buf = [0u8; 8];
        getrandom::fill(&mut buf).unwrap();
        u64::from_le_bytes(buf)
    }
}
