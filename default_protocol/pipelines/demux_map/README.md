# demux & map & report

A snakemake pipeline that takes basecalled FASTQ files, optionally demultiplexes them using `Porechop`, and maps them against a reference panel in FASTA format using `minimap2`. It then parses the barcode and mapping information and produces a CSV report.
### Header annotations 

The `parse_paf.py` script reads barcode and `start_time` information from the FASTQ header.

Both legacy Guppy (`key=value`) and Dorado (`key:type:value`) FASTQ header formats are supported.

Legacy Guppy example:

```text
@6d3d6bff-4c48-4b5c-8fc9-bc0765e27016 runid=b10b0df343a0c44bc8f661f2cfbe235fce1fbedc sampleid=seq_run read=58437 ch=444 start_time=2019-05-29T20:48:48Z barcode=NB01
```

Dorado example:

```text
@558310e2-ccf6-40c4-91ef-cc14da23aab2 qs:f:22.363989 ch:i:1800 rn:i:24 st:Z:2026-07-13T17:12:22.006627+02:00 SM:Z:barcode10 al:Z:barcode10
```

For Dorado headers, `st` is interpreted as `start_time`, while `SM` and `al` are used as barcode fields.

### CSV return format

The resulting CSV report includes the following header fields:

- read_name
- read_len
- start_time
- barcode
- best_reference
- ref_len
- start_coords
- end_coords
- num_matches
- aln_block_len

### Dependencies

In addition to the ``RAMPART`` dependencies, this pipeline also requires ``snakemake``.

### Usage

To start the pipeline running for one fastq file:
```
snakemake \
--snakefile default_protocol/pipelines/demux_map/Snakefile \
--configfile default_protocol/pipelines/demux_map/config.yaml \
--config \
input_path=path/to/basecalled/ \
output_path=where/to/put/data/ \
filename_stem=my_file \
references_file=path/to/my_references.fasta \
barcodes=NB01,NB02,NB03
```

You can change the default options, either by editing the config file provided or by explicitly stating the config parameters via the command line. The default settings for ``Porechop`` demultiplexing are shown below:

```
--config \
require_two_barcodes=True \
discard_middle=True \
split_reads=False \
discard_unassigned=False \
barcode_set=native \
#Options are [native,rapid,all], `all` is much slower
limit_barcodes=True \
barcode_threshold=80 \
barcode_diff=5
```

When using FASTQ files that have already been demultiplexed (for example by Dorado), Porechop can be skipped by setting:

```text
skip_porechop_demultiplexing=True
```

In this mode, FASTQ files are passed directly to the mapping step without additional demultiplexing.

If you wish to provide your own config file, it can be in yaml or json format.
