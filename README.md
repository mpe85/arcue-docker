# arcue-docker

*A dockerized version of [CUETools.ARCUE](https://github.com/gchudov/cuetools.net), a tool for CD image verification
against
AccurateRip.*

[![Latest Image](https://img.shields.io/docker/v/mpe85/arcue/latest
)](https://hub.docker.com/r/mpe85/arcue)

### Usage

Run the container, mounting the files to be verified into the container directory `/data`:

```shell
docker run --rm -v "$(pwd):/data" mpe85/arcue[:tag] [options] <filename>
```

Options:

```
-O, --offset <samples>   Use specific offset;
-v, --verbose            Verbose mode
```

### Example

```shell
docker run --rm -v "$(pwd):/data" mpe85/arcue -v album.cue
```