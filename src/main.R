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
# NAME <- '.ENCFF883IEF.hg19'
# NAME <- 'ENCFF883IEF.hg38'

OUT_DIR <- '../results/'

###

bed_df <- read.delim(paste0('../data/', NAME, '.bed'), as.is = TRUE, header = FALSE)
colnames(bed_df) <- c('chrom', 'start', 'end')
bed_df$len <- bed_df$end - bed_df$start

head(bed_df)

bed_df <- bed_df %>%
    arrange(-len) %>%
    filter(len < 50000)

ggplot(bed_df) +
    aes(x = len) +
    geom_histogram() +
    ggtitle(NAME, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
    theme_bw()
ggsave(paste0('len_hist.', NAME, '.pdf'), path = OUT_DIR)

#
#bed_df %>%
#    select(-len) %>%
#    write.table(file='data/H3K4me3_A549.ENCFF832EOL.hg19.filtered.bed',
#                col.names = FALSE, row.names = FALSE, sep = '\t', quote = FALSE)
#
