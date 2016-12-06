# Variables are documented in hack/build.sh.
BASE_IMAGE_NAME = s2i-java
VERSIONS = 1.7 1.8
OPENSHIFT_NAMESPACES = 1.7. 1.8

# Include common Makefile code.
include hack/common.mk
