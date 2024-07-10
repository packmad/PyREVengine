FROM python:3-slim-bookworm AS build

RUN DEBIAN_FRONTEND=noninteractive apt update && apt -y upgrade && \
    apt install --no-install-recommends -y build-essential git gcc g++ make cmake && \
    git clone https://github.com/zrax/pycdc.git && \
    cd pycdc && mkdir build && cd build && cmake .. && make -j2 && make check

FROM python:3-slim-bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y upgrade && \
    apt install --no-install-recommends -y libpq-dev tzdata build-essential curl coreutils yara && \
    pip install --upgrade pip setuptools wheel uncompyle6 decompyle3 yara-python && \
    curl -o /usr/local/bin/pyinstxtractor.py https://raw.githubusercontent.com/extremecoders-re/pyinstxtractor/master/pyinstxtractor.py && \
    sed -i '1s/^/#!\/usr\/bin\/env python3\n/' /usr/local/bin/pyinstxtractor.py && chmod +x /usr/local/bin/pyinstxtractor.py
COPY --from=build /pycdc/build/pycdas /usr/local/bin/
COPY --from=build /pycdc/build/pycdc /usr/local/bin/
COPY pyinstaller.yara /root
RUN yarac /root/pyinstaller.yara /root/pyinstaller.yarac
ENTRYPOINT ["/bin/bash"]
