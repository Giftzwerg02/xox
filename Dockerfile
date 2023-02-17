# ISC License
# Copyright (c) 2023 Florentin Schäfer
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Nightly is required until `-Z sparse-registry` is stabilized in Rust 1.68
# https://github.com/rust-lang/cargo/issues/9069#issuecomment-1408773982
FROM rustlang/rust:nightly-slim as build
WORKDIR /app
COPY . /app

ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

RUN apt-get update && \
    apt-get install -y upx

RUN cargo build --release && \
    upx --lzma --best /app/target/release/xox

FROM gcr.io/distroless/cc:nonroot
EXPOSE 8080

WORKDIR /app

COPY --from=build /app/target/release/xox /app/xox

USER nonroot

CMD [ "/app/xox" ]