#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/megahit:1.1.1--py36_0
  SoftwareRequirement:
    packages:
      megahit:
        specs: [ "https://doi.org/10.1093/bioinformatics/btv033" ]

inputs:
  sequences:
    type: File[]
    label: interleaved & gziped fasta/q paired-end files
    format:
      - edam:format_1930  # FASTQ
      - edam:format_1929  # FASTA
    inputBinding:
      prefix: --12
      itemSeparator: ','
  no_mercy:
    type: boolean?
    label: do not add mercy kmers 
    inputBinding:
      prefix: --no-mercy

baseCommand: megahit

arguments:  # many of these could be turned into configurable inputs
  - prefix: --num-cpu-threads
    valueFrom: $(runtime.cores)
  - prefix: --min-count
    valueFrom: "2"
  - prefix: --k-max
    valueFrom: "99"
  - prefix: --k-step
    valueFrom: "20"
  - prefix: --out-dir
    valueFrom: $(runtime.outdir)/output
  - prefix: --mem-flag
    valueFrom: "2"

outputs:
  megahit_contigs:
    type: File
    format: edam:format_1929  # FASTA
    bioboxes:type: contigs
    outputBinding:
      glob: 'output/final.contigs.fa'
  stderr: stderr

$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
 bioboxes: http://bioboxes.org
$schemas:
 - http://edamontology.org/EDAM_1.17.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0" 
