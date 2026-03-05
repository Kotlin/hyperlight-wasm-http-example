// TODO if this is ever upstreamed: think about if this is a fitting implementation. It worked
// for us, but we were only using it as a fun demonstration, not in real production scenarios.
use std::time::SystemTime;

use crate::bindings::wasi;

use super::WasiImpl;

impl wasi::clocks::WallClock for WasiImpl {
    fn now(&mut self) -> wasi::clocks::wall_clock::Datetime {
        let now = SystemTime::now()
            .duration_since(SystemTime::UNIX_EPOCH)
            .unwrap();
        wasi::clocks::wall_clock::Datetime {
            seconds: now.as_secs(),
            nanoseconds: now.subsec_nanos(),
        }
    }

    fn resolution(&mut self) -> wasi::clocks::wall_clock::Datetime {
        wasi::clocks::wall_clock::Datetime {
            seconds: 0,
            nanoseconds: 1,
        }
    }
}
