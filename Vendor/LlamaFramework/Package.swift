// swift-tools-version: 5.10
import PackageDescription
let package=Package(name:"LlamaFramework",platforms:[.iOS(.v17)],products:[.library(name:"LlamaFramework",targets:["LlamaFramework"])],targets:[.binaryTarget(name:"LlamaFramework",url:"https://github.com/ggml-org/llama.cpp/releases/download/b10982/llama-b10982-xcframework.zip",checksum:"REPLACE_WITH_RELEASE_CHECKSUM")])
