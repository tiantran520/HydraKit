# Kiến Trúc

IronBitCoreKit được chia thành nhiều module nhỏ, mỗi module chịu trách nhiệm cho một nhóm chức năng rõ ràng.

## Nguyên Tắc

- Tách module theo trách nhiệm.
- Ưu tiên protocol-oriented design.
- Giữ public API có doc comment.
- Hỗ trợ testability thông qua mock, stub, spy và dependency injection.
- Tránh phụ thuộc vòng giữa các module.

## Nhóm Module

- `IronBitCoreKit`: nền tảng chung như extensions, logging, error, dependency injection và concurrency.
- `IronBitCoreKitNetwork`: networking core, transport, interceptor, decoding, cache, reachability, security và mock.
- `IronBitCoreKitTesting`: helper phục vụ unit test và snapshot test.
- `IronBitCoreKitDev`: công cụ chỉ dùng trong Debug như dev menu, environment switcher và preview container.

## Hướng Phát Triển

Các module mới nên được thêm theo hướng nhỏ, rõ ràng và có test tương ứng. Với API public, hãy bổ sung doc comment để DocC có thể sinh tài liệu đầy đủ.
