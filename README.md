# convert-docker

This repo provides minimal hello world example that shows how 
to setup a container with the convert API. 

## 1 Architecture

### 1.1 This Repository

```
/convert-docker
  |--build                  # Docker configuration
  |--converter              # Put your converters here
  |  |--hello               # Hello world example
  |--webapp-convert         # The convert code
```

### 1.2 Container Layout

This directory structure of the Docker container is shown 
below. If you would upload a file named `test.xml` to the 
`hello` converter, the respective directories would be created
in the data dir.

```
/home/
  |--letex/
  |--basex/
  |  |--convert/ 
  |  |  |--converter
  |  |  |  |--hello/
  |  |  |  |  |--Makefile
  |  |  |--data
  |  |  |  |--hello/
  |  |  |  |  |--test.xml/
  |  |  |  |  |  |--in/
  |  |  |  |  |  |--out/
```

New converters should be added to the `converter` directory (see 
section 1.1). During the Docker build process, they are 
automatically copied to the appropriate directory.

Each converter compatible with the Convert API must include 
a Makefile that defines a `conversion` target and handles at
least the parameters `$IN_FILE` and `$OUT_DIR` passed from 
the convert API.

## 2 Setup the Container

Please see the commented Dockerfile in `build/Dockerfile`. 

### 2.1 Build the Image

```
$ docker build -t letex/convert:latest . 
```

### 2.2 Start the Container from the Image

```
$ docker run -d -p 8080:8080 --name convert letex/convert:latest
```

## 3 Conversion

The `hello` converter includes a simple XProc
pipeline that will add `<message>hello!</message>` as the
first child of your XML file. Just upload your XML to get started.

### 3.1 Upload a File for Conversion

```
$ curl -i -X POST \
  -H "Content-Type: multipart/form-data" \
  -F converter=hello \
  -F "file=@converter/hello/test.xml" \
  http://localhost:8080/convert
```

### 3.2 Get a List of Conversion Results

```
$ curl -G http://localhost:8080/list/hello/test.xml
```

### 3.3 Download a Conversion Result

```
$ curl --output test.out.xml -G http://localhost:8080/download/hello/test.xml/test.out.xml
```

## 4 Troubleshooting

The convert web API follows an internal directory structure similar to that of the davomat 
with the difference that the entire converter is placed within the user directory.

```
/home/
  |--letex/
  |  |--convert/ 
  |  |  |--basex/       => the BaseX application
  |  |  |--converter/   => the installed converters
  |  |  |--data/        => the uploaded data
```

If you want to debug a conversion, you should typically check the data directory in the container 
as shown in section 1.2.

For example, if you uploaded the file `test.xml` to convert it using the `hello` converter, 
this is the location you need to inspect.

The `in` directory contains only the original input file, while the `out` directory usually includes 
the converted files, as well as any debug files and logs generated during the process.

To run a conversion, you would typically navigate to the converter directory. The converter 
expects each converter to include a Makefile in its root directory that defines the 
parameters `IN_FILE` and `OUT_DIR`.

For example, the following command can be used to run the `hello` conversion manually 
from within the container.

```
$ make -f /home/letex/convert/converter/hello/Makefile conversion \
  IN_FILE=/home/letex/convert/data/hello/test.xml/in/test.xml \
  OUT_DIR=/home/letex/convert/data/hello/test.xml/out/ \
  DEBUG=yes
```
