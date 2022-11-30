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

docker:
	-docker buildx create --name cluster_builder203
	-DOCKER_HOST=ssh://rjbowli@192.168.1.203 docker buildx create --name cluster_builder203 --platform linux/amd64 --append
	-docker buildx use cluster_builder203
	-docker buildx inspect --bootstrap
	-docker login
	docker buildx build --platform linux/amd64,linux/arm64 --push -t kittymac/sextant .

