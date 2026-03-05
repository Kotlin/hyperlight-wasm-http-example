use std::borrow::BorrowMut;

use crate::bindings::root::component::RootImports;

pub mod buffer;
pub mod cli;
pub mod clocks_monotonic_clock;
pub mod clocks_wall_clock;
pub mod headers;
pub mod http_future;
pub mod http_future_headers;
pub mod http_future_incoming_response;
pub mod http_headers;
pub mod http_incoming_body;
pub mod http_incoming_request;
pub mod http_incoming_response;
pub mod http_outgoing_body;
pub mod http_outgoing_handler;
pub mod http_outgoing_request;
pub mod http_outgoing_response;
pub mod http_request_options;
pub mod http_response_outparam;
pub mod io_error;
pub mod io_poll;
pub mod io_stream;
pub mod random;
pub mod types;

#[derive(Default)]
pub struct WasiImpl {
    client: reqwest::Client,
}

impl WasiImpl {
    pub fn new() -> Self {
        Self {
            client: reqwest::Client::new(),
        }
    }
}

impl RootImports for WasiImpl {
    type Poll = Self;

    fn poll(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type MonotonicClock = Self;

    fn monotonic_clock(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Error = Self;

    fn error(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Streams = Self;

    fn streams(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Types = Self;

    fn types(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type OutgoingHandler = Self;

    fn outgoing_handler(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Random = Self;

    fn random(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Stdout = Self;

    fn stdout(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Stderr = Self;

    fn stderr(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type Stdin = Self;

    fn stdin(&mut self) -> impl BorrowMut<Self> {
        self
    }

    type WallClock = Self;

    fn wall_clock(&mut self) -> impl BorrowMut<Self> {
        self
    }
}
