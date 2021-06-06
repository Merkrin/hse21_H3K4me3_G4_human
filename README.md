# hse21_H3K4me3_G4_human

## Проект по майнору "Биоинформатика"
### Барчук Ирина, группа 2

#### Выбранные структуры

| Организм | Структура ДНК | Гистоновая метка | Тип клеток | Метка 1 | Метка 2 |
| -------- | ------------- | ---------------- | ---------- | ------- | ------- |
| Human (hg19) | G4_seq_Li_K | H3K4me3 | H1 | [ENCFF883IEF](https://www.encodeproject.org/files/ENCFF883IEF/) | [ENCFF881GRS](https://www.encodeproject.org/files/ENCFF881GRS/) |

#### Анализ пиков гистоновой метки
##### Подготовка данных

Для последующей работы на кластер в личную директорию iabarchuk/project были сохранены архивы с .bed-файлами с данными. При распаковке архивов были оставлены только первые 5 столбцов данных:

```bash
wget https://www.encodeproject.org/files/ENCFF883IEF/@@download/ENCFF883IEF.bed.gz
zcat ENCFF883IEF.bed.gz  |  cut -f1-5 > ENCFF883IEF.hg38.bed

wget https://www.encodeproject.org/files/ENCFF881GRS/@@download/ENCFF881GRS.bed.gz
zcat ENCFF881GRS.bed.gz  |  cut -f1-5 > ENCFF881GRS.hg38.bed
```

Далее координаты ChIP-seq пиков были приведены к 19 версии генома:

```bash
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz

liftOver   ENCFF883IEF.hg38.bed   hg38ToHg19.over.chain.gz   ENCFF883IEF.hg19.bed   ENCFF883IEF.unmapped.bed
liftOver   ENCFF881GRS.hg38.bed   hg38ToHg19.over.chain.gz   ENCFF881GRS.hg19.bed   ENCFF881GRS.unmapped.bed
```

Затем с помощью команды `scp -P` все полученные файлы были загружены на ПК для дальнейшей работы.

##### Построение гистограмм длин участков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/length_hists.R) на языке программирования R были получены гистограммы длин участков для каждого эксперимента до и после конвертации к нужной версии генома. Были получены следующие результаты:

![len_hist_ENCFF883IEF_hg19](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/len_hist_ENCFF883IEF_hg19.png)

![len_hist_ENCFF881GRS_hg19](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/len_hist_ENCFF881GRS_hg19.png)

##### Фильтрация пиков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/peaks_filter.R) на языке программирования R были отфильтрованы пики длиной более 5000. Были получены следующие результаты:

![filter_peaks_ENCFF883IEF_hg19_filtered_hist](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/filter_peaks_ENCFF883IEF_hg19_filtered_hist.png)

![filter_peaks_ENCFF881GRS_hg19_filtered_hist](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/filter_peaks_ENCFF881GRS_hg19_filtered_hist.png)

##### Расположение пиков

С помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/chip_seeker.R) на языке программирования R были построены графики расположения пиков гистоновых меток относительно аннотированных генов. Были получены следующие результаты:

![chip_seeker.ENCFF883IEF.hg19.filtered.plotAnnoPie](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/chip_seeker.ENCFF883IEF.hg19.filtered.plotAnnoPie.png)

![chip_seeker.ENCFF881GRS.hg19.filtered.plotAnnoPie](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/chip_seeker.ENCFF881GRS.hg19.filtered.plotAnnoPie.png)

##### Объединение файлов

Отсортированные файлы были загружены на кластер в личную директорию iabarchuk/project, отсортированы и объединены с помощью bedtools:

```bash
wget https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF881GRS.hg19.filtered.bed
wget https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF883IEF.hg19.filtered.bed

cat  *.filtered.bed  |   sort -k1,1 -k2,2n   |   bedtools merge   >  merged.hg19.bed 
```

Затем с помощью команды `scp -P` полученный файл был загружен на ПК для дальнейшей работы.

##### Визуализация

