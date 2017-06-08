#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: bioboxes/megahit
    dockerOutputDirectory: /bbx/output
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entryname: /bbx/input/biobox.yaml
        entry: |
          ${ var ret = `---
          version: "0.9.0"
          arguments:
            - fastq:
          `;
             inputs.fastqs.forEach(function(entry, index) {
               ret += `    - id: "reads${index}"
                type: "paired"
                value: "${entry.path}"
             `;});
             return ret; }

inputs:
  fastqs:
    label: interleaved paired & gzipped reads
    type: File[]
    #format: edam:format_1930  # FASTQ

baseCommand: default

outputs:
  contigs:
    type: File
    format: edam:format_1929  # FASTA
    outputBinding:
      glob: contigs.fa

$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.17.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
