SWIFT_BUILD_FLAGS=--configuration release

build:
	swift build -Xswiftc -enable-library-evolution -v $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build
	rm -rf .swiftpm

test:
	swift test -v

update:
	swift package update

profile: clean
	mkdir -p /tmp/sextant.stats
	swift build \
		--configuration release \
		-Xswiftc -stats-output-dir \
		-Xswiftc /tmp/sextant.stats \
		-Xswiftc -trace-stats-events \
		-Xswiftc -driver-time-compilation \
		-Xswiftc -debug-time-function-bodies

docker:
	-DOCKER_HOST=ssh://rjbowli@192.168.111.203 docker buildx create --name cluster_builder203 --platform linux/amd64
	-docker buildx create --name cluster_builder203 --platform linux/arm64 --append
	-docker buildx use cluster_builder203
	-docker buildx inspect --bootstrap
	-docker login
	docker buildx build --platform linux/amd64,linux/arm64 --push -t kittymac/sextant .

