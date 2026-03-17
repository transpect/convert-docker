# convert-docker

This repo provides minimal hello world example that shows how 
to setup a container with the [convert](https://github.com/transpect/convert) API. 

## 1 Installation

### 1.1 Clone the Repository

This repo contains submodules. You need to clone it with
the `--recursive` parameter:

```
$ git clone --recursive https://github.com/transpect/convert-docker.git
```

Below is a brief overview of the main contents of this repository:

```
build/                  # Docker configuration
converter/              # Put your converters here
  |--hello/             # Hello world example
webapp-convert/         # The convert code
```

### 1.2 Build the Image

Please see the commented Dockerfile in `build/Dockerfile`. 

```
$ docker build -t letex/convert:latest . 
```

### 1.3 Start the Container from the Image

```
$ docker run -d -p 8080:8080 --name convert letex/convert:latest
```

## 2 Conversion

The `hello` converter includes a simple XProc
pipeline that will add `<message>hello!</message>` as the
first child of your XML file. Just upload your XML to get started.

### 2.1 Upload a File for Conversion

```
$ curl -i -X POST \
  -H "Content-Type: multipart/form-data" \
  -F converter=hello \
  -F "file=@converter/hello/test.xml" \
  http://localhost:8080/convert
```

### 2.2 Get a List of Conversion Results

```
$ curl -G http://localhost:8080/list/hello/test.xml
```

### 2.3 Download a Conversion Result

```
$ curl --output test.out.xml -G http://localhost:8080/download/hello/test.xml/test.out.xml
```

### 2.4 Add new converters

New converters should be added to the `converter` directory (see 
section 1.1). During the Docker build process, they are 
automatically copied to the appropriate directory.

Each converter compatible with the Convert API must include 
a Makefile that defines a `conversion` target and handles at
least the parameters `$IN_FILE` and `$OUT_DIR` passed from 
the convert API.

## 3 Troubleshooting

The convert web API follows an internal directory structure similar to that of the davomat 
with the difference that the entire converter is placed within the user directory.

## 3.1 Login to the Container

If you experience any issue with your converter, you may just login to the container:

```
$ docker exec -it convert /bin/bash
```

## 3.2 Container Directory Layout

If you want to debug a conversion, you should typically check the data directory in the container.

For example, if you uploaded the file `test.xml` to convert it using the `hello` converter, 
this is the location you need to inspect.

```
/home/
  |--letex/
  |  |--basex/               # the BaseX application
  |  |--convert/ 
  |  |  |--converter/        # the installed converters
  |  |  |--data/             # the uploaded data
  |  |  |  |--test.xml/      # each file is converted in its own directory
  |  |  |  |  |--in/         # input directory, contains the uploaded file
  |  |  |  |  |--out/        # output directory, includes the results
```

The `in` directory contains only the original input file, while the `out` directory usually includes 
the converted files, as well as any debug files and logs generated during the process.

To run a conversion, you would typically navigate to the converter directory. The converter 
expects each converter to include a Makefile in its root directory that defines the 
parameters `IN_FILE` and `OUT_DIR`.

## 3.3 Call a Conversion Manually

For example, the following command can be used to run the `hello` conversion manually 
from within the container.

```
$ make -f /home/letex/convert/converter/hello/Makefile conversion \
  IN_FILE=/home/letex/convert/data/hello/test.xml/in/test.xml \
  OUT_DIR=/home/letex/convert/data/hello/test.xml/out/ \
  DEBUG=yes
```
