# Da LLVM toolchain
FROM alpine:3.19 as bob

RUN apk update ; apk add build-base git cmake ninja clang llvm meson
RUN mkdir /src ; git clone https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm /src/LLVM-embedded-toolchain-for-Arm
RUN git config --global user.email "nerd@embeddedreality.com" ; git config --global user.name "Embeddedreality Nerd"
RUN mkdir /src/build; cd /src/build; cmake -G Ninja ../LLVM-embedded-toolchain-for-Arm
RUN cd /src/build; ninja llvm-toolchain ; ninja package-llvm-toolchain
RUN mkdir /opt; tar xjf $(ls /src/build/*.tar.gz)

FROM alpine:3.19

RUN apk update; apk add ninja meson cmake
COPY --from=bob /opt /opt

