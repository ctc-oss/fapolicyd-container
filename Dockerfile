FROM fedora:32 as build

RUN dnf install --nogpgcheck -y \
    kernel-headers systemd-devel libgcrypt-devel rpm-devel file-devel file libcap-ng-devel \
    libseccomp-devel lmdb-devel python3-devel gcc autoconf automake libtool uthash-devel make rpm-build

WORKDIR /tmp/fapolicyd
COPY . .
RUN ./autogen.sh \
 && ./configure --with-audit --disable-shared \
 && make         \
 && make dist

RUN mkdir -p /root/rpmbuild/SOURCES/
RUN cp fapolicyd-*.tar.gz /root/rpmbuild/SOURCES/
RUN rpmbuild -ba fapolicyd.spec
RUN du -sh /root/rpmbuild/RPMS/x86_64/fapolicyd-1.*.rpm

# ----------------------------------

FROM fedora:32

RUN dnf install --nogpgcheck -y libgcrypt rpm file libcap-ng libseccomp lmdb python3

COPY --from=build /root/rpmbuild/RPMS/x86_64/fapolicyd-1.*.rpm /tmp
RUN rpm -i /tmp/fapolicyd-*.rpm
RUN systemctl enable fapolicyd

CMD [ "/sbin/init" ]