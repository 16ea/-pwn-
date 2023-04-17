FROM ubuntu:22.04

RUN apt-get update
RUN apt install -y xinetd
RUN useradd  -m ctf

WORKDIR /home/ctf

RUN mkdir /home/ctf/usr && \ 
    cp -rf /lib* /home/ctf && \
    cp -rf /usr/lib* /home/ctf/usr



RUN mkdir /home/ctf/dev && \
    mknod /home/ctf/dev/null c 1 3 && \
    mknod /home/ctf/dev/zero c 1 5 && \
    mknod /home/ctf/dev/random c 1 8 && \
    mknod /home/ctf/dev/urandom c 1 9 && \
    chmod 666 /home/ctf/dev/*
RUN mkdir /home/ctf/bin && \
cp /bin/sh /home/ctf/bin && \
cp /bin/ls /home/ctf/bin && \
cp /bin/cat /home/ctf/bin 


COPY ctf.xinetd /etc/xinetd.d/uint
RUN sed -i "s/PORT/$PORT/" /etc/xinetd.d/uint
COPY hello hello
RUN chmod +x hello
RUN chown -R root:ctf /home/ctf && chmod -R 750 /home/ctf

CMD exec /bin/bash -c "echo dXNlcj1gbHMgL2hvbWVgCmlmIFsgISAkREFTRkxBRyBdO3RoZW4KIGVjaG8gZmxhZ3tURVNUX0RBU0ZMQUd9fHRlZSAvaG9tZS8kdXNlci9mbGFnIC9mbGFnCmVsc2UKIGVjaG8gJERBU0ZMQUd8dGVlIC9ob21lLyR1c2VyL2ZsYWcgL2ZsYWcKZmkKY2hvd24gcm9vdDokdXNlciAvaG9tZS8kdXNlci9mbGFnIC9mbGFnCmNobW9kIDc0MCAvaG9tZS8kdXNlci9mbGFnIC9mbGFnCg==|base64 -d|sh;/etc/init.d/xinetd start; trap : TERM INT; sleep infinity & wait"

EXPOSE 9999 