С помощью [Genome Browser](http://genome-euro.ucsc.edu/s/stellaFortuna/H3K4me3_G4_human) были визуализированы полученные исходные наборы ChIP-seq пиков и их объединение:

```
track visibility=dense name="ENCFF573MUH"  description="ENCFF881GRS.hg19.filtered.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF881GRS.hg19.filtered.bed

track visibility=dense name="ENCFF832EOL"  description="ENCFF883IEF.hg19.filtered.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF883IEF.hg19.filtered.bed

track visibility=dense name="ChIP_merge"  color=50,50,200   description="merge.hg19.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/merged.hg19.bed
```

![hgt_genome_euro_2194f_b8def0](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/hgt_genome_euro_2194f_b8def0.png)

Как может быть видно, объединение покрывает все наборы.

#### Анализ участков вторичной структуры ДНК

На кластер в личную директорию iabarchuk/project были сохранены архивы с .bed-файлами с данными вторичной структуры ДНК:

```bash
wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3003nnn/GSM3003539/suppl/GSM3003539_Homo_all_w15_th-1_minus.hits.max.K.w50.25.bed.gz

wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3003nnn/GSM3003539/suppl/GSM3003539_Homo_all_w15_th-1_plus.hits.max.K.w50.25.bed.gz
```

Для последующей работы они были распакованы (с удалением не нужных для работы столбцов) и объединены в один файл с помощью bedtools:

```bash
zcat GSM3003539_Homo_all_w15_th-1_minus.hits.max.K.w50.25.bed.gz | cut -f1-5 > GSM3003539_minus.bed
zcat GSM3003539_Homo_all_w15_th-1_plus.hits.max.K.w50.25.bed.gz | cut -f1-5 > GSM3003539_plus.bed

cat GSM3003539_*.bed | sort -k1,1 -k2,2n | bedtools merge > GSM3003539.merged.bed 
```
Затем с помощью команды `scp -P` полученный файл был загружен на ПК для дальнейшей работы.

Далее с помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/length_hists.R) на языке программирования R была получена гистограмма длин участков. Были получены следующие результаты:

![len_hist.GSM3003539.merged](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/len_hist.GSM3003539.merged.png)

Также с помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/chip_seeker.R) на языке программирования R был построен график расположения пиков относительно аннотированных генов. Были получены следующие результаты:

![chip_seeker.GSM3003539.merged.plotAnnoPie](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/chip_seeker.GSM3003539.merged.plotAnnoPie.png)

#### Анализ пересечений гистоновой метки и структуры ДНК

С помощью bedtools были найдены пересечения гистоновой метки со структурами ДНК:
```bash
bedtools intersect -a GSM3003539.merged.bed -b merged.hg19.bed > intersect.bed
```

Затем с помощью команды `scp -P` полученный файл был загружен на ПК для дальнейшей работы.

С помощью [Genome Browser](http://genome-euro.ucsc.edu/s/stellaFortuna/H3K4me3_G4_human) были визуализированы полученные участки:

```
track visibility=dense name="ENCFF573MUH"  description="ENCFF881GRS.hg19.filtered.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF881GRS.hg19.filtered.bed

track visibility=dense name="ENCFF832EOL"  description="ENCFF883IEF.hg19.filtered.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/ENCFF883IEF.hg19.filtered.bed

track visibility=dense name="ChIP_merge"  color=50,50,200   description="merge.hg19.bed"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/merged.hg19.bed

track visibility=dense name="GSM3003539"  color=0,200,0  description="GSM3003539"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/GSM3003539.merged.bed

track visibility=dense name="GSM3003539_intersect"  color=100,100,0  description="GSM3003539"
https://raw.githubusercontent.com/Merkrin/hse21_H3K4me3_G4_human/main/data/intersect.bed
```

На скриншоте видны пересечения между гистоновой меткой и структурой ДНК:

![hgt_genome_euro_10b04_c9b5d0](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/results/hgt_genome_euro_10b04_c9b5d0.png)

Это, например:

| Позиция | Координаты |
| ------- | ---------- |
| 1 | chr20:57463826-57463960 |
| 2 | chr20:57466901-57466945 |

Далее с помощью [скрипта](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/peaks_annotation.R) на языке программирования R полученные пересечения были ассоциированы с ближайшими генами. Было проассоциировано 14965 пиков, 8962 уникальных гена.

С помощью [Panther](http://pantherdb.org/) был проведён GO-анализ для полученных уникальных генов. В [файле](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/data/pantherdb_GO_analysis.txt) представлен результат анализа. Далее приведены несколько самых значимых категорий:

| Homo sapiens - REFLIST (20595) | intersect.genes_uniq.txt (8324) | intersect.genes_uniq.txt (expected) | intersect.genes_uniq.txt (over/under) | intersect.genes_uniq.txt (fold Enrichment) | intersect.genes_uniq.txt (raw P-value) | intersect.genes_uniq.txt (FDR) |
| ------------------------------ | ------------------------------- | ----------------------------------- | ------------------------------------- | ------------------------------------------ | -------------------------------------- | ------------------------------ |
| 486.0	 | 0.0 | 196.43 | - | < 0.01 | 8.090000e-73 | 1.280000e-68 |
| 441.0	 | 0.0 | 178.24 | - | < 0.01 | 3.130000e-66 | 2.480000e-62 |
| 522.0	 | 12.0 | 210.98 | - | .06 | 9.470000e-61 | 4.990000e-57 |

Представленные результаты были получены с помощью [кода](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/src/go_analysis_results.ipynb) на языке программирования Python. Для его работы использовался изменённый [файл](https://github.com/Merkrin/hse21_H3K4me3_G4_human/blob/main/data/analysis_data.txt) с результатами анализа (удалены первые строки с информацией о версии и т.п.).
