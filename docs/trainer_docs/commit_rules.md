# Cấu trúc của một commit message

- fix: pull request này thực hiện fix bug của dự án
- feat (feature): pull request này thực hiện một chức năng mới của dự án
- refactor: pull request này thực hiện refactor lại code hiện tại của dự án (refactor hiểu đơn giản là việc "làm sạch" code, loại bỏ code smells, mà không làm thay đổi chức năng hiện có)
- docs: pull request này thực hiện thêm/sửa đổi document của dự án
- style: pull request này thực hiện thay đổi UI của dự án mà không ảnh hưởng đến logic.
- perf: pull request này thực hiện cải thiện hiệu năng của dự án (VD: loại bỏ duplicate query, ...)
- vendor: pull request này thực hiện cập nhật phiên bản cho các packages, dependencies mà dự án đang sử dụng.
- chore: từ này dịch ra tiếng Việt là việc lặt vặt nên mình đoán là nó để chỉ những thay đổi không đáng kể trong code (ví dụ như thay đổi text chẳng hạn), vì mình cũng ít khi sử dụng type này.

Ví dụ:

- feat: intl
- fix: bug overflow layout
