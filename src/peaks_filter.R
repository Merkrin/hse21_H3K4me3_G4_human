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

NAME <- 'ENCFF881GRS.hg19'
# NAME <- 'ENCFF883IEF.hg19'

OUT_DIR <- '../results/'
DATA_DIR <- '../data/'

###

bed_df <- read.delim(paste0(DATA_DIR, NAME, '.bed'), as.is = TRUE, header = FALSE)
colnames(bed_df) <- c('chrom', 'start', 'end', 'name', 'score')
bed_df$len <- bed_df$end - bed_df$start
head(bed_df)

ggplot(bed_df) +
    aes(x = len) +
    geom_histogram() +
    ggtitle(NAME, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
    theme_bw()
ggsave(paste0('filter_peaks.', NAME, '.init.hist.pdf'), path = OUT_DIR)

# Remove long peaks
bed_df <- bed_df %>%
    arrange(-len) %>%
    filter(len < 5000)

ggplot(bed_df) +
    aes(x = len) +
    geom_histogram() +
    ggtitle(NAME, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
    theme_bw()
ggsave(paste0('filter_peaks.', NAME, '.filtered.hist.pdf'), path = OUT_DIR)

bed_df %>%
    select(-len) %>%
    write.table(file=paste0(DATA_DIR, NAME ,'.filtered.bed'),
                col.names = FALSE, row.names = FALSE, sep = '\t', quote = FALSE)