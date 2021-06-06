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

###

# NAME <- 'ENCFF881GRS.hg19'
# NAME <- 'ENCFF881GRS.hg38'
# NAME <- 'ENCFF883IEF.hg19'
# NAME <- 'ENCFF883IEF.hg38'
NAME <- 'GSM3003539.merged'

OUT_DIR <- '../results/'

###

bed_df <- read.delim(paste0('../data/', NAME, '.bed'), as.is = TRUE, header = FALSE)
colnames(bed_df) <- c('chrom', 'start', 'end')
bed_df$len <- bed_df$end - bed_df$start

ggplot(bed_df) +
    aes(x = len) +
    geom_histogram() +
    ggtitle(NAME, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
    theme_bw()

ggsave(paste0('len_hist.', NAME, '.pdf'), path = OUT_DIR)
