# Check if the library should be downloaded first to use it.
package.check <- function(x) {
    if (!require(x, character.only = TRUE)) {
        install.packages(x, dependencies = TRUE)
        library(x, character.only = TRUE)
    }
}

package.check('ggplot2')
package.check('dplyr')
package.check('tidyr')
package.check('tibble')

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
BiocManager::install("ChIPseeker")
BiocManager::install("clusterProfiler")
BiocManager::install("org.Hs.eg.db")

library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(clusterProfiler)
library(org.Hs.eg.db)

###

# NAME <- 'ENCFF881GRS.hg19.filtered'
# NAME <- 'ENCFF883IEF.hg19.filtered'
NAME <- 'GSM3003539.merged'

BED_FN <- paste0(DATA_DIR, NAME, '.bed')

OUT_DIR <- '../results/'
DATA_DIR <- '../data/'

###

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

peakAnno <- annotatePeak(BED_FN, tssRegion=c(-3000, 3000), TxDb=txdb, annoDb="org.Hs.eg.db")

png(paste0(OUT_DIR, 'chip_seeker.', NAME, '.plotAnnoPie.png'))
plotAnnoPie(peakAnno)
dev.off()