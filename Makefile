# https://stackoverflow.com/a/55696820
SHELL = /bin/bash

#FASTQS?=.github/data/fastqs/
RG = assets/ref_genomes
PT = assets/prodigal_training_files

MT = "Mycobacterium tuberculosis"
KP = "Klebsiella pneumoniae"
SA = "Staphylococcus aureus"
EC = "Escherichia coli"
CONT_NAME = jasen_2021-05-06.sif
PROJECT_ROOT = /home/Hanna/Documents/CG-Linkoping/gms-JASEN

#GENOME_NAME = Escherichia_coli_GCF_000008865.2_ASM886v2
#GENOME_NAME = Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2
#GENOME_NAME = Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2
GENOME_NAME = Staphylococcus_aureus_GCF_000013425.1_ASM1342v1

#INPUT_DIR = Escherichia_coli_p1
#INPUT_DIR = Klebsiella_pneumoniae_p1
INPUT_DIR = saureus_p1
#INPUT_DIR = Mycobacterium_tuberculosis_p1
#INPUT_DIR = saureus_p2

WORKDIR = $(PROJECT_ROOT)/work
IMAGE = $(PROJECT_ROOT)/container/$(CONT_NAME)

# To which directory inside work/ should the results files be output?
#OUTPUT_PATH_IN_WORK_DIR = results
# E.g. can change the default results directory name to the sample name instead
# OUTPUT_PATH_IN_WORK_DIR = Klebsiella_pneumoniae_p1
# Or it can be the same as input dir name:
OUTPUT_PATH_IN_WORK_DIR = $(INPUT_DIR)

SG = /usr/local/bin/singularity exec -B $(PROJECT_ROOT):/external -B $(WORKDIR):/out container/$(CONT_NAME) prodigal -p single -t

RUN = /usr/local/bin/singularity exec -B $(PROJECT_ROOT):/external -B $(WORKDIR):/out $(IMAGE) nextflow -C /external/nextflow.config run main.nf -profile local,singularity --genome_name $(GENOME_NAME) --input_dir $(INPUT_DIR) --output_path $(OUTPUT_PATH_IN_WORK_DIR) -resume


all: clear_files download_bacterial_genomes create_prodigal_trn_files uncompress_genomes

clear_files:
	@echo ""
	@echo "Raderar både nedladdade och träningsfilerna:"
	@echo ""
	@(rm -f $(RG)/*.gz $(RG)/*.fna $(PT)/*.trn)
	@echo ""

download_bacterial_genomes:
	@echo ""
	@echo "Laddar ner $(MT) refseq genomet, se mera info om genomet här: https://www.ncbi.nlm.nih.gov/assembly/GCF_000195955.2/"
	@echo ""
	wget -vc -O $(RG)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Mycobacterium_tuberculosis/reference/GCF_000195955.2_ASM19595v2/GCF_000195955.2_ASM19595v2_genomic.fna.gz
	@echo ""
	@echo "Skapar md5sum av $(MT) refseq genomet:"
	md5sum $(RG)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.fna.gz > $(RG)/md5sums.txt
	@echo ""
	@echo ""
	@echo "Laddar ner $(KP) refseq genomet, se mera info om genomet här: https://www.ncbi.nlm.nih.gov/assembly/GCF_000240185.1/"
	@echo ""
	wget -vc -O $(RG)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Klebsiella_pneumoniae/reference/GCF_000240185.1_ASM24018v2/GCF_000240185.1_ASM24018v2_genomic.fna.gz
	@echo ""
	@echo "Skapar md5sum av $(KP) refseq genomet:"
	md5sum $(RG)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.fna.gz >> $(RG)/md5sums.txt
	@echo ""
	@echo ""
	@echo "Laddar ner $(SA) refseq genomet, se mera info om genomet här: https://www.ncbi.nlm.nih.gov/assembly/GCF_000013425.1/"
	wget -vc -O $(RG)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Staphylococcus_aureus/reference/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.fna.gz
	@echo ""
	@echo "Skapar md5sum av $(SA) refseq genomet"
	@echo ""
	md5sum $(RG)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.fna.gz >> $(RG)/md5sums.txt
	@echo ""
	@echo ""
	@echo "Laddar ner $(EC) refseq genomet, se mera info om genomet här: https://www.ncbi.nlm.nih.gov/assembly/GCF_000008865.2/"
	wget -vc -O $(RG)/Escherichia_coli_GCF_000008865.2_ASM886v2.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000008865.2_ASM886v2/GCF_000008865.2_ASM886v2_genomic.fna.gz
	@echo ""
	@echo "Skapar md5sum av $(EC) refseq genomet"
	@echo ""
	md5sum $(RG)/Escherichia_coli_GCF_000008865.2_ASM886v2.fna.gz >> $(RG)/md5sums.txt
	@echo ""

create_prodigal_trn_files:
	@echo ""
	@echo "Skapar mapp för singularity körningen:"
	@mkdir -p work
	@echo ""
	@echo "Skapar prodigal träningsfiler från refseq genomen:"
	@echo ""
	@echo "För $(MT):"
	zcat $(RG)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.fna.gz | $(SG) $(PT)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.trn
	@echo ""
	@echo ""
	@echo "För $(KP):"
	zcat $(RG)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.fna.gz | $(SG) $(PT)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.trn
	@echo ""
	@echo ""
	@echo "För $(SA):"
	zcat $(RG)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.fna.gz | $(SG) $(PT)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.trn
	@echo ""
	@echo ""
	@echo "För $(EC):"
	zcat $(RG)/Escherichia_coli_GCF_000008865.2_ASM886v2.fna.gz | $(SG) $(PT)/Escherichia_coli_GCF_000008865.2_ASM886v2.trn
	@echo ""

uncompress_genomes:
	zcat $(RG)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.fna.gz > $(RG)/Mycobacterium_tuberculosis_GCF_000195955.2_ASM19595v2.fna
	zcat $(RG)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.fna.gz > $(RG)/Klebsiella_pneumoniae_GCF_000240185.1_ASM24018v2.fna
	zcat $(RG)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.fna.gz > $(RG)/Staphylococcus_aureus_GCF_000013425.1_ASM1342v1.fna
	zcat $(RG)/Escherichia_coli_GCF_000008865.2_ASM886v2.fna.gz > $(RG)/Escherichia_coli_GCF_000008865.2_ASM886v2.fna

run:
	@mkdir -p work
	$(RUN)
