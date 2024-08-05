FROM debian:stretch

# Cập nhật các kho lưu trữ Debian
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cập nhật hệ thống
RUN apt-get update -y

# Cài đặt các công cụ cần thiết cho việc quản lý gói
RUN apt-get install -y \
    apt-utils \
    gnupg2 \
    dirmngr

# Cài đặt các gói phần mềm cần thiết
RUN apt-get install -y \
    samba \
    vim \
    locales

# Thiết lập locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Dọn dẹp danh sách gói để giảm dung lượng ảnh Docker
RUN rm -rf /var/lib/apt/lists/*

# Sao chép script và thiết lập quyền
COPY docker-entrypoint.sh /
RUN chmod +rx /docker-entrypoint.sh

# Thiết lập biến môi trường
ENV LANG en_US.utf8

# Thiết lập múi giờ
RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone

# Sao chép cấu hình samba
ADD ./smb.conf /etc/samba/smb.conf

# Thiết lập volume và thư mục làm việc
VOLUME [ "/data" ]
WORKDIR /data/

# Mở các cổng cần thiết
EXPOSE 139 
EXPOSE 445

# Thiết lập entrypoint
ENTRYPOINT [ "/docker-entrypoint.sh" ]
