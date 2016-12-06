Standalone Java - CentOS Docker image
========================================


This repository contains the source for building various versions of
the Standalone java application as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
The resulting image can be run using [Docker](http://docker.io).

Versions
---------------
Java versions currently provided are:
* openJDK v1.7
* openJDK v1.8

CentOS versions currently provided are:
* CentOS7


Installation
---------------

This image is available on DockerHub.  To download it, run:

```
$ docker pull mangirdas/s2i-java-8-centos7
```

or

```
$ docker pull mangirdas/s2i-java-7-centos7
```


To build a Java image from scratch, run:

```
$ git clone https://github.com/mangirdaz/s2i-standalone-java.git
$ cd s2i-standalone-java
$ make build VERSION=7
```

** Note: by omitting the `VERSION` parameter, the build/test action be performed
on all provided versions of WildFly.**

Usage
---------------------
To build a simple [jee application](https://github.com/bparees/openshift-jee-sample)
using standalone [S2I](https://github.com/openshift/source-to-image) and then run the
resulting image with [Docker](http://docker.io) execute:

```
$ s2i build git://github.com/bparees/openshift-jee-sample mangirdas/s2i-java-8-centos7 javatest
$ docker run -p 8080:8080 javatest
```

**Accessing the application:**
```
$ curl 127.0.0.1:8080
```

Test
---------------------
This repository also provides a [S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple WildFly application built on top of the wildfly image.

*  **CentOS based image**

    ```
    $ cd s2i-standalone-java
    $ make test VERSION=7
    ```

**Notice: By omitting the `VERSION` parameter, the build/test action will be performed
on all provided versions of WildFly.**

