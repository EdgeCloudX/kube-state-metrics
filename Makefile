CGO_ENABLED:=0
DOCKER_PLATFORMS=linux/arm64,linux/amd64
REGISTRY?=registry.eecos.cn:7443/ecf-edge/coreos
TAG?=2.0.8
IMAGE:=$(REGISTRY)/kube-state-metrics:$(TAG)
BASEIMAGE:=k8s.gcr.io/debian-base:v2.0.0
ifeq ($(ENABLE_JOURNALD), 1)
	CGO_ENABLED:=1
	LOGCOUNTER=./bin/log-counter
endif

package:
	go mod tidy
	docker buildx create --use
	docker buildx build  --platform $(DOCKER_PLATFORMS) -t $(IMAGE) --build-arg BASEIMAGE=$(BASEIMAGE)  --push .
	#docker buildx build  --platform=linux/arm64,linux/amd64 -t $(IMAGE) --push.

build: $(PKG_SOURCES)
	CGO_ENABLED=$(CGO_ENABLED) GOOS=linux GO111MODULE=on go build  -o kube-state-metrics