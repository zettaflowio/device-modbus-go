#
# Copyright (c) 2020 IOTech Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ARG BASE=golang:1.11-alpine
FROM ${BASE} AS builder

ARG MAKE='make build'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories
RUN apk add --update --no-cache make git openssh build-base

# set the working directory
WORKDIR /device-modbus-go

COPY . .

RUN ${MAKE}

FROM scratch

ENV APP_PORT=49991
EXPOSE $APP_PORT

COPY --from=builder /device-modbus-go/cmd /

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2019: IoTech Ltd'

ENTRYPOINT ["/device-modbus","--profile=docker","--confdir=/res","--registry=consul://edgex-core-consul:8500"]
