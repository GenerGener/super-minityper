task construct{
  File inputFA
  File inputVCF
  Int diskGB
  Int maxNodeLength = 32

  String outbase = basename(inputFA, "fa") + "." + basename(inputVCF, ".vcf")

  command{
     svaha2 -r ${inputFA} -v ${inputVCF} -m ${maxNodeLength} > ${outbase}.gfa
  }

  runtime{
     docker: "erictdawson/svaha2"
     cpu : 1
     memory : "24 GB"
     preemptible : 2
     disks : "local-disk " + diskGB + " SSD"
  }

  output{
   File outputGFA = "${outbase}.gfa"
  }
}

workflow Svaha2ConstructGraph{
  File inputFA
  File inputVCF
  Int maxNodeLength = 32

  Int diskGB = ceil(size(inputFA, "GB") + size(inputVCF, "GB")) + 30

  call construct{
    input:
      inputFA=inputFA,
      inputVCF=inputVCF,
      diskGB=diskGB
  }
}
